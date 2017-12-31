## Containers from scratch

In [this video from DockerCon 2017][1], [Liz Rice][2] demonstrates how to implement a container-like thing in [a few lines of Go code][3]. I've attempted the same thing, but using Ruby instead of Go.

Note that I worked on this project as a way of learning about containers and hence my approach may be foolish and the code may contain mistakes. Re-use at your own risk!

### Requirements

* Ruby
* Vagrant
* Virtual Box (or another suitable provider)

### Setting up the VM

    vbhost$ vagrant up # may take some time

### Running the container on the VM

    vbhost$ vagrant ssh
    ubuntu@ubuntu-xenial:~$ sudo su - root
    root@ubuntu-xenial:~# cd /vagrant
    root@ubuntu-xenial:/vagrant# ./container run /bin/bash
    run: Running ["/bin/bash"] as PID 15742
    child: Running ["/bin/bash"] as PID 15744
    grandchild: Running ["/bin/bash"] as PID 1
    root@container:/# ps
      PID TTY          TIME CMD
        1 ?        00:00:00 ruby
        4 ?        00:00:00 bash
       11 ?        00:00:00 ps
    root@container:/# exit
    exit
    root@ubuntu-xenial:/vagrant#

See Liz's talk and my commit notes for examples of things to explore in the container.

### Limitations

This has only been tested on Ubuntu 16.04.3 and given that it relies heavily on making native system calls, it's likely not to work on other versions of Linux.

### Credits

Many thanks to [Liz Rice][2] for the inspiration of her talk and for making her source code publicly available.

[1]: https://www.youtube.com/watch?v=MHv6cWjvQjM&t=1316s
[2]: http://lizrice.com/
[3]: https://github.com/lizrice/containers-from-scratch
