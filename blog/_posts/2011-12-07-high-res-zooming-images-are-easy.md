---
title: High-res Zooming Images Are Easy
tags:
- zui
- zooming
layout: post
---
In the hunt for something fun to hack together with ZUIs, the obvious first
target is the display of single high-resolution images. Think of these as
either kind-of big photographs (digital camera photos), really big photographs
(panoramas), or really **really** big images (the map of the earth/etc).
Systems that display these generally use multiple levels of detail and, within
each of those levels, multiple tiles (aka image pyramids). There are a lot of
interesting tricks that can be done in this domain that **are** pretty
interesting even if image pyramids are not. It's annoyed me that in the
several years that these have been on display in technologies such as
Seadragon very few other implementations have picked them up.

* Temporal blending: use nice animations to smoothly blend between the levels of detail to prevent popping
* Spatial blending ("blending flaps"): use gradient edges on tiles to prevent visible seams or borders
* Foveation: varying the level of detail across the visible parts of the image (higher level in some areas, lower in others) to prioritize the loading of certain parts of the image over others - like loading the center of the image before the borders
* General non-suckiness: be fast, be efficient, don't overcomplicate things

All of these things are easy - there's nothing new here, nothing novel. It's
not an engineering problem, it's a design problem. It's also the foundation
for much more interesting things. So let's start there...

