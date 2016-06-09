#!/usr/bin/env ruby
require "shellwords"
require "git"

optimCommands    = ['jpegoptim', 'pngquant', 'gifsicle']
notFoundCommands = []
optimCommands.each do |command|
  isCommand = `which #{command}`
  if isCommand == "" then
    notFoundCommands.push(command)
  end
end

if notFoundCommands.length > 0  then
  p notFoundCommands.join(", ") + "is not found. please check it and install."
  exit(1)
else
  g = Git.init
  g.status.added.each do |file|
    filePath = Dir::pwd + '/' + file[0]
    if file[0].match(/.*\.jpe?g$/) then
      system("jpegoptim #{Shellwords.escape(filePath)}")
    elsif file[0].match(/.*\.png$/) then
      system("pngquant --speed 1 #{Shellwords.escape(filePath)} -f ")
    elsif file[0].match(/.*\.gif$/) then
      system("gifsicle -O3 #{Shellwords.escape(filePath)}")
    end
  end
end
