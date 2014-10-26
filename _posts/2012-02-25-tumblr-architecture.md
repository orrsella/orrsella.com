---
layout: post
title:  Tumblr Architecture – 15 Billion Page Views A Month
---

[Fascinating stuff](http://highscalability.com/blog/2012/2/13/tumblr-architecture-15-billion-page-views-a-month-and-harder.html)! So interesting that I’ve already read it twice, and have it bookmarked and Instapapered. Such a long, thorough and honest look into the architecture of one of the hottest web startups around isn’t something you see every day.

This sort of article makes me want to leave everything and join [Tumblr Engineering](http://engineering.tumblr.com).

The numbers are just mind-blowing:

> **Stats**
>
> * 500 million page views a day
> * 15B+ page views month
> * ~20 engineers
> * Peak rate of ~40k requests per second
> * 1+ TB/day into Hadoop cluster
> * Many TB/day into MySQL/HBase/Redis/Memcache
> * Growing at 30% a month
> * ~1000 hardware nodes in production
> * Billions of page visits per month per engineer
> * Posts are about 50GB a day. Follower list updates are about 2.7TB a day.
> * Dashboard runs at a million writes a second, 50K reads a second, and it is growing.

Also, the partial list of the software they use makes you appreciate the complexity of this system:

> **Software**
>
> * OS X for development, Linux (CentOS, Scientific) in production
> * Apache
> * PHP, Scala, Ruby
> * Redis, HBase, MySQL
> * Varnish, HA-Proxy, nginx,
> * Memcache, Gearman, Kafka, Kestrel, Finagle
> * Thrift, HTTP
> * Func – a secure, scriptable remote control framework and API
> * Git, Capistrano, Puppet, Jenkins

A [must read](http://highscalability.com/blog/2012/2/13/tumblr-architecture-15-billion-page-views-a-month-and-harder.html) for any frontend/backend dev. Have I said how fascinating this is?

**UPDATE:** Following this article, and because of my interest in Scala (thanks to this piece), I created [tumblr4s – a Scala library for the Tumblr API](/2012/12/introducing-tumblr4s-a-scala-library-for-the-tumblr-api).
