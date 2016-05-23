---
layout: post
title:  Preparing for a Facebook/Google Software Engineer Interview
---

**TL;DR:** [This is the theoretical stuff](https://github.com/orrsella/soft-eng-interview-prep) I think you should *know* for an interview with Facebook/Google. Read on for some background and tips.

In late 2015 I interviewed at both Facebook and Google for a software engineering position. I received offers from both, and eventually decided to [take Facebook's one](/about). In the months leading up to the interviews I prepared *a lot*. In this post I'd like to share how I think one should prepare for such an interview and give some tips.

**Disclaimer 1:** Obviously, [opinions are my own](/disclaimer).

**Disclaimer 2:** None of the things I'm sharing here are things I've learned after starting my job or from the interviews themselves (like every other candidate I've signed NDAs).

### Your Job

Or, what an interview is and isn't.

Before we get to business, here's my take on how you should view an interview with Facebook/Google.[^1] A lot has been written about how a typical interview with these companies is structured (phone screen, on-site, types of sessions, lengths, whiteboard/paper/computer coding, etc.). If you haven't already, go read up on Glassdoor/other sites to get familiar with the format. It's very important that you know what to expect. The more you know beforehand, the easier it will be and more comfortable you'll feel.

Regardless of the technicalities – which again, *are* important – here's how I think you should look at this interview. Let's assume that you've already made up your mind that you'd like to work at these companies.[^2] From your point of view, the purpose of the interview is to help you *get an offer*. That's it. It is not to showcase your impressive résumé, or make you feel good about yourself, or to show how smart you are. You want to get that offer.

Your *task* in an interview with these companies is obviously to successfully solve the questions you'll be presented with, but more importantly do it while showing your interviewer how you *think* and approach problem solving. Your *goal* is to send the right signal that your interviewer is looking to pick up. He or she will most likely be interviewing anywhere between 2 to 5 candidates a week. Remember that and think how you can help them see that you're a good fit for the company. See [more tips below](#dos-and-donts) on how to achieve this.

### How To Prepare

I like to separate preparation to three parts:

- Theory
- Coding Problems
- System Architecture Questions

#### Theory

This includes everything you're expected to know as a software engineer.[^3] Things like: complexity analysis, data structures, algorithms, bit manipulation, operating systems, multi-threading, system architecture, numbers,[^4] how hardware works, and networking – to name a few. These are a mix of things that you'll learn in school, from work experience, and by reading books/blogs/research/etc.

This is the basis for any discussions you'll have during your interviews, for the code you'll write, and for the system architecture solutions you'll draw on the whiteboard. It's essential that you have your theory nailed-down, and there's no reason not to.

In my preparation, I summarized everything I thought I should've *known by heart* when coming for the interviews. Once summarized, I read it a few times during the weeks leading up to the interviews and one last time 2-3 days before each of the sessions.

You can find all my notes here:

- [https://github.com/orrsella/soft-eng-interview-prep](https://github.com/orrsella/soft-eng-interview-prep)

or in GitBook format [here](https://orrsella.gitbooks.io/soft-eng-interview-prep/content/). It shouldn't be a very long read – a few hours should suffice.

To compile these I read thru [Cormen](http://www.amazon.com/gp/product/0262033844?tag=orrsellacom-20) and [Skiena](http://www.amazon.com/gp/product/1848000693?tag=orrsellacom-20), as well as countless other blog posts and Wikipedia articles (some are linked from the notes). It contains both explanations and code examples for what I think is important.

#### Coding Problems

Most of what you'll do during an interview is write code to solve various problems (other things will be technical discussions, system architecture questions, and [your own questions](#ask-questions)). They will usually require at most a few dozens of lines (it's hard to fit a lot more than that on a whiteboard in ~40 minutes). The best way to prepare for these is to simply practice and solve as many as you can.

The best resources I used to practice coding questions are:

- [Cracking the Coding Interview, 6th Edition](http://www.amazon.com/gp/product/0984782850?tag=orrsellacom-20)
- [Elements of Programming Interviews](http://www.amazon.com/gp/product/1479274836?tag=orrsellacom-20)

My recommendation would be to get at least one of these books and solve it cover-to-cover. There are lots of other online tools like [LeetCode](https://leetcode.com/) and [various](https://knaidu.gitbooks.io/problem-solving/content/index.html) [question](http://www.ardendertat.com/2012/01/09/programming-interview-questions/) banks. Quora also has some gems, if you search for something more specific.

After you feel comfortable with solving these types of questions, run thru some actual questions that were recently asked during interviews at the company you're interviewing for, by searching Glassdoor.

In general – unsurprisingly – the more code you'll write and problems you'll encounter, the less likely it is that you'll be surprised when you get to the interview. At some point questions start to repeat themselves, and you'll recognize the patterns rather quickly.

#### System Architecture Questions

These are a completely different beast than coding questions. They are much more nuanced, and involve a lot more talking/explaining and almost no actual code. Preparing for these is harder and less straight-forward, especially if you haven't worked on distributed systems before. I plan on writing a separate post with advise on how to prepare for these questions (I'll update this post once I do).

For now, you can read these parts of my notes:

- [System Architecture](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/system-architecture.md) (specifically the [Concepts section](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/system-architecture.md#system-design-question-concepts))
- [System Architecture Examples](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/system-architecture-examples.md)

I also found these resources helpful:

- [System Design Interview](https://github.com/checkcheckzz/system-design-interview)
- [A Distributed Systems Reading List](http://dancres.github.io/Pages/)

and most importantly:

- [HighScalability.com](http://highscalability.com/)

### Do's and Dont's

Some tips, in no particular order:

- Write actual code that works, not pseudocode
- Opt for a mainstream programming language (Java, C/C++, Python, JavaScript)[^5]
- Practice coding on a whiteboard[^6]
- Practice coding on paper (preferably blank, without lines)
- Write clean code:
  - Use good names (classes/functions/variables)
  - Show good modularity (classes/functions)
  - Leave time for error checking and edge cases, even better to start with them (or add `TODO`s for yourself)
  - If you're cutting corners state that out loud, and say what you would do if you had more time (e.g., in Java: *I'm using public fields for brevity here, but would otherwise use getters/setters*)
- Use proper algorithms and data structures and make sure to state Big-O for all of them
- When first approaching a problem:
  - Make sure you understand the task. Repeat it to show that to yourself and the interviewer
  - Don't begin by writing code immediately!
  - Ask questions about the task, inputs, assumptions, formats; most questions are *under specified* on purpose
  - Assume nothing! Or state you're doing so
  - Think out loud, share what you're thinking (brainstorm)
  - Try to show how you think thru the issue
  - Silence isn't good, long ones are *bad*
  - Make sure the interviewer has a clear idea of how you're doing (so they can help!)
  - Start with a simple example, later add detailed ones
  - Clarify the function signature of the problem early on. This will help focus your thoughts, and possibly invite subtle guidance from your interviewer
  - Start with a *simple* inefficient solution (simple != easy)
  - Improve the inefficient one
  - Break down the problem to parts
- Questions are in-depth, usually don't have an *easy* solution (can be simple tho)
- Think about input validation, constraints
- Think about test cases, run thru them to make sure code is correct (but don't assume it's correct, really check as if someone else wrote it)
- If the interviewer gave examples/hints *use them*
- When done ask if you can refine the code, improving variable names, extracting other methods, etc.
- Leave out trivial parts as functions that you need to implement, and only go back to those if you have time
- Upon completion of first solution, either try to improve it, or try to come up with a different solution that is better (e.g.: recursion vs. imperative code)
- Assumptions might now change, and so the solution needs to be adapted
- Glossing over standard APIs if you're not sure is OK, make sure you state that and give a reasonable API to work with


### Ask Questions

At the end of each interview session, your interviewer will usually leave a couple of minutes for your questions. Use this time to ask meaningful questions. This both helps you know the company you're interviewing for, but also sends a good signal about you. You should come prepared with a few questions, that can range from technical to organizational. Not having any questions isn't a good sign, so make sure you're covered.


#### Good Luck!

---

[^1]: This, and a lot of other things from this post, also apply to other tech companies – YMMV.
[^2]: I recognize that the hiring process by these companies is controversial, and that many people don't think that it really evaluates your expertise as a software engineer. I'm deliberately ignoring this, and assuming that this is what you want. If you want to get an offer from these companies then this is the "game" you'll have to play.
[^3]: I'm thinking about this from the point of view of an engineer with 3-10-ish years of experience. I assume that if you're a new grad, expectations are a bit different.
[^4]: You'd be surprised how [handy these](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/numbers.md) could be.
[^5]: You can most likely program in any language you want, but you're better off if your interviewer knows your language of choice and can help if you get stuck. These choices increase the odds of that.
[^6]: Seriously, buy a whiteboard for home to practice on. It will make you feel much more comfortable with it, and you'll learn how to better manage the space on it.
