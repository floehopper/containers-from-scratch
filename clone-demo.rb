require 'fiddle'
require 'fiddle/import'

module LibC
  extend Fiddle::Importer
  dlload '/lib/x86_64-linux-gnu/libc.so.6'

  # Cloning flag constants from /usr/include/linux/sched.h
  CSIGNAL = 0x000000ff
  CLONE_VM = 0x00000100
  CLONE_FS = 0x00000200
  CLONE_FILES = 0x00000400
  CLONE_SIGHAND = 0x00000800
  CLONE_PTRACE = 0x00002000
  CLONE_VFORK = 0x00004000
  CLONE_PARENT = 0x00008000
  CLONE_THREAD = 0x00010000
  CLONE_NEWNS = 0x00020000
  CLONE_SYSVSEM = 0x00040000
  CLONE_SETTLS = 0x00080000
  CLONE_PARENT_SETTID = 0x00100000
  CLONE_CHILD_CLEARTID = 0x00200000
  CLONE_DETACHED = 0x00400000
  CLONE_UNTRACED = 0x00800000
  CLONE_CHILD_SETTID = 0x01000000
  CLONE_NEWCGROUP = 0x02000000
  CLONE_NEWUTS = 0x04000000
  CLONE_NEWIPC = 0x08000000
  CLONE_NEWUSER = 0x10000000
  CLONE_NEWPID = 0x20000000
  CLONE_NEWNET = 0x40000000
  CLONE_IO = 0x80000000

  # Constants from /usr/include/x86_64-linux-gnu/asm/signal.h
  SIGHUP = 1
  SIGINT = 2
  SIGQUIT = 3
  SIGILL = 4
  SIGTRAP = 5
  SIGABRT = 6
  SIGIOT = 6
  SIGBUS = 7
  SIGFPE = 8
  SIGKILL = 9
  SIGUSR1 = 10
  SIGSEGV = 11
  SIGUSR2 = 12
  SIGPIPE = 13
  SIGALRM = 14
  SIGTERM = 15
  SIGSTKFLT = 16
  SIGCHLD = 17
  SIGCONT = 18
  SIGSTOP = 19
  SIGTSTP = 20
  SIGTTIN = 21
  SIGTTOU = 22
  SIGURG = 23
  SIGXCPU = 24
  SIGXFSZ = 25
  SIGVTALRM = 26
  SIGPROF = 27
  SIGWINCH = 28
  SIGIO = 29
  SIGPOLL = SIGIO
  #SIGLOST = 29
  SIGPWR = 30
  SIGSYS = 31
  SIGUNUSED = 31

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/clone.2.html
  extern 'int clone(int (*fn)(void *), void *child_stack, int flags, void *arg)'

  # Note that size_t is usually defined in stddef.h via stdlib.h
  # and is a recognized Fiddle type:
  #   require 'fiddle/cparser'
  #   include Fiddle::CParser
  #   parse_ctype('size_t') # => -5
  #   Fiddle::TYPE_SIZE_T # => -5

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/sethostname.2.html
  extern 'int sethostname(const char *name, size_t len)'
end

require 'socket'

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
