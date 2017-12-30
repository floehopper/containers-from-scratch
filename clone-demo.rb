require 'fiddle'
require 'socket'

require 'lib_c'

closure = Class.new(Fiddle::Closure) do
  def call(hostname)
    result = LibC.sethostname(hostname.to_s, hostname.to_s.size)
    abort 'sethostname' unless result == 0
    puts "hostname in child: #{Socket.gethostname}"
    sleep 30
    return 0
  end
end.new(Fiddle::TYPE_INT, [Fiddle::TYPE_VOIDP])

child_function = Fiddle::Function.new(closure, [Fiddle::TYPE_VOIDP], Fiddle::TYPE_INT)

if ARGV.length < 1
  puts "Usage: #{__FILE__} <child-hostname>"
  exit
end

STACK_SIZE = 1024 * 1024
child_stack_p = Fiddle::Pointer.malloc(STACK_SIZE)
child_stack_top_p = child_stack_p + STACK_SIZE

pid = LibC.clone(child_function, child_stack_top_p, LibC::CLONE_NEWUTS | LibC::SIGCHLD, ARGV[0])
abort 'clone' if pid == -1
puts "clone() returned #{pid}"

sleep 5

puts "hostname in parent: #{Socket.gethostname}"

result = Process.waitpid(pid)
abort 'waitpid' if result == -1

puts 'child has terminated'
