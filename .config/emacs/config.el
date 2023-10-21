(setq Home '"~/.config/emacs/")

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
  (setq evil-collection-mode-list '(calendar dashboard dired ediff info magit ibuffer))
  (evil-collection-init))
(use-package evil-tutor)
;; Using RETURN to follow links in Org/Evil
;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
  (setq org-return-follows-link  t)

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
   ":" '(counsel-M-x :wk "Counsel M-x")
   "TAB" '(perspective-map :wk "Perspective") ;; Lists all the perspective keybindings
   "; ;" '(comment-line :wk "Comment lines"))

  (mg/leader-keys
   "a" '(:ignore t :wk "Ace Jump")
   "a c" '(ace-jump-char-mode :wk "Jump to a char")
   "a l" '(ace-jump-line-mode :wk "Jump to a line")
   "a p" '(ace-jump-mode-pop-mark :wk "Jump to previous point")
   "a a" '(ace-jump-word-mode :wk "Jump to a word"))

  (mg/leader-keys
   "b" '(:ignore t :wk "Buffer/Bookmark")
   "b b" '(switch-to-buffer :wk "Switch buffer")
   "b d" '(bookmark-delete :wk "Delete bookmark")
   "b i" '(ibuffer :wk "Ibuffer")
   "b k" '(kill-this-buffer :wk "Kill current buffer")
   "b K" '(kill-some-buffer :wk "Kill multible buffers")
   "b l" '(list-bookmarks :wk "List bookmarks")
   "b m" '(bookmark-set :wk "Set bookmark")
   "b n" '(next-buffer :wk "Next buffer")
   "b p" '(previous-buffer :wk "Previous buffer")
   "b r" '(revert-buffer :wk "Reloade buffer")
   "b R" '(rename-buffer :wk "Rename buffer")
   "b s" '(basic-save-buffer :wk "Save buffer")
   "b S" '(save-some-buffers :wk "Save multiple buffers")
   "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file"))

  (mg/leader-keys
   "d" '(:ignore t :wk "Dired")
   "d d" '(dired :wk "Open dired")
   "d j" '(dired-jump :wk "Dired jump to current")
   "d n" '(neotree-dir :wk "Open directory in neotree")
   "d p" '(peep-dired :wk "Peep-dired"))

  (mg/leader-keys
   "e" '(:ignore t :wk "Evaluate/Eshell")
   "e b" '(switch-to-buffer :wk "Evaluate elisp in buffer")
   "e d" '(kill-this-buffer :wk "Evaluate defun containing or after point")
   "e e" '(next-buffer :wk "Evaluate and elisp expression")
   "e h" '(counsel-esh-history :which-key "Eshell history")
   "e l" '(previous-buffer :wk "Evaluate elist expression before point")
   "e r" '(revert-buffer :wk "Evaluate elisp in region")
   "e s" '(eshell :which-key "Eshell"))

  (mg/leader-keys
   "f" '(:ignore t :wk "Focus Windows/Files")
   ;; Window motions
   "f h" '(evil-window-left :wk "Window left")
   "f j" '(evil-window-down :wk "Window down")
   "f k" '(evil-window-up :wk "Window up")
   "f l" '(evil-window-right :wk "Window right")
   "f <left>" '(evil-window-left :wk "Window left")
   "f <down>" '(evil-window-down :wk "Window down")
   "f <up>" '(evil-window-up :wk "Window up")
   "f <right>" '(evil-window-right :wk "Window right")
   ;; Files
   "f b" '((lambda () (interactive) 
	          (find-file (concat Home "vim-cheat-sheet.org"))) 
	        :wk "Open evil keybind cheat sheet")
   "f c" '((lambda () (interactive) 
	          (find-file (concat Home "config.org"))) 
	        :wk "Edit emacs config")
   "f d" '(find-grep-dired :wk "Search for string in files in DIR")
   "f e" '((lambda () (interactive)
              (dired Home)) 
            :wk "Open user-emacs-directory in dired")
   "f f" '(find-file :wk "Find file")
   "f g" '(counsel-grep-or-swiper :wk "Search for string current file")
   "f i" '((lambda () (interactive)
              (find-file (concat Home "init.el"))) 
            :wk "Open emacs init.el")
   "f s" '(counsel-locate :wk "Locate a file")
   "f r" '(counser-recentf :wk "Find recent files")
   "f u" '(sudo-edit-find-file :wk "Sudo find file")
   "f U" '(sudo-edit :wk "Sudo edit file"))

  (mg/leader-keys
   "g" '(:ignore t :wk "Git")
   "g /" '(magit-displatch :wk "Magit dispatch")
   "g ." '(magit-file-displatch :wk "Magit file dispatch")
   "g b" '(magit-branch-checkout :wk "Switch branch")
   "g c" '(:ignore t :wk "Create") 
   "g c b" '(magit-branch-and-checkout :wk "Create branch and checkout")
   "g c c" '(magit-commit-create :wk "Create commit")
   "g c f" '(magit-commit-fixup :wk "Create fixup commit")
   "g C" '(magit-clone :wk "Clone repo")
   "g f" '(:ignore t :wk "Find") 
   "g f c" '(magit-show-commit :wk "Show commit")
   "g f f" '(magit-find-file :wk "Magit find file")
   "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
   "g F" '(magit-fetch :wk "Git fetch")
   "g g" '(magit-status :wk "Magit status")
   "g i" '(magit-init :wk "Initialize git repo")
   "g l" '(magit-log-buffer-file :wk "Magit buffer log")
   "g r" '(vc-revert :wk "Git revert file")
   "g s" '(magit-stage-file :wk "Git stage file")
   "g t" '(git-timemachine :wk "Git time machine")
   "g u" '(magit-stage-file :wk "Git unstage file"))

  (mg/leader-keys
   "h" '(:ignore t :wk "Help")
   "h a" '(counsel-apropos :wk "Apropos")
   "h b" '(describe-bindings :wk "Describe bindings")
   "h c" '(describe-char :wk "Describe character under cursor")
   "h d" '(:ignore t :wk "Emacs documentation")
   "h d a" '(about-emacs :wk "About Emacs")
   "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
   "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
   "h d m" '(info-emacs-manual :wk "The Emacs manual")
   "h d n" '(view-emacs-news :wk "View Emacs news")
   "h d o" '(describe-distribution :wk "How to obtain Emacs")
   "h d p" '(view-emacs-problems :wk "View Emacs problems")
   "h d t" '(view-emacs-todo :wk "View Emacs todo")
   "h d w" '(describe-no-warranty :wk "Describe no warranty")
   "h e" '(view-echo-area-messages :wk "View echo area messages")
   "h f" '(describe-function :wk "Describe function")
   "h F" '(describe-face :wk "Describe face")
   "h g" '(describe-gnu-project :wk "Describe GNU Project")
   "h i" '(info :wk "Info")
   "h I" '(describe-input-method :wk "Describe input method")
   "h k" '(describe-key :wk "Describe key")
   "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
   "h L" '(describe-language-environment :wk "Describe language environment")
   "h m" '(describe-mode :wk "Describe mode")
   "h r" '(:ignore t :wk "Reload")
   "h r r" '((lambda () (interactive)
                (load-file (concat Home "init.el"))
                (ignore (elpaca-process-queues)))
              :wk "Reload emacs config")
   "h t" '(load-theme :wk "Load theme")
   "h v" '(describe-variable :wk "Describe variable")
   "h w" '(where-is :wk "Prints keybinding for command if set")
   "h x" '(describe-command :wk "Display full documentation for command"))

  (mg/leader-keys
   "m" '(:ignore t :wk "Move Windows/Org")
   ;; Move Windows
   "m h" '(buf-move-left :wk "Buffer move left")
   "m j" '(buf-move-down :wk "Buffer move down")
   "m k" '(buf-move-up :wk "Buffer move up")
   "m l" '(buf-move-right :wk "Buffer move right")
   "m <left>" '(buf-move-left :wk "Buffer move left")
   "m <down>" '(buf-move-down :wk "Buffer move down")
   "m <up>" '(buf-move-up :wk "Buffer move up")
   "m <right>" '(buf-move-right :wk "Buffer move right")
   ;; Org
   "m a" '(org-agenda :wk "Org agenda")
   "m B" '(org-babel-tangle :wk "Org babel tangle")
   "m d" '(:ignore t :wk "Date/deadline")
   "m d t" '(org-time-stamp :wk "Org time stamp")
   "m e" '(org-export-dispatch :wk "Org export dispatch")
   "m i" '(org-toggle-item :wk "Org toggle item")
   "m t" '(org-todo :wk "Org todo")
   "m T" '(org-todo-list :wk "Org todo list"))

  (mg/leader-keys
   "o" '(:ignore t :wk "Open")
   "o f" '(make-frame :wk "Open buffer in new frame")
   "o F" '(select-frame-by-name :wk "Select frame by name"))

  ;; projectile-command-map already has a ton of bindings 
  ;; set for us, so no need to specify each individually.
  (mg/leader-keys
   "p" '(projectile-command-map :wk "Projectile"))
  
  ;; projectile-command-map already has a ton of bindings 
  ;; set for us, so no need to specify each individually.
  ;; (mg/leader-keys
  ;;  "l" '(lsp-command-map :wk "LSP"))

  (mg/leader-keys
    "s" '(:ignore t :wk "Search/Snippets")
    "s c" '(yas-load-snippet-buffer-and-close :wk "Save the new created snippet")
    "s d" '(dictionary-search :wk "Search dictionary")
    "s m" '(man :wk "Man pages")
    "s n" '(yas-new-snippet :wk "Create a new snippet")
    "s s" '(ivy-yasnippet :wk "Searches and past's snippet")
    "s t" '(tldr :wk "Lookup TLDR docs for a command"))

  (mg/leader-keys
   "t" '(:ignore t :wk "Toggle")
   "t a" '(org-appear-mode :wk "Toggle rendered text to original form")
   "t e" '(eshell-toggle :wk "Toggle eshell")
   "t f" '(flycheck-mode :wk "Toggle flycheck")
   "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
   "t n" '(neotree-toggle :wk "Toggle neotree file viewer")
   "t r" '(rainbow-mode :wk "Toggle rainbow mode")
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
  )

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package ace-jump-mode)

(setq backup-directory-alist '((".*" . "~/Papierkorb/")))

(use-package beacon
  :config 
  (beacon-mode 1))

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

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package color-identifiers-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (typescript-mode . color-identifiers-mode)
         (web-mode . color-identifiers-mode)
         (json-mode . color-identifiers-mode)
         (vue-mode . color-identifiers-mode)))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "<left>") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal dired-mode-map (kbd "<right>") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "<down>") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "<up>") 'peep-dired-prev-file)
    (setq peep-dired-cleanup-on-disable t)
)

