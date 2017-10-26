require_relative 'lib/taskwarrior'

tw = Taskwarrior.open('~/.task')

res = tw.done(156)
puts "result was " + res.inspect
