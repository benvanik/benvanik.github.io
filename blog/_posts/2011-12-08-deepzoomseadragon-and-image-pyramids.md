---
title: DeepZoom/Seadragon and Image Pyramids
tags:
- zui
- zooming
layout: post
---
I'm lazy and Daniel Gasienica has written up a few great posts about the tech
behind DeepZoom (aka Seadragon). So instead of building pretty diagrams and
pulling out some equation rendering software, I'm just going to tell you to
check them out. They are really well written (and much better than anything we
ever released while at Microsoft):

* [Inside Deep Zoom - Part I: Multiscale Imaging](http://www.gasi.ch/blog/inside-deep-zoom-1/)
* [Inside Deep Zoom - Part II: Mathematical Analysis](http://www.gasi.ch/blog/inside-deep-zoom-2/)

These two articles cover the basics of image pyramids, how they are
constructed, and most of the math behind them.

[OpenZoom](http://www.openzoom.org), Daniel's open source Flash zooming image
framework is pretty awesome. In fact, if it wasn't Flash I'd probably just
hack around on that. Check it out.

What I'll be covering here are the things not seen in OpenZoom or other
popular frameworks/apps (GigaPan, Google Maps, etc) and that pretty are much
only used by DeepZoom (which means Silverlight, which really means **no one
is, or will ever, use it**).

