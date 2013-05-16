---
title: Tile Sizes
tags:
- zui
- zooming
layout: post
---
One big error that has propagated around the net is that of the optimal size
for tiles in an image pyramid and what their overlap should be (if any). I'm
here to set the record straight:

* Always keep your tile dimensions a power of two (128, 256, 512, ...) with overlap inclusive - **never make your tiles 258x258**
* Pick your tile size (256x256, 512x512, etc) based on your target platforms and, if possible, offer multiple variants of the same content
* Always have overlap (borders) on your tiles - at least 1px on each side, more if required (see below) - otherwise you will get seams

Lets start with sizes: **always** make your tiles powers of two. That means
that each dimension should be a power of two, but not that they need be the
same (for example, 512x512, 512x256, or 128x8, etc). This is mainly due to two
factors: floating point imprecision that can cause seams and other display
wonkiness, and the GPU. The big issue that one should be concerned with is
delivering the content in a way the GPU can easily consume: on mobile/embedded
platforms, WebGL, and even some desktop implementations non-power of two
textures can either flat out not work or severely impact performance. If you
need to pad your tiles out by a few dozen pixels to meet the sizing
requirements, do it - JPEG/PNG can remove almost all of that overhead and the
performance benefits on the platforms that are most sensitive to it will make
life easier down the road.

The first version of DeepZoom had a bug in it where it needed 258x258 tiles.
This led to all the documentation referencing this magic value and all tools
spitting tiles out at that size. Turns out, 258x258 is the worst case size for
a tile on many platforms due to the power of two GPU restrictions mentioned
above. In order to draw a tile on a mobile platform that requires power of two
textures (such as early iPhones), one has to decode the tile into a 258x258
buffer, allocate a new 512x512 buffer (as it's the next highest power of two),
and copy things over. So instead of using ~200KB of texture memory/tile each
tile now uses ~786KB of texture memory, almost all of which is wasted space!
Moral of the story: make your tiles power of two, ignore everything that leads
you to believe otherwise. Aside: the bug was fixed in later versions, but
information on the internet never goes away.

Finally, different platforms have different constraints: some are network
bound while some are memory bound, some have large screens while others have
small ones (and others still have small ones with high resolutions, like the
Retina display).

On a desktop, 512x512 is generally a good tile size - on a 30" display you'll
have to fetch 15 tiles to fill the screen as opposed to 62 256x256 tiles.
Sure, each tile is slightly larger in file size, but the overhead of all of
the additional network requests, image decodes, and blending far outweighs the
extra KB. On **desktop**.

On mobile platforms, where the screen is usually smaller the same rule can be
flipped around to argue for smaller tiles: if you have 512x512 tiles the extra
KB to transfer over crappy EDGE/3G can dramatically increase the perceived
latency for the user, the extra memory can eat away at already low limits, and
decoding takes 4x+ longer to again increase perceived latency. Using 256x256
tiles strikes a decent balance between network performance, memory usage, and
the ever-important misprediction cost.

Think of it like this: if I'm on a mobile device and have to wait 5s for a
512x512 tile to come in that fills the whole screen and while waiting see no
change, or 6s for 4 256x256 tiles that fade in one at a time but start
appearing after only 2s, the better experience will be the latter - I have
actionable change occurring almost immediately and I can (maybe) form a
decision about what to do next. On a screen 4x+ the size (and with likely a
4x+ faster network connection), 512x512 would likely be a good choice vs.
1024x1024 for the same reasons. In a few years maybe 2048x2048 will be the
optimal size.

