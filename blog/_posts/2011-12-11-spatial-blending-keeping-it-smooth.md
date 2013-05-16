--- 
title: "Spatial Blending: Keeping it Smooth"
tags: 
- zui
- zooming
layout: post
---
Along with temporal blending (animating the blending of tiles on the screen)
there is spatial blending. Spatial blending can refer to many things, but I'll
use the term to talk about two techniques in particular: blending between
multiple tiles from different levels of detail, and blending between tiles in
the same level of detail.

The first technique, blending between multiple levels of detail, is also known
as trilinear filtering. An extension of bilinear filtering into the 3rd
dimension, this algorithm takes into account adjacent pixels on the same level
of detail as well as those in an adjacent level of detail. This enables some
very practical improvements, such as a lack of aliasing or texture artifacts
when tiles are shrunk below their native size, but also allows for another
very important visual trick when used in conjunction with temporal blending.

The short of it is that if you only performed temporal blending when new tiles
were ready to be displayed and you were caching those tiles, if you zoomed out
and then back in on an image all tiles would pop. You could temporally blend
them again however the effect, although visually pleasing, would be much too
slow. By instead allowing your current level of detail to be a floating point
value instead of an integer (such that it's possible to be at level of detail
13.5 -- halfway between 13 and 14) you can let the user move at whatever speed
they want and always be viewing the imagery at the exact resolution they
should be, without delay. Note that this assumes that your viewport is
animated smoothly as to prevent popping - so long as the tiles are available
and ready to be displayed, blending with no time delay will create both a
visually pleasing and low-impact effect.

There are some problems this technique raises though, namely that not all
textures are self-similar across their levels of detail. If you're zooming
through a photograph chances are all the levels are the same, but if you are
zooming through a map that may change labels/road density/etc at each level
then if you end up at level 13.5 you'll be seeing a jumbled mess of detail
from level 13 and 14. The trick around this is fairly simple, although not
desirable for all content types as it can cause aliasing and a drop in quality
(I'd avoid it unless you had content that was not self-similar).

The solution is to put your current level of detail on an animation where the
animation target is always rounded to whatever works for the scenario
(flooring is usually OK). This is a hybrid temporal and spatial blend, as
while the animation is running there is a spatial blend between the two LODs,
but when it settles things will stick at a single level. While the user is
navigating the scene the animation is continually reset and has no effect, it
is only when they come to a rest that it runs. This actually leads to an
effect that, in combination with temporal blending, can enable even faster
blend times.

Next up is the other kind of spatial blending, aka 'blending flaps'.

