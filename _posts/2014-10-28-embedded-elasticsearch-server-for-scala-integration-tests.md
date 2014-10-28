---
layout: post
title:  Embedded Elasticsearch Server for Scala Integration Tests
---

[Integration tests](http://en.wikipedia.org/wiki/Integration_testing) are used to check how our code works against code we can't change. As described in [GOOS](http://www.growing-object-oriented-software.com/):

> We use the term integration tests to refer to the tests that check how some of our code works with code from outside the team that we can’t change. It might be a public framework, such as a persistence mapper, or a library from another team within our organization. The distinction is that integration tests make sure that any abstractions we build over third-party code work as we expect.

A classic example for an Integration Test is for a [`Dao` class](http://en.wikipedia.org/wiki/Data_access_object). Let's assume that we have some abstract `PersonDao` trait, that defines how we store, fetch, and search for `Person`s. A hypothetical application could have an implementation of that trait: `ElasticsearchPersonDao` which abstracts over [Elasticsearch](http://www.elasticsearch.org/).

To make sure that our `Dao` implementation works with Elasticsearch as intended and that it fulfills the `PersonDao` contract, we should have an Integration Test. During that test we want to run against an actual instance of Elasticsearch, as close to the real thing as possible. One way to achieve this is to have our test bring-up an embedded server version of Elasticsearch, have the `Dao` work against that server, and then shut it down.

Doing so for Elasticsearch is particularly easy since Elasticsearch is [written in Java](http://www.elasticsearch.org/guide/en/elasticsearch/client/java-api/master/java-api.html). Let's see how to do this:

{% highlight scala %}
package com.example

import java.nio.file.Files
import org.apache.commons.io.FileUtils
import org.elasticsearch.client.Client
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.node.NodeBuilder._

class ElasticsearchServer {

  private val clusterName = "elasticsearch"
  private val dataDir = Files.createTempDirectory("elasticsearch_data_").toFile
  private val settings = ImmutableSettings.settingsBuilder
    .put("path.data", dataDir.toString)
    .put("cluster.name", clusterName)
    .build

  private lazy val node = nodeBuilder().local(true).settings(settings).build
  def client: Client = node.client

  def start(): Unit = {
    node.start()
  }

  def stop(): Unit = {
    node.close()

    try {
      FileUtils.forceDelete(dataDir)
    } catch {
      case e: Exception => // dataDir cleanup failed
    }
  }

  def createAndWaitForIndex(index: String): Unit = {
    client.admin.indices.prepareCreate(index).execute.actionGet()
    client.admin.cluster.prepareHealth(index).setWaitForActiveShards(1).execute.actionGet()
  }
}
{% endhighlight %}

Let's see what's going on here. First of all this code assumes that you have Elasticsearch as a [dependency](http://www.elasticsearch.org/guide/en/elasticsearch/client/java-api/master/_maven_repository.html) (which you probably do since you're using it as your datastore...). It also uses apache  `commons-io` `FileUtils` (version 2.4) for performing directory cleanup. If this is a problem you can easily write this cleanup code yourself.

After creating the settings, a `nodeBuilder` is used to create a `local` Elasticsearch `Node`. A `Node` can be used as a [way to connect](http://www.elasticsearch.org/guide/en/elasticsearch/client/java-api/current/client.html) to an existing Elasticsearch cluster, or it can form a cluster. To start the `Node` we use the `start/stop` methods. Notice that the `node` is a `lazy val`, which means it isn't initialized until accessed. After starting the node, the `client` can be passed to the `Dao` object, which wouldn't be able to tell if it's talking to a remote cluster or a local node – exactly what we want.

The `createAndWaitForIndex` convenience method helps us create the `index` we're going to use during the test setup, otherwise an `IndexMissingException` will be thrown and fail the test.

Let's see how a test would use the `ElasticsearchServer` to exercise the `Dao` (this example uses the [specs2](http://etorreborre.github.io/specs2/) test library):

{% highlight scala %}
package com.example

import java.util.UUID
import org.specs2.mutable.Specification
import org.specs2.specification.Scope

class ElasticsearchPersonDaoIntegrationTest
  extends Specification
  with PersonMatchers {

  val server = new ElasticsearchServer

  trait Context extends Scope {
    val dao = new ElasticsearchPersonDao(server.client)
  }

  step {
    server.start()
    server.createAndWaitForIndex("persons")
  }

  "Elasticsearch person dao" should {
    "return None for a non-existing person" in new Context {
      val person: Option[Person] = dao.get(UUID.randomUUID)
      person must beNone
    }

    "create and then return a person" in new Context {
      val id: UUID = dao.add(name = "John")
      val person = dao.get(id)
      person must beSome[Person]
      person must haveName("John")
    }
  }

  step {
    server.stop()
  }
}
{% endhighlight %}

A few notes:

* We are using [specs2's `step`s](http://etorreborre.github.io/specs2/guide/org.specs2.guide.Structure.html#Steps) for bringing-up and tearing-down our embedded server.
* The use of `Context` provides us with variable isolation between every test case. A new `Dao` object is created every time, but it always uses the same `client` to connect to our `Node`.
* Our second test case checks both the `add` and `get` functions of the `Dao`.
* We're using custom `PersonMatchers` to make the second test assertion a little nicer. These could go a long way for complex/nested data objects.

That's all you need to start creating Elasticsearch Integration Tests. All that's left is implementing the `Dao` itself. Having comprehensive datastore ITs will enable you seamlessly swipe out your datastore for another one, assuming your Integration Test passes for all of them. The exact same test could be used to test a hypothetical `MySqlPersonDao`, only with a different embedded server. If such a scenario arises, you should make the test abstract and run it for both `Dao`s.
