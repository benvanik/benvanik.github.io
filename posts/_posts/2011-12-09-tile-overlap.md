---
title: Tile Overlap
tags:
- zui
- zooming
layout: post
---
**Always** use tile overlap, and (almost) always set it to 1px. That means each tile should have a 1px border around it that is the content from the adjacent tile. Why?

Any rendering system drawing your tiles will be using bilinear filtering.
Bilinear filtering samples 2x2 texels to produce a single texel based on the
average of the 4. This works great, unless you are at the edge of a tile (say,
0,0) and sampling gets clamped because there is no imagery at pixel -1,-1,
-1,0, or 0,-1. By adding a overlap border of 1px and insetting all texels by 1
(so what was 0,0 becomes 1,1), a sample at (your new) 0,0 will be able to get
valid texels for the averaging. A diagram would help, but trust me - you
should always include pixels from adjacent tiles. If you are seeing seams in
your final composition it's likely due to having no tile overlap or badly
generated tile overlap. Note that you'll only see the seams if you are
rendering things at non-native resolutions (scaling them up) - in a ZUI,
that's almost always.

For bilinear filtering all you ever need is 1px, and that should be what you
use. When would you ever want more than 1px of overlap? Well, it's rare, but
there are tricks that call for it. One of the most useful is using various
compression schemes beyond JPEG/PNG, such as DXT/PVRTC, to provide the GPU
with more compact and efficiently-accessed representations of the tiles. Often
times the algorithms require 4x4 texel blocks instead of the 2x2 that bilinear
filtering does, meaning that there must be at least 4 pixels of overlap in
order to prevent seams. With real-time dynamic texture compression becoming
feasible on the desktop and the memory savings being worth it to compress
ahead-of-time for mobile, it's something to keep in mind.

So, don't slack off when writing tools: always support tile overlap. And don't
be lazy when using tools: it's an easy way to make your final content look
like it should.

Note that one thing I would change about the DeepZoom pyramids is how edge
tiles handle overlap: the tiles omit the pixel column/row. This means that if
my tile size is 254x254 and my overlap is 1px all interior tiles on a level
will be 256x256 (a power of two - perfect for the GPU!) but tiles on the edge
(like tile 0,0) will have fewer pixels and end up as 255x255 (or some
variant). This means that on certain platforms these tiles must go through a
similar resizing before they can be uploaded to the GPU, and math that
computes texel regions must take in to account the varying overlap values. I
consider this an oversight in the original spec, and if I were to write a new
format would not repeat it.

