---
layout: post
title:  Integrating Play Framework and Maven
---

I recently had to integrate a [Play Framework](http://www.playframework.com/) project with a [Maven](http://maven.apache.org/)-based build process. This wasn't as straight-forward as I thought it would be, and so here's how I did it.

### TL;DR

Check out [this repo](https://github.com/orrsella/play-maven-integration) for a complete and working example.

### Requirements

The integration I was after had the following requirements:

* Multi-module project (separate the play "web app" module and the "core" module)
* All configuration should be via pom files, especially *dependencies*
* Allow working with Maven's [Dependency Management](http://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#Dependency_Management) which centralizes dependency information in parent poms
* Allow building/testing/running thru `$ mvn`
* Allow building/testing/running thru `$ play`
* Access all the special play commands thru maven

### Project Folder Structure

{% highlight text %}
my-application-core/
 └ pom.xml
 └ src/
my-application-play/
 └ pom.xml
 └ app/
 └ conf/
 └ public/
 └ test/
pom.xml
project/
 └ Build.scala
 └ Pom.scala
 └ build.properties
 └ plugins.sbt
{% endhighlight %}

### Maven

In order to compile scala and play in maven, we need to use three different plugins:

* `net.alchim31.maven.scala-maven-plugin` for compiling scala in the `core` module
* `com.google.code.play2-maven-plugin` for compiling/running the `play` module
* `org.apache.maven.plugins.maven-surefire-plugin` for running tests in both modules

Pom file examples:

* [`pom.xml`](https://github.com/orrsella/play-maven-integration/blob/master/pom.xml)
* [`my-application-core/pom.xml`](https://github.com/orrsella/play-maven-integration/blob/master/my-application-core/pom.xml)
* [`my-application-play/pom.xml`](https://github.com/orrsella/play-maven-integration/blob/master/my-application-play/pom.xml)

Using the `play2-maven-plugin` allows you to run play commands such as `run`, `start`, `dist`, etc. in maven by running:

{% highlight bash %}
$ mvn play2:dist -pl my-application-play
{% endhighlight %}

### Play

The `play` command is essentially just a wrapper around [sbt](http://www.scala-sbt.org). We configure sbt for multiple project, with the play project set as the root.

{% highlight scala %}
// Build.scala

import sbt._
import sbt.Keys._

object MyBuild extends Build {

  val core = Project("my-application-core", file("my-application-core"))
    .settings(
      version := Pom.version(baseDirectory.value),
      libraryDependencies ++= Pom.dependencies(baseDirectory.value))

  val root = play.Project("my-application-play", path = file("my-application-play"))
    .dependsOn(core)
    .settings(
      version := Pom.version(baseDirectory.value),
      libraryDependencies ++= Pom.dependencies(baseDirectory.value).filterNot(d => d.name == core.id))

  override def rootProject = Some(root)
}
{% endhighlight %}

There are a few interesting things here. First, notice that the `version` and `dependencies` are taken from the pom file by using the `Pom` object (see below). Second, you'll see that after adding the dependencies to the play project, the core project is filtered out. That's because the play project is already configured with `.dependsOn(core)` and so the dependency defined in the pom file isn't required (it also won't work otherwise because the `core` module can't be found).

{% highlight scala %}
// Pom.scala

import sbt._
import scala.xml.XML
import scala.language.postfixOps

object Pom {
  private val prefix = "[INFO]    "

  def version(pomDir: File): String = {
    val pom = new File(pomDir, "pom.xml")
    val xml = XML.loadFile(pom)
    val version = (xml \\ "project" \ "version").text
    version
  }

  def dependencies(pomDir: File): Seq[ModuleID] = {
    val list = (Process("mvn dependency:list", pomDir) !!)
    val lines = list.split("\n").collect {
      case line if (line.startsWith(prefix)) => line.replace(prefix, "").trim
    }
    lines.map(parse).collect { case Some(dep) => dep }
  }

  private def parse(line: String): Option[ModuleID] = {
    val parts = line.split(":")

    if (parts.size < 4) None
    else {
      val groupId = parts(0)
      val artifactId = parts(1)
      val revision = parts(parts.size - 2)
      val configuration = parts.last
      val dependency = (groupId % artifactId % revision % configuration) intransitive()

      if (parts.size > 5) {
        val cls = parts(parts.size - 3)
        Some(dependency classifier cls)
      } else Some(dependency)
    }
  }
}
{% endhighlight %}

This is where the most important thing happens – calculating the dependencies. Remember that one of the requirements is to have all dependencies defined in maven pom files. They can also be defined in parent pom file we're inheriting. *Its* parent (our grandparent) pom can *also* have dependencies defined or have the version of our dependencies defined (Dependency Management). This means that simply parsing the `pom.xml` file and adding the depdencies won't work – we need maven to resolve the dependencies using it's entire pom hierarchy.

This is exactly what we do – we run a process with `mvn dependency:list`, which evaluates all our dependencies and the ones we inherit from our parent. After getting the list, it's parsed line-by-line, and each is converted to an sbt `ModuleID`.

Every time the play (sbt) project is loaded/reloaded, the dependency list command will run and the dependencies will be added to the project. This means that reloading the project can take a little longer, depending on the number of dependencies you have.

Now we can add new dependencies in any of our pom files, run `$ play> reload`, and have it available in play.

### Bottom Line

Structuring your project this way allows you to enjoy both worlds – having a maven-based build, with access to all the `play` special commands, and using play as stand-alone tool for development/debugging/testing.

Check out [the complete example](https://github.com/orrsella/play-maven-integration) to see how it all fits together.
