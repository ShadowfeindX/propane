---
layout: page
title: About
permalink: /about/
---

## What is Propane? ##

It is ruby wrapper around processing-2.2.1, that includes the core.jar (also includes appropriate jogl jars for linux64 and mac), and so is independent from any vanilla processing installation.  Someone might like to try including Windows or raspberry-pi binaries?

## System requirements ##

Depends on jdk8+ (Oracle stopped supporting jdk7+ ages ago, unless you pay for it). Expects an installed jruby runtime (_cf_ ruby-processing where it is optional), jruby-9.1.2.0 or a later release preferred to run.

## Usage ##

Sketches should `require 'propane'` and currently should be class wrapped, with sketch class inheriting from `Propane::App`. Creating a new instance, is the regular way to get you sketch to run:-
{% highlight ruby %}
require 'propane'

class MySketch < Propane::App
   def setup
     size 200, 200 # make first entry in setup like regular processing
     # make sense to initialize stuff here
   end

   def draw
     # do fancy stuff here in draw loop
   end
end

MySketch.new title: 'My Sketch'
{% endhighlight %}

{% highlight bash %}
# regular 
jruby my_sketch.rb # using an installed jruby
# using propane, alternative (using jruby-complete)
propane --run my_sketch.rb # installed jruby loads sketch, but it runs with vendored jruby-complete 
{% endhighlight %}
## Why Propane ##

- It is a gas (C<sub>3</sub>H<sub>8</sub>), used for cooking _al fresco_ what could be cooler
- Starts with `pro` _p5_ is shunned (_well apart from p5.js which is considered cool_), over used
- Ends with `pane` an allusion to `window`
- Watch mode is entirely experimental and currently does not work!!! A more conservative version, based on JRubyArt or ruby-processing should work but that would not be very interesting...