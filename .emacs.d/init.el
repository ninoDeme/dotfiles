
;; Disable "bloat" to make emacs look more minimal
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; Change font
(set-face-attribute 'default nil :font "NotoMono Nerd font" :height 110)


;; Set theme
(load-theme 'wombat)

;; Make ESC quit prompts
    (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

    (add-hook 'prog-mode-hook 'menu-bar--display-line-numbers-mode-relative)

    ;; Packages ======================================================================

    ;; Set up package.el to work with MELPA
    (require 'package)
    (setq package-archives '(("melpa" . "https://melpa.org/packages/")
			    ("org" . "https://orgmode.org/elpa/")
			    ("elpa" . "https://elpa.gnu.org/packages/")))

    (package-initialize)
    (unless package-archive-contents
    (package-refresh-contents))

    ;; Download and install use-package
    (unless (package-installed-p 'use-package)
    (package-install 'use-package))
    (eval-when-compile
    (require 'use-package))
    (setq use-package-always-ensure t)

    ;; install packages

    (use-package undo-fu)

    (use-package evil ;; Vim mode
    :init
    (setq evil-undo-system 'undo-fu)
    :config
    (evil-mode 1))

    (use-package evil-commentary
    :config
    (evil-commentary-mode))

    (define-key evil-insert-state-map (kbd "M-h") 'evil-normal-state)
    (define-key evil-insert-state-map (kbd "M-j") (lambda () (interactive) (evil-normal-state) (evil-next-line)))
    (define-key evil-insert-state-map (kbd "M-k") (lambda () (interactive) (evil-normal-state) (evil-previous-line)))
    (define-key evil-insert-state-map (kbd "M-l") (lambda () (interactive) (evil-normal-state) (evil-forward-char 2)))

    ;; ivy completions
    (use-package swiper)
    (use-package counsel
	:config
	(counsel-mode 1))
    (use-package ivy 
	:diminish
	:init (define-prefix-command 'C-s-map)
	    (global-set-key (kbd "C-s") 'C-s-map)
	:bind (("C-s s" . swiper)
	    ("C-s C-s" . swiper)
	    ("C-s b" . counsel-switch-buffer)
	    ("C-s C-b" . counsel-switch-buffer)
	    :map ivy-minibuffer-map
	    ("C-l" . ivy-alt-done)
	    ("C-j" . ivy-next-line)
	    ("<tab>" . ivy-next-line)
	    ("<up>" . ivy-previous-history-element)
	    ("<down>" . ivy-next-history-element)
	    ("C-k" . ivy-previous-line)
	    :map ivy-switch-buffer-map
	    ("C-k" . ivy-previous-line)
	    ("C-l" . ivy-done)
	    ("C-d" . ivy-switch-buffer-kill)
	    :map ivy-reverse-i-search-map
	    ("C-k" . ivy-previous-line)
	    ("C-d" . ivy-reverse-i-search-kill))
	:config
	(ivy-mode 1)
	(setq ivy-use-virtual-buffers t)
	(setq ivy-count-format "(%d/%d) "))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(counsel doom-modeline evil-commentary swiper ivy use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
