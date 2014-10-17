---
layout: post
title:  "Git: Using Different User Emails For Different Repositories"
---

A couple of weeks ago [I switched jobs](http://linkedin.com/in/orrsella). We use [Git](http://git-scm.com/) for version control at my [new workplace](http://www.wix.com) (I was using SVN at work up until now). I also have a few [public repositories](https://github.com/orrsella) of my own on GitHub (and some private ones as well). We're using a pretty advanced [Continuous Integration](http://en.wikipedia.org/wiki/Continuous_integration) and [Deployment](http://en.wikipedia.org/wiki/Continuous_delivery) system developed in-house called [Lifecycle](http://wix.io/2013/07/24/lifecycle-wix-integrated-cicd-dashboard/), and on my first week – while still getting to know the entire system and code-base – I committed a change that broke the build. (Actually the change that broke the build wasn't written by me, but by someone else who sent me a Git patch to continue his work, but let's not play the blame game.)

It isn't uncommon for commits to break the build, and when that happens the faulted developer gets notified of the problem by email and usually quickly fixes it. The problem was that I wasn't notified of the error. A few hours later a colleague told me there was a problem with the commit and that he fixed it. While researching why I didn't get the email notification, I discovered that the commit was signed with my personal email address instead of my work one, the build system didn't expect that email address and thus didn't notify me.

This is a very long introduction to the problem I discovered I had – the need to work with different email addresses for different Git repositories.

When first settings up Git on my machine I ran (like everyone does):

{% highlight bash %}
$ git config --global user.name "Orr Sella"
$ git config --global user.email myemail@address.com
{% endhighlight %}

This resulted in the following in my global `.gitconfig` file:

{% highlight text %}
[user]
    name = Orr Sella
    email = myemail@address.com
{% endhighlight %}

Obviously the global user configuration wasn't going to help me with my situation – I need to use different emails for the different environments. If I changed the email to my work one, I'll commit to GitHub with that email address (and I don't want that). Also, removing the email field completely from the global `.gitconfig` file and committing would result in the following:

{% highlight bash %}
$ git commit -m "Test commit"
[master (root-commit) 3ce67f7] Test commit
 Committer: Orr Sella <orr@Orrs-MacBook-Pro.local>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 0 files changed
 create mode 100644 README.md
{% endhighlight %}

That is, my email would be saved as `orr@Orrs-MacBook-Pro.local` and I'd have the above warning on every commit. Fortunately, Git allows you to add configuration for individual repositories. This would solve the problem – I'll manually add the correct email to each repository locally:

{% highlight bash %}
$ git config user.email myworkemail@address.com
{% endhighlight %}
or:
{% highlight bash %}
$ git config user.email myemail@address.com
{% endhighlight %}

But – and this is the main point of this post – this would require me to do it for every inited (new) or cloned repository. Every time. And cloning repositories is something I do on a daily basis, *many* times a day. Not only do we have dozens of repositories, I sometimes clone repos I already have locally just to try something and then discard it. I was worried that I would forget to set my email explicitly every time, and again won't be notified of errors related to failing builds.

The solutions I found to this problem: using [Git hooks](http://git-scm.com/book/en/Customizing-Git-Git-Hooks). First I created a private hooks folder (which is also saved to my personal [dot files repo](https://github.com/orrsella/dotfiles)): `~/.git/templates/hooks`. Next, I made Git use that as the `templatedir` by adding the following to `.gitconfig`:

{% highlight text %}
[init]
    templatedir = ~/.git/templates
{% endhighlight %}

Lastly, I created a `pre-commit` hook by saving the following to `~/.git/templates/hooks/pre-commit`:

{% highlight bash %}
#!/bin/sh
#
# A git hook to make sure user.email exists before committing

EMAIL=$(git config user.email)

if [ -z "$EMAIL" ]; then
    # user.email is empty
    echo "ERROR: [pre-commit hook] Aborting commit because user.email is missing. Configure user.email for this repository by running: '$ git config user.email name@example.com'. Make sure not to configure globally and use the correct email."
    exit 1
else
    # user.email is not empty
    exit 0
fi
{% endhighlight %}

And so now, whenever a new repository is created by running `$ git init` or `$ git clone`, the `pre-commit` file is added to it's *local* `.git/hooks` folder. Then, when committed to, the repo runs the hook and fails the commit if an email isn't configured for that repo. This also works for other Git clients and not just for command line commits (see below screenshot for [Gitbox](http://gitboxapp.com)). But remember – the hook will only be added to *future* inited/cloned repos, not existing ones. You'll need to manually add it to any existing repos if you want it to run when committing.

![Gitbox Commit Error]({{ site.baseurl }}/static/img/gitbox_error.png)

So this solves my problem. I don't have `user.email` configured globally, but on a per-repository basis. And in-case I forget to set it up for a new repo, I'm not able to commit to it and a friendly message reminds me to configure it and how to do it.

Do you have a better way to work around this problem? I'd love to [hear from you](http://twitter.com/orrsella).

**UPDATE**: It seems that [Dan Aloni](http://twitter.com/DanAloni) does indeed have an easier way that produces almost the exact same result:

<div style="width: 500px; margin: auto;">
<blockquote class="twitter-tweet" lang="en"><p><a href="https://twitter.com/orrsella">@orrsella</a> &#39;[user] email = &quot;(none)&quot;&#39; in the global gitconfig, achieves the same goal as the hook</p>&mdash; Dan Aloni (@DanAloni) <a href="https://twitter.com/DanAloni/statuses/454706398195380224">April 11, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

To recap his solution, add to `.gitconfig`:

{% highlight text %}
[user]
	name = Orr Sella
	email = "(none)"
{% endhighlight %}

And once you try to commit, you'll get the following error message:

{% highlight text %}
*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got '(none)')
{% endhighlight %}

Thanks Dan!
