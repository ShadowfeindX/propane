# frozen_string_literal: true
# Usage: 
# load_library :file_chooser
# class ...
# def setup
  # java_signature 'void selectInput(String, String)'
  # selectInput('Select a file to process:', 'fileSelected')
# end
# 
# def fileSelected(selection)
  # if selection.nil?
    # puts 'Window was closed or the user hit cancel.'
  # else
    # puts format('User selected %s', selection.get_absolute_path)
  # end
# end
# ...
class Propane::App
  include Java::MonkstoneFilechooser::Chooser
end
