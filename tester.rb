require_relative 'lib/taskwarrior'

tw = Taskwarrior.open('~/.task')

res = tw.add("we did it")
puts "result was " + res.inspect
