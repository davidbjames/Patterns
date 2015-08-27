
<sub>Right-click Open in External Editor if you have a Markdown app installed</sub>

# Patterns

> In software engineering, a design pattern is a general reusable solution to a commonly occurring problem within a given context in software design. A design pattern is not a finished design that can be transformed directly into source or machine code. It is a description or template for how to solve a problem that can be used in many different situations. Patterns are formalized best practices that the programmer can use to solve common problems when designing an application or system. - [Wikipedia](https://en.wikipedia.org/wiki/Software_design_pattern)

## What is this Xcode group for?

The Patterns Xcode group is intended to be an adhoc collection of "starting points" for implementing design patterns. These may or may not include actual implementation code -- normally they would just be protocols. However, with **Swift 2.0**, protocol extensions allow providing generic implementation or convenience to patterns. Mainly, this is Ok, as long as the logic is kept generic to avoid limiting implementors down the road.

## Why provide "starting points" for patterns?

Because it points us in the right way of thinking about the pattern, and allows that thought to be communicated throughout the code. By naming things after patterns it forces implementors (and maintainers) to consider the changes they make and ask if the pattern is correct or (more importantly) remaining correct. Good names in software keep us honest and document intent. Protocols (the "interface") help enforce this.

## Links 

* **[Pro Design Patterns in Swift - Apress](http://www.apress.com/9781484203958)** <-- Highly recommend this
* [Design patterns in Swift by example - Github](https://github.com/ochococo/Design-Patterns-In-Swift) - Has all the standard patterns. A great starting point if you don't want to buy the book
* [Software Design Patterns - Wiki](https://en.wikipedia.org/wiki/Software_design_pattern) - General introduction to design patterns
