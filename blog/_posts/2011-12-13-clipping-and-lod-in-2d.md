---
title: Clipping and LOD in 2D
tags:
- zui
- zooming
layout: post
---
The first step in drawing an image pyramid on the screen is figuring out if
it's on the screen at all and, if it is on-screen, what is the level of detail
that should be used. In a 2D screen-aligned rendering system this is fairly
easy, but if arbitrary transforms (rotates/etc) are allowed it gets a bit more
complex - so much so that I'll save explanation of that for the 3D path as
it's essentially the same math. For this post we will concentrate on simple 2D
drawing - that means that the viewport and each image pyramid within it has
some offset and scale, but no rotation/etc.

Note that for the basics I recommend again checking out Daniel's blog post:
[[http://www.gasi.ch/blog/inside-deep-zoom-2/](http://www.gasi.ch/blog/inside-
deep-zoom-2/)](http://www.gasi.ch/blog/inside-deep-zoom-2/)

First, a note about the numbering of levels of detail. Most graphics systems
start with level of detail (LOD) 0 as the native resolution of the content,
with each successful LOD dropping the resolution by a power of two. e.g.:

* LOD 0: 512x512
* LOD 1: 256x256
* LOD 2: 128x128
* etc...
* LOD 8: 2x2
* LOD 9: 1x1

This is generally pretty nice as in most math relating to levels of detail
(some of which you will see below) this is how things work. The problem with
this numbering, though, is that it assumes you know the size of the content
ahead of time and that it doesn't change. For example, if you start caching
data referring to LOD 2 (128x128) and later on decide you want your native
content to be 1024x1024, LOD 2 now refers to the 256x256, not the 128x128.
It's not impossible to work around this, but it can be very difficult to keep
things straight and code clean when this occurs. Because of this, I usually
reverse the numbering, with LOD 0 referring always to the smallest level of
detail 1x1, with some arbitrary LOD N being the (current) native content size.
When coded against this, it's almost impossible to introduce issues around
dynamically resizing content. To review, here's the numbering I will be using:

* LOD 0: 1x1
* LOD 1: 2x2
* etc...
* LOD 7: 128x128
* LOD 8: 256x256
* LOD 9: 512x512

Computing the normal LOD index is as easy as subtracting the current max LOD
from the LOD in question. A cheap operation compared to resizing arrays and
shuffling lots of cached data at runtime.

On to drawing - the basic algorithm for a renderer looks like this:

```
for each pyramid p:
  compute scene bounds
  compute screen bounds
  intersect screen bounds with viewport
  if intersection is empty, skip to the next pyramid
  compute level of detail
  ...draw/etc...
```

Computing the scene bounds of a pyramid in 2D is easy: the x, y placement of
the item and the width, height of the source content. For a simple 2D
rendering system I'd encourage the restriction of making the aspect ratio of
the pyramid in the scene match that of the source content, as the math becomes
much easier to follow.

```
var sceneBounds = new Rect(
    p.x, p.y, p.content.width, p.content.height);
```

Transforming a pyramid from scene bounds to screen bounds is straightforward
in 2D as it consists only of scaling the scene bounds by the viewport scale
and translating by the viewport offset:

```
var screenBounds = new Rect(
    viewport.x + (sceneBounds.x * viewport.scale),
    viewport.y + (sceneBounds.y * viewport.scale),
    sceneBounds.width * viewport.scale,
    sceneBounds.height * viewport.scale);
```

A fast rect-rect intersection test can tell you whether or not it's in view:

```
if (!Rect.intersects(viewportBounds, screenBounds)) {
  // Pyramid is off the screen - skip!
  continue;
}
```

And for those still on the screen figure out how big the pyramid is in screen-
space and compute the desired level of detail:

```
var contentArea = p.content.width * p.content.height;
var screenArea = screenBounds.width * screenBounds.height;
var totalLevels = ceil(ln(max(p.content.width, p.content.height)) / ln(2));
var lod =  totalLevels - ln(contentArea / screenArea) / ln(4);
```

After all this we know whether or not the pyramid is visible, and if it is the
current level of detail it should be drawn at. Note that the computed LOD is a
floating point number - I'll describe this a bit more in the next post.

The 3D path consists of the same exact steps, however the math is slightly
more complex.

