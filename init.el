(package-initialize)
(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:font "DejaVuSansMono Nerd Font 10"))))
 '(mode-line-inactive ((t (:inherit (quote mode-line))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "b9a06c75084a7744b8a38cb48bc987de10d68f0317697ccbd894b2d0aca06d2b" "a19265ef7ecc16ac4579abb1635fd4e3e1185dcacbc01b7a43cf7ad107c27ced" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(hl-sexp-background-color "#efebe9")
 '(package-selected-packages
   (quote
    (ivy counsel-bbdb 0blayout counsel material-theme inf-ruby clj-refactor which-key ac-cider cider org-ref default-text-scale evil-escape free-keys unbound realgud evil-nerd-commenter helm-ag diminish comment-tags sublimity rainbow-mode beacon clipmon browse-kill-ring company-web xref-js2 nyan-mode php-mode virtualenvwrapper spaceline-all-the-icons use-package spaceline magit airline-themes powerline-evil dumb-jump pug-mode eruby-mode haml-mode grizzl folding web-mode web-beautify color-theme-sanityinc-tomorrow zenburn-theme bubbleberry-theme distinguished-theme moe-theme monokai-theme ac-emacs-eclim company-emacs-eclim eclim yaml-mode tern-auto-complete smex simpleclip rainbow-delimiters org-caldav org-bullets openwith neotree mu4e-maildirs-extension mu4e-alert meghanada markdown-mode lua-mode leuven-theme js2-mode jedi helm-projectile fsharp-mode fixme-mode fill-column-indicator evil-org evil-mu4e evil-leader evil-god-state evil-ediff emojify elpy elfeed-org elfeed-goodies drag-stuff dictionary dictcc calfw auctex ac-math))))
