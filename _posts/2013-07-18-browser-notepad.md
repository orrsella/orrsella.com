---
layout: post
title:  Browser Notepad
---

It's very easy and convenient to use your browser as a local notepad. This is nothing I invented – [it was](http://www.fizerkhan.com/blog/posts/Use-your-browser-as-Notepad.html) written [about](https://coderwall.com/p/lhsrcq) and [discussed](https://news.ycombinator.com/item?id=6005295) before. This is my own personal jab at a local notepad, and what I've been using recently on a daily basis. It's great for when you want to jot some quick stuff, while on the phone, to keep a short todo list, etc. You always have your browser open, so this makes sense. Just remember – when the tab closes the text's gone. If you need persistence, than this is not the tool for the job. (I use [Sublime Text](http://www.sublimetext.com) for that.)

In case you didn't read the previous posts, the way this works is by using the Data URI scheme and html contenteditable attribute. You just paste `data:text/html, ` and then your html, and it's rendered completely local. A good way to use this is to create a bookmark with the html code as the URL, and place it in your bookmarks bar:

![Browser Notepad Bookmark]({{ site.baseurl }}/static/img/notepad_bookmark_orig.png)

Here's what it looks like:

![Browser Notepad]({{ site.baseurl }}/static/img/notepad.png)

Functionality includes:

* Line-width ruler
* "Status bar" with cursor line number
* Favicon for the tab and bookmarks bar
* As soon as you begin typing, the first line becomes the tab's title, allowing you to easily distinguish between multiple open notepad tabs
* Some color/margin formatting that I find eye-pleasing (sorta reminds me of the Soda Light theme)

You can find the code for the notepad in the [this gist](https://gist.github.com/orrsella/5993867). Just copy and paste it into the browser's address bar or a bookmark's URL. You can customize the CSS to your liking if you prefer things done differently.
