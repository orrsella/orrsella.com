---
layout: post
title:  The Default Scala Seq Is Mutable. Wait, What?!
---

Scala's default `Seq` class is mutable. Yes, you read that right. I think it's an extremely important thing to be aware of, and I'm not sure it's known widely enough. I've encountered experienced Scala devs that did not know this.

I recently submitted the [following addition](https://github.com/twitter/effectivescala/pull/37) to Twitter's [Effective Scala](http://twitter.github.io/effectivescala/) guide, under the [Collections section](http://twitter.github.io/effectivescala/#Collections-Use):

> A word of caution: the *default* `Traversable`, `Iterable` and `Seq` types in scope – defined in `scala.package` – are the `scala.collection` versions, as opposed to `Map` and `Set` – defined in `Predef.scala` – which are the `scala.collection.immutable` versions. This means that, for example, the default `Seq` type can be both the immutable *and* mutable implementations. Thus, if your method relies on a collection parameter being immutable, and you are using `Traversable`, `Iterable` or `Seq`, you *must* specifically require/import the immutable variant, otherwise someone *may* pass you the mutable version.

Within your own code this isn't a *huge* problem, though you could certainly shoot yourself in the foot by not realizing this. It becomes much more of an issue when designing APIs. If your API accepts a `Seq`, and you need it to be immutable, say for thread-safety concerns or "purity", then unless you specifically import `scala.collection.immutable.Seq`, your function will accept both `scala.collection.mutable.Seq` and the immutable variant. It will leak mutability into an otherwise immutable interface.

I've seen multiple, fairly large, code bases which use `Seq`s all around, assuming they're immutable, but without specifically importing the immutable version. Just take a look at any Scala library on GitHub, and search for `Seq`. You'll see that most of them just use the default one in scope.

Say you identify this issue and decide you want to start using the immutable version. You might think: "Hey, I'll just import the immutable version and be done with it". Doing so, you'll quickly realize that this requires *massive* changes to *so many* source files – you'll be surprised how many files you'll need to change to switch to the immutable variant. Every class that has `Seq` written in it will require the `import` addition.

So what should you do? You should build your application from the ground-up using `scala.collection.immutable.Seq` everywhere applicable. It might feel boilerplate-y to do so, but trust me – you'll thank yourself down the road.

Why does Scala default to `collection.Seq` instead of `immutable.Seq`? It is required for working with `Array`s and `varargs`. If you're interested, there's a lengthy discussion about it on the [Scala mailing list](https://groups.google.com/forum/#!topic/scala-internals/g_-gIWgB8Os) which includes Martin Odersky, Jonas Bonér, Paul Phillips, Daniel Spiewak and others weighing in.
