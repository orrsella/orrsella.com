---
layout: post
title:  Scala Development Using Sublime Text 2
---

I love [Sublime Text](http://www.sublimetext.com). It’s a fantastic text editor. And, as I’ve written about before, I use it for all my development. As I put it [back in October](/2012/10/my-top-10-mac-apps):

> By far the best text editor for mac. I use it for all my coding. You obviously lose some functionality in comparison to full-fledged IDEs (like IntelliJ), but the core functionality + the wide range of plugins make up for it. Also, I just love how much more productive I am in this minimalistic and bare-bones environment.

I still stand by this description. For Scala development, I find that the combination of Sublime as the text editor and [sbt](http://www.scala-sbt.org) as the build tool, is a winning combination.

As it turns out, I’m not alone in this thinking. Following the Coursera course on [Functional Programming Principles in Scala](https://class.coursera.org/progfun-2012-001), Heather Miller and Martin Odersky posted an article titled [Impressions and Statistics](http://docs.scala-lang.org/news/functional-programming-principles-in-scala-impressions-and-statistics.html). It’s a pretty interesting read, with many stats on the course itself and the participants (the raw data is [available on GitHub](https://github.com/heathermiller/progfun-stats) if you’re interested). In the post-course survey, participants were asked “which editor do you normally use?”. A total of 6% responded Sublime, which amounts to 3000 people of the total 50,000 registered students. Also, about 35% said they don’t use one of the “proper” IDEs out there (mainly IntelliJ and Eclipse).

Which brings me to my main point. One of the things I miss the most when using Sublime and not IntelliJ (for instance) is the lack of integration with external dependencies. A lot of times I like to peek at the source code of the libraries I’m working with. Sometimes it’s to see how certain things were implemented, a lot of times it’s to see a class’ interface and available fields/functions. I can do all this on the library’s GitHub repo/website, but this is uncomfortable. It takes you out of the context you’re currently in.

Here’s how IntelliJ allows you to browse the source code of your external library dependencies:

![IntelliJ External Libraries]({{ site.baseurl }}/static/img/intellij.png)

and this is exactly what I want to be able to do in Sublime – have all the external sources available for me in the same project windows. So this is exactly what I did, and I packaged this functionality into a new sbt plugin: [sbt-sublime](https://github.com/orrsella/sbt-sublime).

The new plugin generates a Sublime project file for your sbt project, downloads all available dependencies’ sources, and adds them to the project in a very similar way to how IntelliJ does it:

![Sublime Text with sbt-sublime]({{ site.baseurl }}/static/img/sublime.png)

As you can see, both screenshots are for [Twitter’s bijection](https://github.com/twitter/bijection) repo. The generated Sublime project adds the “External Libraries” folder with all the sources. The difference in the dependencies list between the two screenshots, is that IntelliJ, by default, displays all dependencies transitively, that is the entire dependency stack (including the dependencies of your own dependencies). sbt-sublime, on the other hand, displays by default only your immediate dependencies. This, and other parameters, can be [easily configured](https://github.com/orrsella/sbt-sublime#configuration).

So that’s it. If you’re using Sublime Text for Scala development, I encourage you to [try out the plugin](https://github.com/orrsella/sbt-sublime). Once you have it you just: 1) clone a repo 2) run “sbt gen-sublime”, and 3) you’re ready to go with a Sublime project with all dependencies.

If you’re using some other text editor for Scala development, It’s probably pretty easy to adapt this plugin to create other project types. All you need to do is create a new project, add the root directory and the external sources directory.

For more information and important notes please check out the [project page on GitHub](https://github.com/orrsella/sbt-sublime).

**UPDATE:** Sublime Text 3 Beta has [just been announced](http://www.sublimetext.com/blog/articles/sublime-text-3-beta). One of the great new features is Goto Definition, which allows you to navigate to the definition of any class/trait/interface/method/etc. I already tested it and it seems to work very good (the beta is available to current licensed users). This new feature only enhances the great need for sbt-sublime – you can now navigate to external sources that more easily, and only having the sources available in the Sublime project enables Sublime to index them.
