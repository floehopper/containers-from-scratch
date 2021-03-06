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

  # Constants from /usr/include/x86_64-linux-gnu/sys/mount.h
  MS_RDONLY = 1
  MS_NOSUID = 2
  MS_NODEV = 4
  MS_NOEXEC = 8
  MS_SYNCHRONOUS = 16
  MS_REMOUNT = 32
  MS_MANDLOCK = 64
  MS_DIRSYNC = 128
  MS_NOATIME = 1024
  MS_NODIRATIME = 2048
  MS_BIND = 4096
  MS_MOVE = 8192
  MS_REC = 16384
  MS_SILENT = 32768
  MS_POSIXACL = 1 << 16
  MS_UNBINDABLE = 1 << 17
  MS_PRIVATE = 1 << 18
  MS_SLAVE = 1 << 19
  MS_SHARED = 1 << 20
  MS_RELATIME = 1 << 21
  MS_KERNMOUNT = 1 << 22
  MS_I_VERSION =  1 << 23
  MS_STRICTATIME = 1 << 24
  MS_LAZYTIME = 1 << 25
  MS_ACTIVE = 1 << 30
  MS_NOUSER = 1 << 31

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/clone.2.html
  extern 'int clone(int (*fn)(void *), void *child_stack, int flags, void *arg)'

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/unshare.2.html
  extern 'int unshare(int flags)'

  # Note that size_t is usually defined in stddef.h via stdlib.h
  # and is a recognized Fiddle type:
  #   require 'fiddle/cparser'
  #   include Fiddle::CParser
  #   parse_ctype('size_t') # => -5
  #   Fiddle::TYPE_SIZE_T # => -5

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/sethostname.2.html
  extern 'int sethostname(const char *name, size_t len)'

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/mount.2.html
  extern 'int mount(const char *source, const char *target, const char *filesystemtype, unsigned long mountflags, const void *data)'

  # Ref: http://manpages.ubuntu.com/manpages/xenial/man2/umount.2.html
  extern 'int umount(const char *target)'
end
