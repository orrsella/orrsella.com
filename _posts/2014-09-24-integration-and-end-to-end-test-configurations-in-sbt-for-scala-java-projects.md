---
layout: post
title:  Integration and End-to-End Test Configurations in SBT for Scala/Java Projects
---

It is common to have three levels of tests:

1. Unit Tests – Checking if your objects do the right thing, if they work correctly. Usually tests methods/classes/small clusters of classes.

2. Integration Tests – Testing if your code works against code that you can't change (3rd party or internal code that you can't influence). Are your abstractions over that 3rd party code correct and used as intended?

3. End-to-End Tests – Checking if the whole system works and composes correctly.

When developing using TDD, I find it very useful to be able to choose which type of tests to run. Each kind of testing has its own trade-offs, and I sometimes find myself wanting to run a specific group of tests (for example: only quickly running unit tests and not end-to-end tests, which take far longer to complete).

To achieve this, here is how I like to structure my projects:

{% highlight text %}
src
├── e2e
├── it
├── main
├── test
└── ...
{% endhighlight %}

This is the typical [Maven directory layout ](http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html), with the additional testing source roots. I place my unit tests under the `test/` source directory and name them `*Test`, my integration tests under `it/` and named `*IntegrationTest`, and – unsurprisingly – end-to-end tests under `e2e/` and named `*EndToEndTest`.

This separation clearly divides the types of tests and allows granularity in running them. Here is how to configure this in SBT using `.scala` [build configuration](http://www.scala-sbt.org/0.13.5/docs/Getting-Started/Full-Def.html):

{% highlight scala %}
// project/Configs.scala

import sbt._

object Configs {
  val IntegrationTest = config("it") extend(Runtime)
  val EndToEndTest = config("e2e") extend(Runtime)
  val all = Seq(IntegrationTest, EndToEndTest)
}
{% endhighlight %}

{% highlight scala %}
// project/Testing.scala

object Testing {
  lazy val testAll = TaskKey[Unit]("test-all")

  private lazy val itSettings =
    inConfig(IntegrationTest)(Defaults.testSettings) ++
    Seq(
      fork in IntegrationTest := false,
      parallelExecution in IntegrationTest := false,
      scalaSource in IntegrationTest := baseDirectory.value / "src/it/scala")

  private lazy val e2eSettings =
    inConfig(EndToEndTest)(Defaults.testSettings) ++
    Seq(
      fork in EndToEndTest := false,
      parallelExecution in EndToEndTest := false,
      scalaSource in EndToEndTest := baseDirectory.value / "src/e2e/scala")

  lazy val settings = itSettings ++ e2eSettings ++ Seq(
    testAll <<= (test in EndToEndTest).dependsOn((test in IntegrationTest).dependsOn(test in Test))
  )
}
{% endhighlight %}

When defining your projects, add the new configs and settings:

{% highlight scala %}
import sbt._
import sbt.Keys._

object TheBuild extends Build {
  lazy val root = Project("root", file("."))
    .configs(Configs.all: _*)
    .settings(Testing.settings: _*)
}
{% endhighlight %}

Then to run only a specific test configuration (end-to-end for example):

{% highlight bash %}
$ sbt> e2e:test
{% endhighlight %}

We also added the `testAll` task, so we can run all tests together:

{% highlight bash %}
$ sbt> test-all
{% endhighlight %}

If you need more examples you can check out my [scala-e2e-testing](https://github.com/orrsella/scala-e2e-testing/tree/master/memento/project) sample project, which shows how to test your Scala apps end-to-end, and uses this project structure.
