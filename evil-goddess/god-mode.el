;;; god-mode.el --- God-Mode-like command entering minor mode

;; Copyright for portions evil-goddess are held by Chris Done et al. as part of
;; god-mode. All other copyright for evil-goddess are held by Pascal Huber.

;; Copyright (C) 2019 Pascal Huber

;; Author: Pascal Huber <pascal.huber@resolved.ch>
;; URL: https://github.com/SirPscl/emacs.d/tree/master/evil-goddess
;; Version: 0.1.0

;; The following are the copyright holders of god-mode.

;; Copyright (C) 2013 Chris Done
;; Copyright (C) 2013 Magnar Sveen
;; Copyright (C) 2013 Rüdiger Sonderfeld
;; Copyright (C) 2013 Dillon Kearns
;; Copyright (C) 2013 Fabián Ezequiel Gallina

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; See README.md.

;;; Code:

(require 'cl-lib)
(require 'evil)

(defcustom god-literal-key
  "SPC"
  "The key used for literal interpretation."
  :group 'god
  :type 'string)

(defcustom god-handle-meta
  nil
  "Handle M-? with god-meta-key.
If set to t, the key defined in god-meta-key cannot be used in
key sequences."
  :group 'god
  :type 'boolean)

(defcustom god-meta-key
  "g"
  "The key used for meta interpretation (M-)."
  :group 'god
  :type 'string)

(defcustom god-handle-control-meta
  t
  "Handle C-M-? with god-control-meta-key.
If set to t, the key defined in god-control-meta-key cannot be
used in key sequences."
  :group 'god
  :type 'boolean)

(defcustom god-control-meta-key
  "G"
  "The key used for control-meta interpretation (C-M-)."
  :group 'god
  :type 'string)

(defcustom god-switch-literal
  nil
  "If t then then god-literal-key will act as a switch."
  :group 'god
  :type 'boolean)

;; TODO: get rid of state variable god-control-active
(defvar god-control-active t)

(defvar god-local-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map [remap self-insert-command] 'god-mode-self-insert)
    (let ((i 33))
      (while (< i 256)
        (define-key map (vector i) 'god-mode-self-insert)
        (setq i (1+ i))))
    map))

(defun god-read-event (prompt)
  "Read event using PROMPT including \\[keyboard-quit].
In the case of \\[keyboard-quit] god-local-mode is disabled."
  (let ((inhibit-quit t))
    (setq event (read-event prompt))
    (if inhibit-quit (setq quit-flag nil))
    (if (= event 7)
        (god-local-mode -1))
    event))

(evil-make-intercept-map god-local-mode-map)

;;;###autoload
(define-minor-mode god-local-mode
  "Minor mode for running commands."
  nil " God" god-local-mode-map
  (if god-local-mode
      (progn
        (setq god-control-active t)
        (evil-normalize-keymaps)
        (run-hooks 'god-mode-enabled-hook)
        (message "Evil Goddess"))
    (run-hooks 'god-mode-disabled-hook)))

(defun god-mode-self-insert ()
  "Handle self-insert keys."
  (interactive)
  (let* ((initial-key (aref (this-command-keys-vector)
                            (- (length (this-command-keys-vector)) 1)))
         (binding (god-mode-lookup-key-sequence initial-key)))
    ;; TODO: check if removing this is ok
    ;; (when (god-mode-upper-p initial-key)
    ;;   (setq this-command-keys-shift-trated t))
    (setq this-original-command binding)
    (setq this-command binding)
    (setq real-this-command binding)
    (if (commandp binding t)
        (progn
          ;; TODO: what the heck is this?
          (unless (eq binding 'digt-argument)
            (call-interactively 'god-local-mode))
          (call-interactively binding))
      ;; TODO: fix weird behavior on exit
      ;; check how this works
      (execute-kbd-macro binding))))

(defun god-get-modifier-string (key)
  "Return the modifier string for event KEY."
  (cond
   ((string= key god-literal-key) "%s")
   ((string= key god-meta-key) "M-%s")
   ((string= key god-control-meta-key) "C-M-%s")))

(defun god-mode-lookup-key-sequence (&optional key key-string-so-far)
  "Lookup the command for the given `key' (or the next keypress,
if `key' is nil). This function sometimes recurses.
`key-string-so-far' should be nil for the first call in the
sequence."
  (interactive)

  (let* ((event (or key (god-read-event key-string-so-far)))
         (sanitized-key (or (god-mode-sanitized-key-string event) nil))
         next-binding)

    (cond

     ;; Quit on C-g
     ((not god-local-mode)
      (message "Quit (by Evil Goddess)"))

     ;; No relevant event
     ((not sanitized-key)
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; TODO: handle which-key without using internal functions
     ;; (which-key-C-h-dispatch)
     ;; (which-key-show-next-page-cycle) not work
     ;; (which-key-show-previous-page-cycle)
     ;; (which-key-toggle-docstrings) not work

     ;; C-p -> show prev which-key page
     ((and (bound-and-true-p which-key-mode)
           (string= sanitized-key (kbd "C-p")))
      (which-key--show-page -1)
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; C-n -> show next which-key page
     ((and (bound-and-true-p which-key-mode)
           (string= sanitized-key (kbd "C-n")))
      (which-key--show-page 1)
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; C-d -> show next which-key page
     ((and (bound-and-true-p which-key-mode)
           (string= sanitized-key (kbd "C-d")))
      (setq which-key-show-docstrings (null which-key-show-docstrings))
      (which-key--create-buffer-and-show (which-key--current-prefix))
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; C-? -> don't do anything
     ((<= event 26)
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; literal-key -> toggle got-control-active and do nothing else
     ((string= god-literal-key sanitized-key)
      (setq god-control-active (not god-control-active))
      (setq next-binding key-string-so-far)
      (setq key-string-so-far nil))

     ;; meta-key -> read another key
     ((and god-handle-meta
           (string= god-meta-key sanitized-key))
      (let ((second-event (god-read-event key-string-so-far)))
        (setq next-binding
              (format (god-get-modifier-string sanitized-key)
                      (god-mode-sanitized-key-string second-event)))))

     ;; control-meta-key -> read another key
     ((and god-handle-control-meta
           (string= god-control-meta-key sanitized-key))
      (let ((second-event (god-read-event key-string-so-far)))
        (setq next-binding
              (format (god-get-modifier-string sanitized-key)
                      (god-mode-sanitized-key-string second-event)))))

     (t
      (progn
        (setq next-binding
              (format (if god-control-active "C-%s" "%s") sanitized-key))
        (unless god-switch-literal
          (setq god-control-active nil)))))

    (if god-local-mode
        (if key-string-so-far
            (progn
              (god-mode-lookup-command
               (format "%s %s" key-string-so-far next-binding)))
          (god-mode-lookup-command next-binding))
      "") ;; if god-local-mode is not active anymore, do nothing
    ))

(defun god-mode-sanitized-key-string (key)
  "Convert KEY to textual representation."
  (cl-case key
    (tab "TAB")
    (?\  "SPC")
    (left "<left>")
    (right "<right>")
    (S-left "S-<left>")
    (S-right "S-<right>")
    (prior "<prior>")
    (next "<next>")
    (backspace "DEL")
    (return "RET")
    (t (char-to-string key))))

(defun god-mode-lookup-command (key-string)
  "Execute extended keymaps such as C-c, or if it is a command,
call it."
  (let* ((key-vector (read-kbd-macro key-string t))
         (binding (key-binding key-vector)))
    (cond ((commandp binding)
           (setq last-command-event (aref key-vector (- (length key-vector) 1)))
           binding)
          ((keymapp binding)
           (god-mode-lookup-key-sequence nil key-string))
          (:else
           (error "Evil Goddess: Unknown key binding for `%s`" key-string)))))

(provide 'god-mode)

;;; god-mode.el ends here
