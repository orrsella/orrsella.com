---
layout: post
title:  Getting Started With Pants Build for Scala Projects
---

I've recently been examining a new build tool for large JVM projects (specifically tools aimed at monorepos). There is actually a surprising amount of options for such a task: Google's [Bazel](http://bazel.io/), Facebook's [Buck](http://buckbuild.com/), and Twitter's [Pants Build](https://pantsbuild.github.io/) (with contribution from Foursquare and Square) are among the most popular.

When you start reading the docs for each of them, you get a sense of Déjà vu. And it's for a good reason – all three were modeled after [Google's internal build tool](http://google-engtools.blogspot.com/2011/08/build-in-cloud-how-build-system-works.html)  Blaze.

From Bazel's [FAQ](http://bazel.io/faq.html):

> **What's up with the word "Blaze" in the codebase?**
>
> This is an internal name for the tool. Please refer to Bazel as Bazel.

and Pants' [overview](https://pantsbuild.github.io/first_concepts.html):

> [...] Pants models code modules (known as "targets") and their dependencies in BUILD files—in a manner similar to Google's internal build system. [...]

After going through quite a lot of the docs, I decided to give Pants a try. Besides having a decent amount of documentation, a deployable you can simply install (and not have to build from source), and being actively developed, Pants [supports Scala](https://pantsbuild.github.io/scala.html) out-of-the-box, which is exactly what I'm looking for.

After throughly reading the [Overview](https://pantsbuild.github.io/first_concepts.html) and [Tutorial](https://pantsbuild.github.io/first_tutorial.html), I got to Pants' [Installation page](https://pantsbuild.github.io/install.html), which begins with the following statement:

> As of September 2014, alas, Pants is not something you can just install and use. To be precise: you can install it, but unless you've also [Set up your code workspace to work with Pants](https://pantsbuild.github.io/setup_repo.html), it won't work. You can use it in a workspace in which some Pants expert has set it up.
>
> We're fixing this problem, but we're not done yet.
>
> If want to try out Pants and no Pants expert has set it up for you, you might try [https://github.com/twitter/commons](https://github.com/twitter/commons).

They are not exaggerating – it really won't work ;)

So that's exactly what I did – used [existing projects with Pants](https://github.com/search?q=filename%3Apants+extension%3Aini&ref=searchresults&type=Code&utf8=%E2%9C%93) as their build tool to understand the minimal setup required for a Pants Build project. It wasn't easy, but eventually payed off. I reduced everything into one small project, which can be found here: [pants-getting-started](https://github.com/orrsella/pants-getting-started).

This simple project, which has one [code file](https://github.com/orrsella/pants-getting-started/blob/master/example/src/main/scala/com/example/HelloWorld.scala), and two [tests](https://github.com/orrsella/pants-getting-started/tree/master/example/src/test/scala/com/example), requires the following:

* `BUILD.tools`
* `pants.ini`
* `ivysettings.xml`
* 7 `3rdparty` dependencies
* 10 `BUILD` files

Aside from the cumbersome bootstrapping experience, I'm really enjoying working with Pants so far, and would definitely recommend that you check it out. Want to get started? Use this quick template as a starting point: [https://github.com/orrsella/pants-getting-started](https://github.com/orrsella/pants-getting-started).

### TL;DR

{% highlight bash %}
$ pip install pantsbuild.pants
$ git clone git@github.com:orrsella/pants-getting-started.git
$ cd pants-getting-started/
$ pants test example:
{% endhighlight %}
