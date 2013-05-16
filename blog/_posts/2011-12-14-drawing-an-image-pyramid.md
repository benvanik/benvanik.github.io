---
title: Drawing an Image Pyramid
tags:
- zui
- zooming
layout: post
---
Once you have the desired level of detail for rendering you need to figure out
exactly what levels you are going to draw and what regions of them are
visible.

There is a lot of expensive looking math in this area and it may be tempting
to cache a lot of the results (store off the logs of the tile dimensions,
etc), but empirical evidence shows it's significantly slower to do so and
require the additional memory accesses than to just recompute the values when
required. Test before you optimize!

If you're doing spatial blending as described in a previous post (as you
should be!) you'll end up with three important values:

```
// The coarser level of detail in the spatial blending mix
var desiredLevel = floor(lod);
// The finer level of detail in the spatial blending mix, and the last
// level in the pyramid that will be drawn
var nextLevel = ceil(lod);
// [0-1] weight of blending between desiredLevel and nextLevel
// (0 means all desiredLevel, 1 means all nextLevel)
var blendFactor = lod - desiredLevel;
```

All of these values must be clamped to the min and max levels of the pyramid.

Once you have the levels that you're interested in there are many different
ways of walking the pyramid to find the visible tiles:

It may be tempting to start out at the finest level of detail (nextLevel) and
work your way up recursively until you have full coverage - this is definitely
the fastest in the common case, however it prevents some of the important
visual polish techniques as there is often a lot of missing data required.
There are also special degenerate cases where it becomes significantly more
expensive than doing the coarse-to-fine walk, such as moving across a 'deep
seam', like the exact center of a 63 level pyramid. In a simple classical
pyramid rendering system this technique will suffice, but it won't be
resulting in anything people call 'magic'.

A fun way to walk pyramids is breadth-first: for each LOD from coarsest to
finest processes all the tiles in a level. This can be the most efficient in
terms of instructions executed and overhead spent on math, but on almost every
platform I've developed on it's the slowest due to bad temporal locality in
the memory access patterns. It's also is significantly more complex than a
simple depth-first recursive walk. Avoid the temptation.

The way I usually walk pyramids is to start at the minimum level of detail -
0, or the highest LOD that contains a single tile - and do a depth-first
recursive walk towards the finest level. In order to reduce a bit of the math
overhead I precompute the per-level visibility information (the region of
tiles that are visible) and the scaling information used to translate tile
coordinates to screen coordinates. This is more important to do up-front in 3D
than 2D, as in 3D it often entails a polygon clip/bounds computation.

```
// Compute the visible region of the image ([0,0] to [1,1])
var clipL = clamp((viewport.x - sceneBounds.x) / sceneBounds.width, 0, 1);
var clipT = clamp((viewport.y - sceneBounds.y) / sceneBounds.height, 0, 1);
var extents = new Rect(
    clipL, clipT,
    clamp((viewport.right - sceneBounds.x) / sceneBounds.width - clipL, 0, 1),
    clamp((viewport.bottom - sceneBounds.y) / sceneBounds.height - clipT, 0, 1));
// For each LOD, compute all the region of interest
for level lod in [0 to nextLevel]:
  // Level dimensions, in pixels
  var pixelWidth = max(1, ceil(content.width / pow(2, lod)));
  var pixelHeight = max(1, ceil(content.height / pow(2, lod)));
  // Level dimensions, in tiles
  var tileWidth = ceil(pixelWidth / tileSize);
  var tileHeight = ceil(pixelHeight / tileSize);
  // Compute the visible region of tiles in the level
  var tileL = clamp(floor(extents.x / tileSize / pixelWidth),
      0, tileWidth - 1);
  var tileT = clamp(floor(extents.y / tileSize / pixelHeight),
      0, tileHeight - 1);
  var tileR = clamp(floor(extents.right / tileSize / pixelWidth),
      0, tileWidth - 1);
  var tileB = clamp(floor(extents.bottom / tileSize / pixelHeight),
      0, tileHeight - 1);
  // Note: if doing blending flaps, you should extend this region
  // by one on each side
```