(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(use-package diminish)

(use-package dimmer
  :config
  (dimmer-configure-which-key)
  (dimmer-mode t)
  (setq dimmer-fraction 0.25))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

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

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package git-timemachine
  :after git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision)
)

(use-package magit
  :config
    (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))
(use-package magit-todos)

(use-package hl-todo
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package highlight-indent-guides
  :hook ((prog-mode . highlight-indent-guides-mode))
  :config
  (setq highlight-indent-guides-method 'column
	highlight-indent-guides-responsive 'stack))

(use-package counsel
  :after ivy
  :config
    (counsel-mode)
    (setq ivy-initial-inputs-alist nil)) ;; removes starting ^ regex in M-x

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

(use-package web-mode)
(use-package json-mode)
(use-package typescript-mode)
(use-package lua-mode)
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
(use-package vue-mode
  :mode "\\.vue\\'")
(setq lsp-volar-take-over-mode nil)  ;; uses typescript sever in ts files. Is performanec hungtey because two ls run in one vue project

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (prog-mode . lsp)
         (web-mode . lsp)
         (json-mode . lsp)
         (vue-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-ui :commands lsp-ui-mode)
;; The flycheck does not work in typescript, html and javascript blocks in vue-mode. How to fix that?
(with-eval-after-load 'lsp-mode
  (mapc #'lsp-flycheck-add-mode '(typescript-mode js-mode css-mode vue-html-mode)))
;; performance changes
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.500)  ;; This variable determines how often lsp-mode will refresh the highlights, lenses, links, etc while you type
(setq gc-cons-threshold 100000000)

(global-set-key [escape] 'keyboard-escape-quit)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
	  doom-modeline-icon t         ;; Whether display icons in the mode-line
	  doom-modeline-major-mode-icon t  ;; Whether display the icon for `major-mode'
	  doom-modeline-major-mode-color-icon t
	  doom-modeline-buffer-state-icon t  ;; Whether display the icon for the buffer state
	  doom-modeline-buffer-modification-icon t  ;; Whether display the modification icon for the buffer
	  doom-modeline-time-icon t    ;; Whether display the time icon
	  doom-modeline-buffer-name t  ;; Whether display the buffer name
	  doom-modeline-buffer-encoding t  ;; Whether display the buffer encoding
	  doom-modeline-indent-info t  ;; Whether display the indentation information
	  doom-modeline-display-default-persp-name t  ;; If non nil the default perspective name is displayed in the mode-line
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t   ;; adds folder icon next to persp name
	  doom-modeline-lsp t          ;; Whether display the `lsp' state
	  doom-modeline-modal t        ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc
	  doom-modeline-modal-icon t   ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc
	  doom-modeline-modal-modern-icon t  ;; Whether display the modern icons for modals
	  doom-modeline-gnus t         ;; Whether display the gnus notifications
	  doom-modeline-gnus-timer 2   ;; Whether gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
	  doom-modeline-time t         ;; Whether display the time
	  doom-modeline-env-version t  ;; Whether display the environment version
))

(use-package centered-cursor-mode
  :demand
  :config
  ;; Optional, enables centered-cursor-mode in all buffers.
  (global-centered-cursor-mode)
  (setq ccm-recenter-at-end-of-file t))

(use-package neotree
  :after doom-themes
  :config
  (setq neo-smart-open nil
        neo-show-hidden-files t
        neo-window-width 40
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t)
        ;; truncate long file names in neotree
        (add-hook 'neo-after-create-hook
           #'(lambda (_)
               (with-current-buffer (get-buffer neo-buffer-name)
                 (setq truncate-lines t)
                 (setq word-wrap nil)
                 (make-local-variable 'auto-hscroll-mode)
                 (setq auto-hscroll-mode nil)))))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t))

