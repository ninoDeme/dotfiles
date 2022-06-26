;;; init.el --- My emacs config

;; Author: ninodemeterko@hotmail.com
;; URL: https://github.com/ninoDeme/dotfiles

;;; Commentary:

;;; Code:
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time)

;; Disable "bloat" to make emacs look more minimal
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq modus-themes-headings
      '((1 . (rainbow variable-pitch 1.5))
	(2 . (rainbow variable-pitch 1.3))
	(3 . (rainbow variable-pitch 1.1))
        (t . (rainbow variable-pitch ))))
;; (setq modus-themes-org-blocks '(grayscale))
(setq modus-themes-mixed-fonts t)
(setq modus-themes-variable-pitch-ui t)
(setq modus-themes-region '(bg-only no-extend))
(setq modus-themes-subtle-line-numbers t)
(setq modus-themes-mode-line '(borderless ))
(setq modus-themes-syntax '(yellow-comments))
(load-theme 'modus-vivendi t)

;; Change font
(set-face-attribute 'default nil :font "NotoMono Nerd Font" :height 110)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "NotoMono Nerd Font" :height 110)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "NotoSans Nerd Font" :height 110 :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Add line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Kill buffers witout prompt
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

;; Packages  ======================================================================================

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
(setq use-package-always-defer t)
(setq use-package-verbose t)

(use-package no-littering) ;; Avoid clutering .emacs.d
(use-package bug-hunter
  :commands (bug-hunter-file bug-hunter-init-file))

;; Define keymaps  ================================================================================

(use-package general
  :demand t
  :config (general-evil-setup t)
  (general-create-definer leader-key
    :keymaps '(normal visual emacs insert treemacs)
    :prefix "SPC"
  :non-normal-prefix "C-SPC"
    :prefix-map 'leader-key-map
    :prefix-command 'leader-key-cmd
    :global-prefix "C-SPC")
  (leader-key
    "e" 'counsel-find-file
    "E" 'dired-jump
    "RET" 'vterm
    "g" 'magit-status
    "SPC" 'treemacs))

;; Install and configure packages ===============================================================

(use-package undo-fu
  :demand t) ;; better redo functionality for evil mode

(use-package undo-fu-session  ;; save history between sessions
  :after undo-fu
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (global-undo-fu-session-mode 1))

;; Vim mode
(use-package evil
  :demand t
  :init (setq evil-undo-system 'undo-fu)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :bind (:map evil-insert-state-map ;; Alt + Movement keys to exit insert mode
	      ("M-h" . 'evil-normal-state)
	      ("M-j" . (lambda () (interactive) (evil-normal-state) (evil-next-line)))
	      ("M-k" . (lambda () (interactive) (evil-normal-state) (evil-previous-line)))
	      ("M-l" . (lambda () (interactive) (evil-normal-state) (evil-forward-char 2)))
	      ("C-h" . 'evil-delete-backward-char-and-join)
	      ;; ("TAB" . 'indent-rigidly-right)
	      )
  :config (evil-mode 1))

(use-package evil-collection
  :demand t
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary ;; Evil comment support
  :after evil
  :defer 0
  :config (evil-commentary-mode))

(use-package evil-surround ;; Evil surround (ys* to add surrounding cs<old><new> change surrounding)
  :ensure t
  :defer 0
  :config
  (global-evil-surround-mode 1))

(use-package treemacs
  :commands treemacs)
(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t
  :config (evil-define-key 'treemacs treemacs-mode-map (kbd "SPC") 'leader-key-cmd)
	(evil-define-key 'treemacs treemacs-mode-map (kbd "C-SPC") 'leader-key-cmd)
  )

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)
(use-package lsp-treemacs
  :after (lsp treemacs))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :hook (counsel-find-file . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    (kbd "L") 'dired-view-file
    (kbd "M-l") 'dired-display-file
    "l" 'dired-find-file))

;; (use-package hydra) ;; create temporary keymaps

(use-package magit
  :commands (magit-status)
  :defer 1)

(use-package ace-popup-menu
  :config (ace-popup-menu-mode 1))

(use-package dimmer
  :config
  (dimmer-configure-which-key)
  (dimmer-configure-magit)
  (dimmer-configure-company-box)
  (dimmer-mode 1))

;; ivy stuff
(use-package swiper
  :commands (swiper)
)

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode))
(use-package counsel
  :config (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package counsel-projectile
  :after (projectile counsel)
  :config (counsel-projectile-mode 1))

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
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
  (leader-key
    "s" 'swiper
    "b" 'counsel-switch-buffer)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package ivy-rich
  :after (all-the-icons-ivy-rich)
  :config (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package all-the-icons   ;; icon font
  :if (display-graphic-p))

;; Doom mode-line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 30))
  :config (setq doom-modeline-indent-info t)
  (setq doom-modeline-icon t)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project))

(use-package editorconfig
  :ensure t
  :defer 0
  :config
  (editorconfig-mode 1))

;; Themes
;; (use-package doom-themes
;;   :config 
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;; 	doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (load-theme 'doom-tomorrow-night t)
;;   (doom-themes-org-config))

(use-package vterm
  :ensure t
  :commands 'vterm)

(use-package projectile ; Project manager
  :diminish projectile-mode
  :defer 0
  :config 
  (leader-key
    "p" 'projectile-command-map)) ; Leader (SPC) + p to open projectile map

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Better help
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Org mode

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :after org
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))
  )

(defun org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  ;; (dolist (face '((org-level-1 . 1.2)
  ;;                 (org-level-2 . 1.1)
  ;;                 (org-level-3 . 1.05)
  ;;                 (org-level-4 . 1.0)
  ;;                 (org-level-5 . 1.1)
  ;;                 (org-level-6 . 1.1)
  ;;                 (org-level-7 . 1.1)
  ;;                 (org-level-8 . 1.1)))
  ;;   (set-face-attribute (car face) nil :font "NotoSans Nerd Font" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  ;; (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  ;; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  ;; (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  ;; (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)
)
(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t))

(defun org-mode-visual-fill ()
  (visual-line-mode 1)
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . org-mode-visual-fill))

(use-package flycheck
  :hook (prog-mode . flycheck-mode))
(use-package company
  :defer 0
  :bind (:map company-active-map
	      ("C-j" . company-select-next)
	      ("C-k" . company-select-previous)
	      ("C-l" . company-complete-selection))
  :config (global-company-mode 1))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; LSP mode config
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-l")
  (add-hook 'c-mode-hook 'lsp)
  (add-hook 'c++-mode-hook 'lsp)
  :config
  (message "LOADING LSP =======================")
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . lsp))  ; or lsp-deferred

(setq gc-cons-threshold (* 2 1000 1000))

;; Automaticaly created stuff {{{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" "3319c893ff355a88b86ef630a74fad7f1211f006d54ce451aab91d35d018158f" default))
 '(package-selected-packages
   '(undo-fu-session highlight-indent-guides dimmer ace-popup-menu editorconfig flycheck vterm all-the-icons-ivy lsp-pyright lsp-mode org-bullets evil-magit magit evil-surround counsel-projectile counsel-projecttile projectile hydra evil-collection general doom-themes all-the-icons ivy-rich counsel doom-modeline evil-commentary swiper ivy use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; }}}