Once all of these values have been computed it's possible to cache them off
(possibly only computing them every few frames, or only when the view changes
substantially).

Next up is the recursive walk itself: a traditional depth-first recursion
through the visible region of the pyramid. My walks tend to differ from the
normal a bit in that instead of drawing tiles as I come to them, I build up
vertical 'stacks' of tiles as I go. When I need to draw a tile, I have an
entire slice up the pyramid of the tiles that need to be drawn with proper
blending weights and other information, making fancy tricks easier. It's also
helpful in reducing the overhead required to recompute those values when
there's partial coverage, such as a semi-transparent tile/etc, as expensive
structures such as blending flap matrices are only ever computed once per tile
in the pyramid (not, potentially, hundreds of times).

The depth-first walk itself:

```
function recurse(level, tileX, tileY):
  var tile = tileCache.get(level, tileX, tileY);
  if (!tile) {
    // No tile - cannot continue recursing, draw what we have
    emitTileStack();
    return;
  }
  // Push the tile onto the draw stack (with spatial blending)
  var blendWeight = (level == nextLevel) ? blendFactor : 1;
  pushTileStack(tile, blendWeight);
  // Keep recursing, if required
  if (level < maxLevel) {
    if (isSingleTile(level)) {
      recurse(level + 1, tileX * 2, tileY * 2);
    } else {
      // Note: clamp these so that you don't run off the sides
      recurse(level + 1, tileX * 2, tileY * 2);
      recurse(level + 1, tileX * 2 + 1, tileY * 2);
      recurse(level + 1, tileX * 2, tileY * 2 + 1);
      recurse(level + 1, tileX * 2 + 1, tileY * 2 + 1);
    }
  } else {
    emitTileStack();
  }
  popTileStack();
```

The more interesting part is the emitTileStack() function, which actually
draws the tiles. This can be complex (in the case of collections, blending
flaps, etc), or it can be trivial. Let's start with the trivial
implementation:

```
function emitTileStack():
  // Compute the region of the stack in logical image space ([0,1])
  var stackBounds = new Rect(
      tileX * tileSize / pixelWidth, tileY * tileSize / pixelHeight,
      (tileX < tileWidth - 1 ? tileSize : pixelWidth - (tileX * tileSize)) / pixelWidth,
      (tileY < tileHeight - 1 ? tileSize : pixelHeight - (tileY * tileSize)) / pixelHeight);
  // For each visible level in the stack
  for level lod in [bottomLevel, topLevel]:
    // Compute the pixel region in the level that this tile covers
    var levelBounds = new Rect(
        stackBounds.x * pixelWidth, stackBounds.y * pixelHeight,
        stackBounds.width * pixelWidth,
        stackBounds.height * pixelHeight);
    // Texture coordinates
    // Factor in tile overlap and level border pixels
    var texCoords = new TexCoords();
    texCoords.x1 = levelBounds.x - (tileX * tileSize);
    if (tileX) texCoords.x1 += tileOverlap;
    else texCoords.x1 += border;
    texCoords.y1 = levelBounds.y - (tileY * tileSize);
    if (tileY) texCoords.y1 += tileOverlap;
    else texCoords.y1 += border;
    texCoords.x2 = texCoords.x1 + levelBounds.width;
    texCoords.y2 = texCoords.y1 + levelBounds.height;
    // Finally, draw a quad with the given tile texture
    drawQuad(tile, texCoords, blendWeight);
```

That's it! There's a lot more that can go into this function, and depending on
the underlying rendering system a lot of conditionals that may need to be
present (maximum number of levels to blend, etc), but this is the base of it.

This should be enough to build a very simple renderer. The bit lacking is what
tileCache.getTile does, and how tiles are requested. That's next.

