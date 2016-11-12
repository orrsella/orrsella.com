---
layout: post
title:  Summary of Brendan Gregg's Linux Performance Analysis Tools
---

Brendan Gregg [wrote a great post on his first 60,000 milliseconds](http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html) when trying to diagnose a server with a performance issue. If you haven't yet, you should go [read his post](http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html).

There are many great tips there, and I really wish I could remember all of them. Unfortunately I don't get to use most of these day-to-day, but only every once in a while. And when I do – they come in *very* handy.

To help me remember these, and not have to open up his blog post every time, I added a handy alias to my dot files, [which I take with me everywhere](/2016/10/29/managing-local-and-remote-dot-files/). This alias prints a summary of all the tools, with brief descriptions for each tool based on Brendan's advise.

Here's what it looks like when running it:

{% highlight text %}
$ perf-tools
Linux Performance Analysis in 60,000 Milliseconds
Source: http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html
Even more tools: http://techblog.netflix.com/2015/08/netflix-at-velocity-2015-linux.html

 1) uptime              Load averages, indicate the number of tasks (processes) wanting to run (CPU and I/O).
 2) dmesg | tail        Last 10 system messages (if there are any).
 3) vmstat 1            Virtual memory stat, 1 second summaries. CPU stats are on average, across all CPUs:
                          - r          Number of processes running on CPU and waiting for a turn (CPU only, no I/O). Value > cores = saturation
                          - free       Free memory in kilobytes; see (7) for more info on free mem
                          - si/so      Swap-ins and swap-outs; if these are non-zero, you\'re out of memory
                          - us         User time
                          - sy         System time (kernel), necessary for I/O processing
                          - id         Idle
                          - wa         Wait I/O (like idle for I/O reason), constant value points to a disk bottleneck
                          - st         Stolen time
 4) mpstat -P ALL 1     CPU time breakdowns per CPU, allows to check for an imbalance (a single hot CPU can be evidence of a single-threaded application).
 5) pidstat 1           Per-process summary, useful for watching patterns over time. CPU column is the total across all CPUs (cores).
 6) iostat -xz 1        Workload and performance of block devices:
                          - r/s        Reads per second
                          - w/s        Writes per second
                          - rkB/s      Read Kbytes per second
                          - wkB/s      Write Kbytes per second
                          - await      The average time for the I/O in milliseconds (time the application suffers, as it includes both time queued and time being serviced)
                          - avgqu-sz   The average number of requests issued to the device; values greater than 1 can be evidence of saturation
                          - %util      Device utilization during internal (1 second in this case)
 7) free -m             Memory stats in Mbytes. Cached memory can be reclaimed quickly if apps need it, so it should be considered free (-/+ buffers/cache line). Also buffers and cached shouldn't be near-zero in size.
 8) sar -n DEV 1        Network interface throughput:
                          - rxkB/s     Received Kbytes per second (x8 for Kbits)
                          - txkB/s     Transmitted Kbytes per second (x8 for Kbits)
                          - %ifutil    Device utilization (max of both directions for full duplex)
 9) sar -n TCP,ETCP 1   Summarized view of some key TCP metrics:
                          - active/s   Number of locally-initiated TCP connections per second
                          - passive/s  Number of remotely-initiated TCP connections per second
                          - retrans/s  Number of TCP retransmits per second (sign of a network or server issue)
10) top/htop            Non-rolling system overview (which makes it hard to see patterns over time). Pro-tip: Ctrl-S to pause, Ctrl-Q to continue.
{% endhighlight %}

Want to add this to your dot files? Just copy the `perf-tools` [function from here](https://github.com/orrsella/dotfiles/blob/master/bash/ssh/functions).

Thanks Brendan for your great tips, as always!
