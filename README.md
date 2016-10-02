# Propane
[![Gem Version](https://badge.fury.io/rb/propane.svg)](https://badge.fury.io/rb/propane)

A slim layer to communicate with Processing from JRuby, features a polyglot maven build, this started out as a non serious project by Phillip Cunningam called ribiprocessing.  It has now morphed into an experimental project for ruby-processing so we can now "Cook with Gas". We have created a configuration free version of ruby processing, for processing-3.2.1+, where we get processing core from maven central (and opengl currently testing on linux64/mac). These jars are small enough to include in the gem distribution, and hence we should not require configuration. This has created a scriptable version, ie files get run direct from jruby, but you could use jruby-complete if you used the propane script (avoids need to give the absolute data path for the data folder, but would also be needed for a watch mode).
## Requirements

- jdk8+ since version 0.6.0
- jruby-9.1.4.0+
- mvn-3.3.1+ (development only)

## Building and testing

```bash
rake
rake gem
rake javadoc
```

## Installation
```bash
jgem install propane-{version}-java.gem # local install
jgem install propane # from rubygems.org
```

## Usage

``` ruby
require 'propane'

class FlashingLightsSketch < Propane::App

  def settings
    size(800, 600)
  end

  def setup
    sketch_title 'Flashing Light Sketch'
  end

  def draw
    background(rand(255), rand(255), rand(255))
  end
end

FlashingLightsSketch.new
```

To install the samples.  The samples get copied to `~/propane_samples`. Depends on wget.
```bash
propane --install samples
```
There is a handy sketch creator tool
```bash
propane -c my_sketch 200 200 # for default renderer
propane -c my_sketch 200 200 p2d # for opengl 2D renderer
propane -c my_sketch 200 200 p3d # for opengl 3D renderer
```

To run sketches

```bash
jruby -S propane --run my_sketch.rb # belt and braces version
```
To install the sound and video libraries `~/.propane/libraries`. Depends on wget.
```bash
propane --install sound
propane --install video
```
Other java libraries can be manually installed to the same folder (no need for processing ide)