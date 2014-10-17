---
layout: post
title:  "Introducing tumblr4s: A Scala Library For The Tumblr API"
---

Back in February of this year I stumbled upon [an amazing article](/2012/02/tumblr-architecture) on HighScalability.com about Tumblr’s infrastructure. It’s a great read for many reasons (go read it). One of the greatest take-aways I had from this article, was this “new” programming language called Scala. I had never heard of Scala before, and was immediately intrigued. Also, after doing a lot of PHP back at the time – [which I hate](/2012/07/php-a-fractal-of-bad-design) – I wanted something new, fresh and fun.

I started reading “[Programming in Scala 2nd Ed](http://www.artima.com/shop/programming_in_scala_2ed)” by Martin Odersky – creator of Scala – and was completely [blown away](https://twitter.com/orrsella/statuses/206046022160490496) by the language’s beauty, design and powers. I became obsessed with it, reading dozens of articles and tutorials, going thru many open source projects and watching conference talks. I even started listening to [The Scala Types podcast](http://scalatypes.com). To top it off I attended the [Coursera course](https://class.coursera.org/progfun-2012-001) given by Odersky himself called “Functional Programming Principles in Scala” (which attracted over 50,000 developers).

Every coder knows that the best way to really learn a new programming language is to dive right in – start writing code and doing your first project. Seeing as I had Tumblr to thank for introducing me to Scala, I figured it was only appropriate I do something with it’s API for my first project. Unfortunately I couldn’t find any Scala library for the Tumblr API, so I figured I’d write it myself.

And so [tumblr4s](https://github.com/orrsella/tumblr4s) is my first Scala project. It’s supposed to be a simple, elegant and idiomatic Scala implementation for [Tumblr’s API](http://www.tumblr.com/docs/en/api/v2). The [GitHub repository](https://github.com/orrsella/tumblr4s/blob/master/README.md) has some examples on how to start using it. It’s pretty straight forward, and implements all the functionality of the Tumblr API.

I have put a lot of effort in to this, attempting to make it as “Scalaty” as possible. It took me a while to change my way of thinking from imperative/mutable to functional/immutable. In my code I tried to follow these concepts meticulously:

* Functional programming – everything is an expression, no side-effects
* Immutability – no use of vars and only immutable collections
* Conciseness
* Use the appropriate Scala tool in the appropriate place
* Not write Java code in Scala

I also tried to comply with the [Scala Style Guide](http://docs.scala-lang.org/style) as much as possible, mixed with some [Effective Scala](http://twitter.github.com/effectivescala) advice from Twitter.

And so I must say I’m pretty happy with the result. If you get a chance, please [check the library out](https://github.com/orrsella/tumblr4s) and let me know what you think. I’m especially interested in hearing the opinion of experienced Scala developers on some of the things I did, and if I should have done some things differently. I’d love your feedback.
