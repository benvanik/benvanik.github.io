---
title: "Spatial Blending: Softening the Edges"
tags:
- zui
- zooming
layout: post
---
The other spatial blending technique is to blend between tiles on the same
level of detail. You want to do this to prevent visible edges from appearing
when you only partially have a level loaded.

Compare hard edges to soft edges:

![](http://media.tumblr.com/tumblr_lvv00pYoF41r3kfgq.png)

If your levels of detail are not self-similar and have wildly different
content (such as maps), these edges become very noticeable. But even if the
content is the same a hard edge at the border of a tile to even one level of
detail in either direction is something that looks bad and distracts the user.
The way around this is to add soft edges to your tiles at the places where the
tiles blend down to other levels of detail. By gently fading off the user is
much less likely to notice the change in level of detail and will pay
attention to the content. Combining this fading with temporal blending can
mean that when new tiles arrive the user may not even notice them coming in.

There are many tricks to getting soft edges on tiles - I'll go over the
cheapest GPU solution now and in the future talk about the sexy way. If you
are doing things in software you can essentially perform the same work the GPU
is doing to setup several linear blending segments, but that's an exercise
left for the reader. If you are doing things through a higher-level rendering
API or OM (SVG, Canvas, etc) you can accomplish flaps through opacity masks,
but beware that it can be very expensive.

Now, here's the magic that almost no one does... drumroll please...

![](http://media.tumblr.com/tumblr_lvv09kNMDH1r3kfgq.png)

That's right - just throw a bunch more vertices into a tile quad. You then get
many more points at which you can articulate the opacity and the GPU will do
all of the hard work of interpolating things in a nice way. If a tile has no
adjacent neighbor on the left, for example, you can zero out the opacities of
all of the left-most vertices while leaving all of the center vertices opaque
- you'll get a nice graduated ramp down and once composited the hard edge will
disappear.

One thing to note is that all vertex opacities must still be modulated by the
opacity sourced from both temporal blending and the intra-level spatial
blending - failure to do so will cause weird popping but is somethings not
immediately noticeable or traceable.

Spatial blending with soft edges is often overlooked or skipped as being too
complicated, but it is quite possibly the most unique feature of a well built
image pyramid viewer. When it comes to the visual fidelity of the resulting
scene a lack of hard edges can make the difference between a bad experience
that feels cheap and hacky vs. one that feels polished and well designed. The
math is trivial, the rendering is trivial, and there's no good reason other
than laziness as to why every system doesn't do this (on platforms that can
support it).

