---
title: Simple Image Pyramid Demo in ~500 lines of Javascript
tags:
- zui
- zooming
layout: post
---
[Simple Image Pyramid Demo in ~500 lines of
Javascript](https://gist.github.com/1475466)

Too much talk, not enough working code. Here's a simple image pyramid viewer I
wrote in 3hrs that shows off a few of the topics mentioned:

* Temporal blending
* Spatial blending
* Viewport clipping/LOD detection
* Foveation (proper prioritization of tiles)

It is a fairly functional pyramid renderer for about 500 lines of code and
contains more fit-and-finish features than most renderers out there. There's
no image loading/etc, as the queue/events requires a bit of work and
complicates the code. The goal of this is to demonstrate the math, not how to
most efficiently build out the request fetching system/etc (that's another
demo). The tile cache behavior (evict when off screen) and the blending
behavior (one level at a time) is classic Seadragon style - there are a lot of
tricks that can be done to the tile stack to accelerate blending while still
maintaining a reasonable number of drawn quads, but I'll save that for a
future post. Canvas is used to do the rendering so soft tile edges are
missing... I'll play around with adding them later.

There are some bits in there that may seem a little weird, but most are in
there for good reason. Namely that there is space for lower levels of detail
that are not used and all the tile stack stuff. The empty levels will become
useful when trying to do collections (texture atlases for the lower levels of
multiple image pyramids), and the tile stack stuff makes screen-space clipping
and blending much easier - I'll dedicate some future posts to these topics.

If you want to see it live, check this out:

[[http://dl.dropbox.com/u/7156684/pyramiddemo/pyramiddemo.html](http://dl.drop
box.com/u/7156684/pyramiddemo/pyramiddemo.html)](http://dl.dropbox.com/u/71566
84/pyramiddemo/pyramiddemo.html)

It should run on Chrome/FF/iOS, and on iOS5 runs quite well. Drag to pan,
mouse wheel/pinch to zoom. The slider in the top left adjusts a scalar bias on
the LOD (left = finer, right = coarser). Note that this is not tuned for
performance or visual quality (there are seams on FF, for example) - it's demo
code, deal with it!

Code: [[https://gist.github.com/1475466](https://gist.github.com/1475466)](htt
ps://gist.github.com/1475466)

{% gist 1475466 %}
