---
title: "TDD: The Gamification of Programming"
tags:
- whiskey
layout: post
---
Until a week ago I'd never worked on a sizable piece of code using the
practices of TDD. I'd done plenty of integration tests, benchmarks, and unit
tests for sure, but I'd never followed the TDD flow of test-write-test. To say
the least this week or two of hacking has been enlightening. Some things I've
noticed; good, bad, and still unknown:

* Using TDD has slowed me down **a lot** - I'd say I'm only 25% as effective at reaching my goals (my goals being a working demo, not reliable code)
* TDD has forced me to design my API before I have good end-to-end code
* My API is very well defined from the start, and documented extremely well
* I have 100% code coverage for the first time ever on a project this complex
* Despite the complexity, the project is extremely testable (unlike most of my projects which end up only being able to be black-box tested)
* I'm growing impatient with not having my vertical slice working yet
* I'm feeling much less creative and whimsical with my coding ('oo let's try this! oh, wait, then I'd have to write tests... meh, later')

A few of these points are major wins for me, but with some reflection I
believe the negatives outweigh them. Why, then, do I still want to keep doing
it?

I realized tonight that TDD had, in a broad sense, turned coding into a 'game'
for me; not a Skyrim mind you, but a Farmville. Maximizing the code coverage,
minimizing the failures/time taken/flakiness, watching the statement number
count grow and my docs flesh out - it was the same short-cycle satisfaction
loop that makes the modern Zynga shitware game so successful. Something in us
is wired for this kind of behavior, and TDD feels like the perfect expression
of that in the programming domain.

When the action/reward loop tightens as much as this, you lose track of the
deeper motives that exist to push you along. Momentary swings in desire derail
you much quicker, and inspired moments are self-discouraged due to their
likelihood of lengthening the cycle. It turns programming from quest-driven
fits of algorithmic expression into drooling-monkey-on-keyboard lab
experiments with the test runner as the uncaring, unceasing experimenter.

I'm not sure I'm comfortable with it when I think of it like that. I hack for
the deep sense of satisfaction that creating something from nothing gives me
and any pattern or practice that delays or dampens that satisfaction is
unsettling. My current project really needs TDD but I'll be using it
judiciously on future ones now that I know how it feels.

TDD is where creativity in coding goes to die.

