---
layout: post
title:  Managing Local and Remote Dot Files
---

This post describes how I like to think about and manage the dot files on both my local macOS dev machine, as well as any remote Linux server I use regularly – in one single setup.

**TL;DR:** Check out [my dot files repo](https://github.com/orrsella/dotfiles) for the code. To get started you can just clone/fork and run one of the setup scripts.

### My Dot Files

We all love dot files. A lot [has](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/) [been](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789) [written](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) [about](https://www.foraker.com/blog/get-your-dotfiles-under-control) them, and there are [many](https://github.com/mathiasbynens/dotfiles) [popular](https://github.com/holman/dotfiles) [GitHub repos](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories&utf8=%E2%9C%93) with [cool examples](https://github.com/webpro/awesome-dotfiles). What makes mine different is the fact that I like to take them with me everywhere I go, including when SSH-ing into any server – both for work and personal use – even for the ones I've never used before!

They serve two purposes for me:

1. Not being attached to any particular dev machine – I rely on my dot files and the [various](https://github.com/orrsella/dotfiles/blob/master/setup-brew.sh) [setup](https://github.com/orrsella/dotfiles/blob/master/setup-macos.sh) [scripts](https://github.com/orrsella/dotfiles/blob/master/setup-symlinks.sh) for a very quick ramp-up when moving to a new Mac.
2. Having maximum convenience and productivity anywhere possible.

My dot files include a lot of the typical shell/tools setup:

- Shell[^1]
  - Config
  - [Prompt](https://github.com/orrsella/dotfiles/blob/master/bash/local/prompt)
  - Environment variables
  - [Aliases](https://github.com/orrsella/dotfiles/blob/master/bash/common/aliases)
  - [Handy](https://github.com/orrsella/dotfiles/blob/master/bash/common/functions) [utility](https://github.com/orrsella/dotfiles/blob/master/bash/local/functions) [functions](https://github.com/orrsella/dotfiles/blob/master/bash/ssh/functions)
- Vim
- Tmux/Screen
- Git/Mercurial

I also store the config files for some of my native Mac apps, including:

- Alfred
- Sublime Text
- IntelliJ
- iTerm

### How It Works

My setup includes careful integration of the following:

- Using git to store and version all files.
- [Precisely managing which dot file goes where](https://github.com/orrsella/dotfiles/blob/master/links).
- Supporting both local (macOS) and remote (Linux) dot files, while also reusing the common parts.
- Using the great [sshrc](https://github.com/Russell91/sshrc) script.
- Configuring `tmux`/`screen` to work with `sshrc`.

Setup includes cloning the repo locally[^2] and symlinking all files listed in [`links`](https://github.com/orrsella/dotfiles/blob/master/links).

When SSH-ing somewhere, I use the `sshrc` command, which zips all files found in the `~/.sshrc.d` directory (also managed by `links`), and extracts them to a temporary directory on the destination server. It then sources [`.sshrc`](https://github.com/orrsella/dotfiles/blob/master/bash/ssh/.sshrc) to configure everything.

Lastly, I use [my custom](https://github.com/orrsella/dotfiles/blob/master/bash/ssh/functions) `screenrc` and `tmuxrc` commands on the server to open new sessions. These make sure that new sessions are initialized with everything extracted by `sshrc`.

### Conclusion

This might sound complicated, but it works seamlessly and effortlessly. I no longer have to worry about keeping the various snowflake instances of my dot files on the various servers I use in sync, and I get to share a lot of the code that makes sense with my local Mac setup. I also don't litter any server I connect to with local copies of my personal files since `sshrc` uses tmp files and cleans up after itself.

Interested? Take it for a spin: [https://github.com/orrsella/dotfiles](https://github.com/orrsella/dotfiles)

Have a cool addition? Fork and add! Send a pull request if you think I should include in my setup as well.

---

[^1]: I only use bash. I find comfort in knowing that any environment I work with has bash, without relying a specific configuration – that's out of my control – having other shells like zsh, fish, etc. I feel like my dot files make it so I get a lot of the convenience of using other modern shells while having a consistent experience everywhere. This doesn't mean you have to do the same.
[^2]: I like to use `~/.dotfiles`.
