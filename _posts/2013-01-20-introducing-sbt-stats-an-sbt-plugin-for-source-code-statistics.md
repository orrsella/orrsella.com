---
layout: post
title:  "Introducing sbt-stats: An SBT Plugin for Source Code Statistics"
---

One of the first and most obvious selling-points of Scala to Java developers are its brevity and conciseness. A classic example, as found in Odersky’s [Programming in Scala, 2nd Edition](http://www.artima.com/shop/programming_in_scala_2ed), is of a class with two public read-only properties. In Java this would look like:

{% highlight java %}
// this is Java
class MyClass {
  private int index;
  private String name;

  public MyClass(int index, String name) {
    this.index = index;
    this.name = name;
  }
}
{% endhighlight %}

And the Scala version:

{% highlight scala %}
// this is Scala
class MyClass(index: Int, name: String)
{% endhighlight %}

Even without counting blank and closing-brace lines, the Java version is 6 times longer. Obviously this is a very specific example of boilerplate code that Scala gives us for “free”, but the core concept of succinctness can be found throughout Scala. This is a principle I value very much, and I try very hard to have my own code concise yet readable (a tricky sweet spot).

So after I had [completed my Scala library](/2012/12/introducing-tumblr4s-a-scala-library-for-the-tumblr-api) for Tumblr’s API – [tumblr4s](https://github.com/orrsella/tumblr4s) – I was curious how it stacked up, in terms of the amount of code needed to implement the entire functionality of the Tumblr API, against other Java implementations which have equivalent functionality.

Before starting to write a Scala library for the Tumblr API, I researched existing alternatives (the whole [reason I wrote it](/2012/12/introducing-tumblr4s-a-scala-library-for-the-tumblr-api) was because I couldn’t find a Scala version). During my research I came across [tumblr-java](https://github.com/nsheridan/tumblr-java) which is exactly as it sounds. So I wanted to compare the size of both projects’ source code.

I wanted to break my comparison down to a few parameters: number of files, lines and characters, and also calculate some averages. I also wanted some raw file-size numbers just for the sake of it.

Now I use [Sublime Text 2](http://www.sublimetext.com/2) for all [my development](/2012/10/my-top-10-mac-apps). As far as I know and could research, it doesn’t have any built-in functionality or plugin that enables me to get the stats I wanted. I could use some clever [searching using regular expressions](http://www.sublimetext.com/forum/viewtopic.php?f=2&t=8299, but it wouldn’t provide exactly what I wanted. I also wanted to only analyze source code – Scala and Java files – without counting sbt build files, testing code, etc.

So my next move was to find an sbt plugin which does this. Surely there had to be a plugin that provided such functionality I thought. Such a plugin seemed like a perfect fit in my mind. And again I couldn’t find any, and that’s when I decided to write it myself: [sbt-stats](https://github.com/orrsella/sbt-stats).

The sbt-stats plugin adds the “stats” task to sbt, and is meant to be run from the sbt console (it’s return type is Unit and it outputs the results using state.log). The task is scoped to either the Compile or Test configurations, so you can get statistics on your source or testing code, but it’s obviously most interesting for Compile. The idea is to get a high-level view of the project (see sample output below and on the [project page](https://github.com/orrsella/sbt-stats#usage)).

In addition to providing some basic stats as default, I made it pretty easy to extend. Some uses for it could be more advanced analysis, such as counting the number of classes, traits, methods, etc. To do this all one needs to do is write a small Analyzer of his/her own in the basedir/project/ “project”, and add it to the build settings (see [Extending](https://github.com/orrsella/sbt-stats#extending)). This way you can enjoy the functionality without implementing the sbt plumbing yourself. If you have an idea for a great Analyzer let me know, or better yet – [add it yourself!](https://github.com/orrsella/sbt-stats)

And now for the comparison of tumbl4s – how did it stack up against tumblr-java?

Here are the results of the stats plugin for tumblr4s:

{% highlight text %}
[info] Code Statistics:
[info]
[info] Files
[info] - Total:      42 files
[info] - Scala:      42 files (100.0%)
[info] - Java:       0 files (0.0%)
[info] - Total size: 99 KB
[info] - Avg size:   2 KB
[info] - Avg length: 60 lines
[info]
[info] Lines
[info] - Total:      2,558 lines
[info] - Code:       928 lines (36.3%)
[info] - Comment:    1,465 lines (57.3%)
[info] - Blank:      165 lines (6.5%)
[info] - Bracket:    62 lines (2.4%)
[info]
[info] Characters
[info] - Total:      93,954 chars
[info] - Code:       32,336 chars (34.4%)
[info] - Comment:    61,618 chars (65.6%)
{% endhighlight %}

And for tumblr-java:

{% highlight text %}
[info] Code Statistics:
[info]
[info] Files
[info] - Total:      12 files
[info] - Scala:      0 files (0.0%)
[info] - Java:       12 files (100.0%)
[info] - Total size: 43 KB
[info] - Avg size:   4 KB
[info] - Avg length: 108 lines
[info]
[info] Lines
[info] - Total:      1,297 lines
[info] - Code:       580 lines (44.7%)
[info] - Comment:    587 lines (45.3%)
[info] - Blank:      130 lines (10.0%)
[info] - Bracket:    115 lines (8.9%)
[info]
[info] Characters
[info] - Total:      37,139 chars
[info] - Code:       20,910 chars (56.3%)
[info] - Comment:    16,229 chars (43.7%)
{% endhighlight %}

We can see that tumblr4s has 928 code lines and 32,336 code characters, while tumblr-java has 580 code lines and 20,910 code characters. This amounts to about 55/60% more code in tumblr4s (depends if you count by chars/lines, respectively). Ha? What gives? I thought Scala was supposed to be more concise than Java… :/

Let’s try to break down the results (read: give excuses). Here are possible explanations for the difference:

1. tumblr-java is about a year old. While it works with [Tumblr’s v2 API](http://www.tumblr.com/docs/en/api/v2) like tumblr4s, it doesn’t implement all its functionality. A few missing methods I quickly found: getBlogLikes, getSubmissionPosts, getTaggedPosts. It also doesn’t provide all available parameters for blog posts querying methods (like getBlogPosts, getQueuedPosts, etc.). Now this isn’t necessarily the developer’s fault – Tumblr keeps adding functionality to their API, without changing its version. I’ve noticed this during my own development, when a new end-point suddenly appeared in the docs (such additions are usually announced on the [Developer blog](http://developers.tumblr.com) which I subscribe to and hope to keep tumblr4s up-to-date). So the missing features could explain a small difference in code amount, but surely not all 50%.
2. Most of tumblr4s’ code resides in the “model” package (the main TumblrApi class, which implements most of the business logic, is 469 lines long, including a lot of comments). And most of the model is various types of Post classes (TextPost, ImagePost, etc. totalling 8 classes). Now, in-order for them to all be immutable (Functional Programming 101’s first lesson), they all redefine the common Post members (27 fields) in their constructors (I could not find a [better solution for this](http://stackoverflow.com/questions/12289806/scala-extending-parameterized-abstract-class), if you have an idea let me know!).
3. I am not an experienced enough Scala developer, and so the code can be rewritten in much better and concise ways.
4. The sbt-stats plugin is wrong.
5. The notion that Scala is more succinct is wrong.
6. Scala sucks (haters gonna hate).

I think the real reason is a mix of 1-3, and hopefully not 4 (perhaps I should add more unit tests? :). Obviously I don’t believe 5 and 6 are true, otherwise I wouldn’t be putting so much effort into Scala. But the real question should be – does this matter at all? Brevity and conciseness are important, but not more than clean, readable and testable code. I think I’ve achieved all those with tumblr4s, and so I’m proud of all 93,954 characters of it (including comments)!

Also, I’m happy I had the chance/reason to write [sbt-stats](https://github.com/orrsella/sbt-stats). It’s been fun, but most importantly it forced me to really read sbt’s [Getting Started](http://www.scala-sbt.org/0.13/docs/index.html) guide once again (3rd time’s the charm) and some of the detailed topics, and now I can say I truly understand how it works, and appreciate the amazing work and effort that has been put into this project.

Also, as a side bonus, I learned about publishing to OSS Sonatype (as usual, here’s an [excellent guide](http://www.cakesolutions.net/teamblogs/2012/01/28/publishing-sbt-projects-to-nexus) from Cake Solutions) and so sbt-stats and tumblr4s are now both available on the [Maven Central Repository](http://repo1.maven.org/maven2/com/orrsella) so they can be easily added to any project.

Check out [sbt-stats](https://github.com/orrsella/sbt-stats) and let me know if you have any feedback – I’d love to hear it.