(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-hide-emphasis-markers t)

(eval-after-load 'org-indent '(diminish 'org-indent-mode))

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
 '(org-level-6 ((t (:inherit outline-5 :height 1.2))))
 '(org-level-7 ((t (:inherit outline-5 :height 1.1)))))

(require 'org-tempo)

(use-package perspective
  :custom
  ;; NOTE! I have also set 'SCP =' to open the perspective menu.
  ;; I'm only setting the additional binding because setting it
  ;; helps suppress an annoying warning message.
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init
  (persp-mode)
  :config
  ;; Sets a file to write to when we save states
  (setq persp-state-default-file "~/.config/emacs/sessions"))

;; This will group buffers by persp-name in ibuffer.
(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Automatically save perspective states to file when Emacs exits.
(add-hook 'kill-emacs-hook #'persp-state-save)

;; Globally prettify symbols
(defun configure-prettify-symbols-alist ()
  "Set prettify symbols alist."
  (setq prettify-symbols-alist '(
				 ("lambda" . ?λ)
				 ("->" . ?→)
                                 ("=>" . ?⇒)
                                 ("/=" . ?≠)
                                 ("!=" . ?≠)
                                 ("==" . ?≡)
                                 ("<=" . ?≤)
                                 (">=" . ?≥)
                                 ("&&" . ?∧)
                                 ("||" . ?∨)
                                 ("not" . ?¬)
				 ))
(prettify-symbols-mode 1))
(add-hook 'prog-mode-hook 'configure-prettify-symbols-alist)
;; (add-hook 'org-mode-hook 'configure-prettify-symbols-alist)

(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-switch-project-action 'projectile-find-file))
(use-package consult-projectile)
(use-package persp-projectile)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook org-mode prog-mode)

(setq warning-minimum-level :error)
(delete-selection-mode 1)    ;; You can select text and delete it by typing.
(electric-indent-mode -1)    ;; Turn off the weird indenting that Emacs does by default.
(electric-pair-mode 1)       ;; Turns on automatic parens pairing
;; The following prevents <> from auto-pairing when electric-pair-mode is on.
;; Otherwise, org-tempo is broken when you try to <s TAB...
(add-hook 'org-mode-hook (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed
(global-display-line-numbers-mode 1) ;; Display line numbers
(global-visual-line-mode t)  ;; Enable truncated lines
(menu-bar-mode -1)           ;; Disable the menu bar
(scroll-bar-mode -1)         ;; Disable the scroll bar
(tool-bar-mode -1)           ;; Disable the tool bar
(setq org-edit-src-content-indentation 0) ;; Set src block automatic indent to 0 instead of 2.
(setq mouse-wheel-scroll-amount '(3))  ;; faster scroll speed
(setq mouse-wheel-progressive-speed nil)  ;; no scroll exelleration

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
  (setq shell-file-name "/bin/bash"
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

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
    doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package tldr)

(add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth

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
	  which-key-idle-delay 0.35
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " ))

(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs (concat Home "snippets"))
  (yas-global-mode 1))
(use-package yasnippet-snippets
   :requires yasnippet)
(use-package ivy-yasnippet
  :requires yasnippet)

(elpaca-wait)
(setq initial-buffer-choice (concat Home "start.org"))

(define-minor-mode start-mode
  "Provide functions for custom start page."
  :lighter " start"
  :keymap (let ((map (make-sparse-keymap)))
          ;;(define-key map (kbd "M-z") 'eshell)
          ;;   (evil-define-key 'normal start-mode-map
          ;;     (kbd "1") '(lambda () (interactive) (find-file (concat Home "config.org")))
          ;;     (kbd "2") '(lambda () (interactive) (find-file (concat Home "init.el")))
          ;;     (kbd "3") '(lambda () (interactive) (find-file (concat Home "packages.el")))
          ;;     (kbd "4") '(lambda () (interactive) (find-file (concat Home "eshell/aliases")))
          ;;     (kbd "5") '(lambda () (interactive) (find-file (concat Home "eshell/profile"))))
          map))

(add-hook 'start-mode-hook 'read-only-mode) ;; make start.org read-only; use 'SPC t r' to toggle off read-only.
;; (provide 'start-mode)
