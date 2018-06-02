#!/usr/bin/env jruby
# frozen_string_literal: true
require 'propane'

# Add close method to Propane modulE
module Propane
  def self.close
    surface = Propane.app.surface
    surface.stop_thread
    surface.visible = false if surface.stopped?
    surface = nil
    Propane.app.dispose
    Propane.app = nil
  end
end

# Add always on top option
class Sketch < Propane::App
  ALWAYS_ON_TOP = true
  
  def on_top
    surface.set_always_on_top ALWAYS_ON_TOP
  end
end


# A sketch loader, observer, and reloader, to tighten
# the feedback between code and effect.
class Watcher
  class WatchException < StandardError
  end
  
  
  # Sic a new Processing::Watcher on the sketch
  WATCH_MESSAGE ||= <<-EOS.freeze
  Warning:
  To protect you from running watch mode in a top level
  directory with lots of nested ruby files we
  limit the number of files to watch to %d.
  You may pass a larger watch size as the
  second command line argument.
  EOS
  SLEEP_TIME = 0.2
  def initialize(sketch, max = nil)
    @sketch_path = sketch
    @sketch_root = File.absolute_path(File.dirname(@sketch_path))
    @max_watch = max || 20
  
    count = Dir["**.*rb"].length
    @max_watch = @max_watch
    return warn format(WATCH_MESSAGE, @max_watch, count) if count > @max_watch.to_i
    reload_files_to_watch
    @time = Time.now
    start_watching
  end

  # Kicks off a thread to watch the sketch, reloading JRubyArt
  # and restarting the sketch whenever it changes.
  def start_watching
    start_original
    Kernel.loop do
      if @files.find { |file| FileTest.exist?(file) && File.stat(file).mtime > @time }
        puts 'reloading sketch...'
        Propane.app && Propane.close
        java.lang.System.gc
        @time = Time.now
        start_runner
        reload_files_to_watch
      end
      sleep SLEEP_TIME
    end
  end

  # Convenience function to report errors when loading and running a sketch,
  # instead of having them eaten by the thread they are loaded in.
  def report_errors
    yield
  rescue Exception => e
    wformat = 'Exception occured while running sketch %s...'
    tformat = "Backtrace:\n\t%s"
    warn format(wformat, File.basename(@sketch_path))
    puts format(tformat, e.backtrace.join("\n\t"))
  end

  def start_original
    @runner = Thread.start do
      report_errors do
        load_and_run_sketch
      end
    end
  end

  def start_runner
    @runner.kill if @runner && @runner.alive?
    @runner.join
    @runner = nil
    start_original
  end

  def reload_files_to_watch
    @files = Dir.glob(File.join(@sketch_root, '**/*.{rb,glsl}'))
  end
  
  def load_and_run_sketch
    Sketch.class_eval File.read(@sketch_path), @sketch_path, 0
    Sketch.new.on_top
  end
end
