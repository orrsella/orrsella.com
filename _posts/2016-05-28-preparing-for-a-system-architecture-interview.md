---
layout: post
title:  Preparing For a System Architecture Interview
---

This is the second part of my previous post on [Preparing for a Facebook/Google Software Engineer Interview](/2016/05/14/preparing-for-a-facebook-google-software-engineer-interview/). If you haven't yet, I suggest you go read it and then come back.

**Disclaimer 1:** Obviously, [opinions are my own](/disclaimer).

**Disclaimer 2:** None of the things I'm sharing here are things I've learned after starting my job or from the interviews themselves (like every other candidate I've signed NDAs).

### System Architecture Interviews

Software engineering interviews with Facebook/Google (and similar companies) usually entail 1-2 sessions of system architecture questions. These questions tend to be more abstract – usually with little to no coding – and are trickier to prepare for. They are much easier if you have actual experience with system architecture[^1] or are well versed in the topic.

In addition to seeing how experienced you are with large-scale – usually distributed – systems, these questions examine, among other things, how you:

- Articulate complex and abstract ideas.
- Think on your feet and tackle unknown obstacles, while asking the right questions.
- Zoom out to examine a system as a whole.
- Make real-world assumptions and balance trade-offs.

Additionally, system architecture questions are sometimes used to gauge how experienced a candidate is (along with their past work experience). Your performance in these interview sessions might impact the seniority level assigned to you as a candidate.

### Wait, Is This a System Architecture Question?

Or, how to know you're being asked a system architecture question.

Architecture questions are often presented in a very vague and under-specified manner. This is routinely intentional, as it enables the interviewer to discern how you "peel-off" an unknown assignment, which clarifying questions you ask, and assumptions you make. This is true for both "regular" coding questions and system architecture ones, but is more crucial in the latter as these tend to be very open-ended, and can be addressed in totally different ways.

One side-effect of presenting questions this way is that you might not realize you're being asked a system architecture question. For example, consider the following:

> How can we repeatedly find a string in a large dataset?

An eager candidate might immediately jump to the conclusion that having a large dataset searched repeatedly means it must be sorted and then binary-searched in `log(n)`, and will start writing the code for mergesort on the whiteboard. All while the interviewer is thinking of a large document corpus and trying to get them to design a search engine.

Unless you ask some clarifying questions, like: "How big is the data set?", "What are its characteristics?", "How do we obtain it?", you might not realize what you're up against.

If you're uncertain, a good trick here is to try and frame the question as a method signature. If it's a system architecture question, it will force the interviewer to steer you away from it and think in more abstract terms.

### Concepts You Should Know

Here's a list of concepts/considerations/tools that you should have in your tool belt when approaching system architecture questions. In no particular order, and without being exhaustive:

- Amount of data (disk)
- Amount of RAM (memory)
  * Does everything need to be in RAM? (often times – yes)
- RAID configurations
- Requests/sec
- Request time
- Latency
- Data transfer rates
- Network limits within a single data center
- Geographically separated locations (multiple data centers)
- Sharding/Partitioning (by user/date/content-type/alphabetically)
  * How do you re-balance?
  * Consistent hashing for sharding/partitioning
- CAP theorem
- MapReduce
- Distributed hash tables
- Difference between frontend/backend
- SOA (service oriented architectures, also "micro-services")
- Backups
  * Backup a single user on how many servers?
- Caching
  * Many requests for the same data/lots of updates – should be in cache
- Distribute so that the network is negligible
- Parallelizing network requests
- Fan-out (scatter and gather)
- Load-balancing
- High availability
- CDNs (content delivery networks)
- POPs (points of presence)
- Queues
- Failures
  * Timeouts
  * Fault tolerance
  * Failing fast
  * Circuit breakers
  * Throttling
- Consensus (e.g. Paxos, Raft) and membership protocols (heartbeats, SWIM)
- Compression
- Possible to work harder on writes in order to make reads easier
- Operations should almost never be more than `n*log(n)`, preferably `n`

See the [System Architecture](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/system-architecture.md) page of my interview prep notes for more examples, explanations, and links for further reading.

### Numbers

Having your "numbers" down is crucial for tackling these questions. What does this mean? It means that you should know by heart how long it takes to make an L1 cache reference, what reading from HDD/SSD means, and how many seconds are in a day, for example. You should also be very comfortable with order-of-magnitude calculations. Without thinking about it too much, you should know how much data is 10^12 bytes, or estimate how much memory is needed to store a trillion web addresses (also RAM vs disk; does it matter?).

Finally, you'll be better off if you can easily convert between powers of two and ten. For example, know that 2^20 is roughly 10^6 (and also 1 MB, or more precisely 1 [MiB](https://en.wikipedia.org/wiki/Mebibyte)).

Doing these calculations correctly and fast sends a very positive signal. In contrast, not being able to make these under pressure can derail your interview into an arithmetic duel, of which rarely can you come out victorious (even if you'll end up being right).

Check out my summary of the [Numbers](https://github.com/orrsella/soft-eng-interview-prep/blob/master/topics/numbers.md) you should memorize.

### Designing Platforms

System architecture questions are usually to solve a specific problem or design a product. Rarely you might be asked to design a more broad platform or a lower-level service. These questions try to gauge what you think good platforms should have, and the types of services/feature you expect to have and use in a distributed environment.

If tasked with this challenge, here are some features of modern platforms you can throw up on the whiteboard and design with:

- Monitoring
  * Applications (response time, throughput, errors)
  * Operating systems
  * Hardware
- Alerting
- Metrics (counters)
- Logging
- Distributed tracing (cross-service)
- Datastores
- Caching
- Queues
- Service discovery
- Configuration
- Debugging, profiling
- ALM (application lifecycle management) and deployment
  * Continuous deployment
  * Blue-green deployment
  * Rollbacks
  * Canary changes
  * Shadow traffic
- Auto scaling
- Load balancing, traffic splitting/control
- KPIs

### Approaching a Question

I like the following approach to solving these questions:

1. Begin by asking qualifying questions to understand the system you want to design. It's a good idea to get up to the whiteboard as early as you can, and start writing some features/assumptions you're making at the edge of the board. Write down the 1-3 key features of the system. What are the most important features this system should have in your opinion?
2. Throw out some numbers to gauge the size of the problem. Give rough estimates to the amount of data/users/requests you'll need to handle, and deduce the number of servers/HDD/datacenters you'll need to implement it. Explain the rationale for your assumptions and write them on the board.
3. If you and your interviewer agree on the problem and its size, start a very high level design of the system. This should probably be some rectangles with arrows between them. For example: We'll have these modules, these types of workers, this queue, that datastore, etc. As you make this high-level design, keep writing things you'll need to consider or come back to at the edge of the board. Use tools from ["Concepts You Should Know"](#concepts-you-should-know) above.
4. Get a sense of what interests your interviewer, which parts they think are key, and dive into them in greater resolution. Do we want to focus on data input? Efficiency? Error handling? Backup? The question can go in so many places, so make sure you're addressing the most important and relevant parts.

### Examples

Finally, you should run through a few examples while preparing for your interview. There are many examples for system architecture questions in sites like Glassdoor. Checkout [github.com/checkcheckzz/system-design-interview](https://github.com/checkcheckzz/system-design-interview#-hot-questions-and-reference) for some nice ones.

---

[^1]: These questions are typically asked in interviews of more experienced candidates. New-grads aren't usually expected to be able to solve them. Instead, some companies ask a lighter variation which mostly revolves around designing APIs for a client application. If you're not sure what's expected of you – ask your recruiter!
