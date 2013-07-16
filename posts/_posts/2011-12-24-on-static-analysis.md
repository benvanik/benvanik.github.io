---
title: On Static Analysis
tags:
- coding
layout: post
---
> if you have a large enough codebase, any class of error that is
> syntactically legal probably exists there

--

Great post here by Carmack on [using Static Code Analysis in
development](http://altdevblogaday.com/2011/12/24/static-code-analysis/). I'm
a fan of using it when doing native development and there's really no excuse
not to enable it in new projects - /analyze in Visual Studio and the new
analysis tools in Xcode make it free and easy to access. I feel like my raw
new code quality improved dramatically once I learned to work **with** the
analysis tools and incorporate into my coding style the knowledge they
delivered in bite-sized chunks.

I think that I've embraced that style of development is why, now that I'm 100%
web, I've found myself using Google's Closure for all of my projects: I may
type more lines of code due to the required annotations but I end up with
readable, maintainable, and (most importantly) analyzable code. After working
with it for the past year the quality of any random new line of code in one of
my projects is significantly higher than it was before - way higher than it
would be had I not essentially been pair-programming with the compiler for a
year.

