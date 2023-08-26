(setq Home '"~/.config/emacs-from-scratch/")

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;;When installing a package which modifies a form used at the top-level
;;(e.g. a package which adds a use-package key word),
;;use `elpaca-wait to block until that package has been installed/configured.
;;For example:
;;(use-package general :demand t)
;;(elpaca-wait)

;; Expands to: (elpaca evil (use-package evil :demand t))
;; (use-package evil :demand t)

;;Turns off elpaca-use-package-mode current declartion
;;Note this will cause the declaration to be interpreted immediately (not deferred).
;;Useful for configuring built-in emacs features.
(use-package emacs
  :elpaca nil
  :config
  (setq ring-bell-function #'ignore))

;; Dont install anything. Defer execution of BODY
;;(elpaca nil (message "deferred"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
  (evil-collection-init))
(use-package evil-tutor)

(use-package general
  :config
  (general-evil-setup)

  ;; set up SPC as the global leader key
  (general-create-definer mg/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode
    

  (mg/leader-keys
   "." '(find-file :wk "Find file")
   "f c" '((lambda () (interactive) (find-file (concat Home "config.org"))) :wk "Edit emacs config")
   "f r" '(counser-recentf :wk "Find recent files")
   "TAB TAB" '(comment-line :wk "Comment lines"))

  (mg/leader-keys
   "b" '(:ignore t :wk "buffer")
   "b b" '(switch-to-buffer :wk "Switch buffer")
   "b i" '(ibuffer :wk "Ibuffer")
   "b k" '(kill-this-buffer :wk "Kill buffer")
   "b n" '(next-buffer :wk "Next buffer")
   "b p" '(previous-buffer :wk "Previous buffer")
   "b r" '(revert-buffer :wk "Reloade buffer"))

  (mg/leader-keys
   "e" '(:ignore t :wk "evaluate")
   "e b" '(switch-to-buffer :wk "Evaluate elisp in buffer")
   "e d" '(kill-this-buffer :wk "Evaluate defun containing or after point")
   "e e" '(next-buffer :wk "Evaluate and elisp expression")
   "e l" '(previous-buffer :wk "Evaluate elist expression before point")
   "e r" '(revert-buffer :wk "Evaluate elisp in region"))

  (mg/leader-keys
   "h" '(:ignore t :wk "help")
   "h f" '(describe-function :wk "Describe function")
   "h v" '(describe-variable :wk "Describe variable")
   "h r r" '(reload-init-file :wk "Reload emacs confit"))

  (mg/leader-keys
   "t" '(:ignore t :wk "toggle")
   "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
   "t t" '(visual-line-mode :wk "Toggle truncated lines")
   "t v" '(vterm-toggle :wk "Toggle vtert"))

  (mg/leader-keys
   "w" '(:ignore t :wk "windows")
   ;; Window splits
   "w d" '(evil-window-delete :wk "Close window")
   "w n" '(evil-window-new :wk "New window")
   "w s" '(evil-window-split :wk "Horizontal split window")
   "w v" '(evil-window-vsplit :wk "Vertical split window")
   "w w" '(evil-window-next :wk "Goto next window"))

  (mg/leader-keys
   "f" '(:ignore t :wk "focus windows")
   ;; Window motions
   "f h" '(evil-window-left :wk "Window left")
   "f j" '(evil-window-down :wk "Window down")
   "f k" '(evil-window-up :wk "Window up")
   "f l" '(evil-window-right :wk "Window right")
   "f <left>" '(evil-window-left :wk "Window left")
   "f <down>" '(evil-window-down :wk "Window down")
   "f <up>" '(evil-window-up :wk "Window up")
   "f <right>" '(evil-window-right :wk "Window right"))

  (mg/leader-keys
   "m" '(:ignore t :wk "move windows")
   ;; Move Windows
   "m H" '(buf-move-left :wk "Buffer move left")
   "m J" '(buf-move-down :wk "Buffer move down")
   "m K" '(buf-move-up :wk "Buffer move up")
   "m L" '(buf-move-right :wk "Buffer move right")
   "m <left>" '(buf-move-left :wk "Buffer move left")
   "m <down>" '(buf-move-down :wk "Buffer move down")
   "m <up>" '(buf-move-up :wk "Buffer move up")
   "m <right>" '(buf-move-right :wk "Buffer move right"))

  )

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(require 'windmove)

;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
;;  "Switches between the current buffer, and the buffer above the
;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
"Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win)
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
"Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
"Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

(set-face-attribute 'default nil
  :font "JetBrains Mono"
  :height 110
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "Ubuntu"
  :height 120
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "JetBrains Mono"
  :height 110
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-11"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(use-package counsel
  :after ivy
  :config (counsel-mode))

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
    ("C-x B" . ivy-switch-buffer-other-window))
  :custom
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "(%d/%d) ")
    (setq enable-recursive-minibuffers t)
  :config
    (ivy-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
    ivy-rich-switch-buffer-align-virtual-buffer t
    ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(electric-indent-mode -1)

(require 'org-tempo)

(defun reload-init-file ()
  (interactive)
  (load-file user-init-file)
  (load-file user-init-file))

;;(use-package eshell-syntax-highlighting
;;  :after esh-mode
;;  :config
;;  (eshell-syntax-highlighting-global-mode +1))

;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
;; eshell-aliases-file -- sets an aliases file for the eshell.

;;(setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
;;      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
;;      eshell-history-size 5000
;;      eshell-buffer-maximum-lines 5000
;;      eshell-hist-ignoredups t
;;      eshell-scroll-to-bottom-on-input t
;;      eshell-destroy-buffer-when-process-dies t
;;      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))

(use-package vterm
:config
(setq shell-file-name "/bin/fish"
      vterm-max-scrollback 5000))

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  ;;(display-buffer-reuse-window display-buffer-in-direction)
                  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                  ;;(direction . bottom)
                  ;;(dedicated . t) ;dedicated is supported in emacs27
                  (reusable-frames . visible)
                  (window-height . 0.3))))

(use-package sudo-edit
  :config
    (mg/leader-keys
      "f s" '(sudo-edit-find-file :wk "Sudo find file")
      "f S" '(sudo-edit :wk "Sudo edit file")))

(use-package which-key
  :init
    (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit t
	  which-key-separator " → " ))
