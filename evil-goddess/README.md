# Evil Goddess

*Evil Goddess* makes it possible for evil users to conveniently access Emacs
keybindings without touching the control and meta key - similar to god-mode.

## Motivation

I like Vim and I like Emacs. Thus I like Emacs' evil-mode. And I am not a huge
fan of the extensive use of the control key (although I have mapped it to a more
prominent location on my keyboard). I used evil-god-state for quite some time
and was reasonably happy with it since it gave me the ability to access many of
the keybindings in Emacs with ease.

There are two main reasons I took god-mode and modified it:

 1. evil-god-state adds an evil-state for god-mode (as the name suggests). This
    comes with some problems when switching to evil-god-state from various
    different evil-states. For example, it does not work (well) from
    visual-state. Creating an evil-state for god-mode-like insertion of key
    sequences is not necessary and makes things more complicated (IMHO).

 2. I like the behavior of god-mode but I do see some room for
    improvement/customization. Evil Goddess provides some variables to customize
    the behavior.

I also like emacs-which-key and I don't want to miss it when entering key
sequences. Which-key has hard-coded support for god-mode. This means that some
functions cannot be renamed without loosing which-key support. Thus evil-goddess
and god-mode (or evil-god-state) cannot be used together (which also doesn't
make much sense I guess).

~~God-Mode is an archived project.~~ God-mode has been moved to emacsorphanage.
If it is maintained again, maybe a PR would be an option?

## Usage

The usage differs with different settings. This section describes the usage with
the default settings.

After activating `god-local-mode`, the first key is always translated to `C-?`.
All the following insertions are added to the key sequence without any modifier
keys.

Examples:
  * `abc`     → `C-a b c`

More control-prefixed characters can be inserted by pressing the
`god-literal-key` (default: `SPC`) before entering the desired character.

Examples:
  * `a b` → `C-a C-b`
  * `a b cd` → `C-a C-b C-c d`

Note that the `god-literate-key` is blocked by this and it is not possible to
add key sequences containing this key (e.g. `C-SPC`).

### Meta Prefix (M-?)

By default, it is not possible to add `M-?` to a key sequence. By setting
`god-handle-meta` to `t` (default: `nil`), inserting the `god-meta-key`
(default: `g`) before entering the desired character will add a meta-prefix.

Example:
  * `ga` → `M-a`

Note that the `god-meta-key` will be blocked by this and it will no longer be
possible to add key sequences containing this key (e.g. `C-g` or `C-c g`). In
`god-mode`, this is the default behavior.

### Control-Meta prefix (C-M-?)

In the same fasion as the Meta Prefix, it is by default not possible to add
`C-M-?` to a key sequence. By setting `god-handle-control-meta` to `t` (default:
`nil`), inserting the `god-control-meta-key` (default: `G`) before entering the
desired character will add a control-meta-prefix.

Example:
  * `Ga` → `C-M-a`

Note that the `god-control-meta-key` will be blocked by this and it will no
longer be possible to add key sequences containing this key (e.g. `C-G` or `C-c
G`). In `god-mode`, this is the default behavior.


### Literal Key Switching

By setting `god-switch-literal` to `t` (default: `nil`), the `god-literal-key`
(default: `SPC`) will act as a switch.

Example:
  * `ab cde f` → `C-a b C-c C-d C-e f`

### Which key

Which-key is partially supported. When enabled with god-mode support, you can
use `C-n` and `C-p` for paging.

## Installation

 1. Download god-mode.el (the one here, not the original!)
 2. Add the directory where god-mode.el lies to your load-path.
    ```
    (add-to-list 'load-path "/path/to/file/")
    ```
 3. Enable it with `(require 'god-mode)`
 4. Add a convenient key to enable `god-local-mode` in normal- and visual-state
    (I use `SPC`).
 5. If you want which-key support, make sure to enable it with
    `(which-key-enable-god-mode-support)`
