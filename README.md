# Configuration

[see configuration.org](configuration.org)

# Dependencies

* [mu](https://www.djcbsoftware.nl/code/mu/)
* [offlineimap](http://www.offlineimap.org/)
* [pandoc](http://pandoc.org/)

# Installation:

```
$ cd ~/git 
$ git clone http://github.com/pascalhuber/emacs
$ ln -s ~/git/emacs ~/.emacs.d
```

get mu4e ready
```
$ sudo pacman -S offlineimap 
$ yaourt -s mu
$ mu index --maildir=~/.mail
```

