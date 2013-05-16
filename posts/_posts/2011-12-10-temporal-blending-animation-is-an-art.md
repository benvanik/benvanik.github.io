---
title: "Temporal Blending: Animation is an Art"
tags:
- zui
- zooming
layout: post
---
One of the best things you can do to a ZUI to make it instantly feel sexier is
add temporal blending. This is the opacity blend that new tiles get when they
are loaded to prevent them from visibly popping in on the screen. It is a
design decision, and it is one you should go with unless you want to look like
Google Maps circa 2005.

The time you spend blending new tiles should not be excessive and should be
roughly tied to the speed at which you expect your users to be navigating your
content. If they are zipping through and randomly moving around to very
different areas (and as such experiencing many new tile loads), it's probably
best to keep the blend time low - don't punish the user for being quick. An
example of this would be a search on a map that bounced you from one city to
another. On the other hand, if the user is making smaller and more precisie
movements, blend more slowly; don't jar the user or distract from the content
they are looking at. This would be if they were panning around looking at
different areas: you don't want tiles popping in rapidly in their peripheral
vision.

The best option is a hybrid of these two. Any decent image pyramid renderer
will already be using foveation (the concept of varying the level of detail
across an image) to prioritize the loading of certain interesting parts of an
image first. The low hanging fruit is to use foveation to prioritize tiles at
the center of the screen over tiles at the edges: users tend to zoom around
what they are interested in, and tend to zoom it towards the center. A simple
heuristic that can provide great perceived latency improvements. Now, here's
the magic: vary the blend times of tiles based on the same logic. If it's in
the center of the screen (what the user really wants to see), blend it fast -
not so fast as to pop, but fast enough that it feels like it's not getting in
the way of the user. If it's at the edge of the screen, blend it slower and
don't draw the users attention away from their target.

If you're doing the image pyramid trick correctly and loading lower levels of
detail first (coarser, lower resolution) then you can also speed up blends of
those levels to ensure that the user doesn't feel like they are waiting too
long for imagery that only marginally contributes to the final display.

Dynamically adjusting, however, is difficult and very tricky in all but the
most constrained domains. The biggest issue I've noticed is that scaling the
blend time too much can lead to 'strobing', whereby tiles appear to pop in and
then the scene sits still, and then bam more tiles pop in - repeat until all
tiles are loaded. This is caused by the blend time not corresponding to the
average tile preparation time. If it takes 1s to download, decode, and upload
a tile and only 250ms to blend it, the user will be spending 75% of their time
looking at a static scene. In the face of such long loads it's actually much
more pleasing for a user to see things coming in (say, on a 500-750ms blend
time) than to be sitting and waiting with no changes. If you're on a super
fast broadband connection and your average tile load time is 10ms, a 500-750ms
blend time would be doing a disservice to your user, slowing the entire
experience for nothing but eye candy.

Empirically the blend times I've used range from 250ms to 750ms. 250ms is a
little on the low side, often causing the perception of popping even when it
is a smooth blend, especially if there are dropped frames (250ms at 60fps is
only 15 frames - if you drop 4-5 for some uncontrollable reason, you've lost
most of your animation and suddenly look bad).

Animation is an art. Give it no thought and despite your best efforts your
content will look like crap. Respect it and seemingly ordinary content can
evoke awe. If you want to lose all credibility with me tell me you don't think
tiles should ever blend.

