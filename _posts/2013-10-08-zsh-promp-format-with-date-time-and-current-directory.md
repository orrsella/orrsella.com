---
layout: post
title:  Zsh Prompt Format With Date/Time and Current Directory
---

I work with the command line a lot (as do/should most developers, at least if they're not running Windows). Every once in a while I happen to run a command which takes longer to complete than I expected. When that happens I want to know how long it took/when it started. For this, I formatted my [zsh](http://www.zsh.org/) prompt in the following way:

![Zsh Prompt]({{ site.baseurl }}/static/img/zsh_prompt.png)

And in plain text:

{% highlight bash %}
[2013-10-08 19:09:39] ~/Dev/Projects/orrsella.github.io $
{% endhighlight %}

(I'm using [iTerm 2](http://www.iterm2.com/#/section/home) with the "Pastel (Dark Background)" color preset.)

My prompt always contains the current date-time and directory. This helps when you end up with a long-running command you didn't plan for (an example I had the other day was a jmap heap dump, which took a surprisingly long time). I'd love to also have milliseconds in there, but it seems like zsh is using [strftime(3)](http://linux.die.net/man/3/strftime) which doesn't have anything shorter than seconds.

I also like having the current directory to remember where I am – helpful with many open terminal tabs/windows.

To get this prompt format, edit `~/.zshrc` ([here's mine](https://github.com/orrsella/dotfiles/blob/master/zsh/.zshrc)) and add the following to it:

{% highlight bash %}
PS1=$'\e[0;30m[%D/\%\}/Y-%m-%d %H:%M:%S}] \e[0;31m%~ $ \e[0m'
{% endhighlight %}

Every new zsh instance you start from *now on* will have the new format. You can easily change the colors/date-time format if you want.
