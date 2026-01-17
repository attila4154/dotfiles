;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

(setq inhibit-startup-message t  ; Don't show the splash screen
      visible-bell t)            ; Flash when the bell rings

;; This could also be:

(setq inhibit-startup-message t) ; Don't show the splash screen
(setq visible-bell t)            ; Flash when the bell rings

;; Turn off some unneeded UI elements
(menu-bar-mode -1)  ; Leave this one on if you're a beginner!
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; Load the Modus Vivendi dark theme
(load-theme 'doric-obsidian t)


;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             '("org" . "https://orgmode.org/elpa"))
;; Setup use-package just in case everything isn't already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(package-initialize)
(package-refresh-contents)

(set-frame-font "iA Writer Duo V 22" nil t)
(set-frame-font "JetBrains Mono 22" nil t)
(setq-default line-spacing 2)

;;(set-frame-font "Cascadia Code Light 22" nil t)



;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-mode nil nil nil "Customized with use-package ivy")
 '(org-cycle-hide-block-startup t)
 '(org-startup-folded "fold")
 '(package-selected-packages
   '(buffer-flip counsel doom-modeline doric-themes evil focus
		 good-scroll ivy lsp-treemacs lsp-ui mood-line
		 orderless org-present org-roam-ui org-tree-slide
		 treesit vertico visual-fill-column)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-date ((t (:foreground "#b0b0b0" :height 0.8))))
 '(org-level-1 ((t (:inherit bold :extend nil :foreground "gray52"))))
 '(org-special-keyword ((t (:foreground "#969696" :height 0.8)))))

(use-package org
  :pin gnu)
;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org-roam" "~/org-roam/daily"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)
;; focus-mode
;; (add-hook 'org-mode-hook 'focus-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)
(define-key org-mode-map (kbd "<tab>") 'org-cycle)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

(setq org-todo-keywords
      '((sequence "TODO" "IN PR" "|" "DONE" "OMIT" "MOVED")))
(setq org-highest-priority ?A
      org-default-priority ?B
      org-lowest-priority ?E)
(setq org-fold-core-style 'overlays)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook (lambda ()
			   (visual-line-mode 1)
			   (display-line-numbers-mode 0))
)

(add-hook 'org-mode-hook (lambda ()
    (setq visual-fill-column-width 95)
    (visual-fill-column-mode 1)
    (setq visual-fill-column-center-text t)
))


(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  (org-roam-setup)
  (org-roam-db-autosync-mode)
 )



;; Enable Vertico.
(use-package vertico
  ;;:custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(setq mac-right-option-modifier 'control)
(setq mac-option-modifier 'control)
(setq mac-command-modifier 'meta)


(global-set-key "\M-H" 'previous-buffer)
(global-set-key "\M-L" 'next-buffer)

;; disable annoying warn sign
;; you really only need one of these
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; omg, thanks macos
(pixel-scroll-precision-mode)

(use-package buffer-flip
  :ensure t
  :bind  (("C-<tab>" . buffer-flip)
          :map buffer-flip-map
          ( "C-<tab>" .   buffer-flip-forward) 
          ( "C-S-<tab>" . buffer-flip-backward) 
          ( "C-ESC" .     buffer-flip-abort))
  :config
  (setq buffer-flip-skip-patterns
        '("^\\*helm\\b"
          "^\\*swiper\\*$")))

;; open org mode file link in the same window
(setq org-link-frame-setup
      '((file . find-file)))

;; remove top bar in macos(?)
(add-to-list 'default-frame-alist '(undecorated . t))

(mood-line-mode)

(auto-save-visited-mode 1)
(setq auto-save-visited-interval 10)


(defun my/random-suffix (n)
  "Return a random N-character string from a–z0–9."
  (let* ((chars "abcdefghijklmnopqrstuvwxyz0123456789")
         (len (length chars))
         (s ""))
    (dotimes (_ n s)
      (setq s (concat s (string (elt chars (random len))))))))

(setq org-roam-capture-templates
      `(("d" "default" plain "%?"
         :if-new (file+head "${slug}-%(my/random-suffix 4).org"
                            "#+title: ${title}\n")
         :unnarrowed t)))

(setq org-columns-default-format "%60ITEM(Task) %TODO %6Effort(Estim){:}  %6CLOCKSUM(Clock) %TAGS")

(use-package counsel
  :ensure t
  :init
  ;; Settings that should happen before the package loads
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t)
  
  :config
  ;; Start ivy-mode once counsel is loaded
  (ivy-mode 1)
  
  :bind (;; Global keybindings
         ("C-s" . swiper-isearch)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> o" . counsel-describe-symbol)
         ("<f1> l" . counsel-find-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-o" . counsel-rhythmbox)
         ;; Keybinding for a specific map
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history))
)

;; (use-package lsp-mode
;;   :init
;;   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;          (ts-mode . lsp)
;;          ;; if you want which-key integration
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands lsp)

;; ;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; ;; if you are helm user
;; ;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; ;; if you are ivy user
;; ;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; ;; optionally if you want to use debugger
;; ;; (use-package dap-mode)
;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; ;; optional if you want which-key integration
;; (use-package which-key
;;     :config
;;     (which-key-mode))
;; (use-package treesit
;;       :mode (("\\.tsx\\'" . tsx-ts-mode)
;;              ("\\.js\\'"  . typescript-ts-mode)
;;              ("\\.mjs\\'" . typescript-ts-mode)
;;              ("\\.mts\\'" . typescript-ts-mode)
;;              ("\\.cjs\\'" . typescript-ts-mode)
;;              ("\\.ts\\'"  . typescript-ts-mode)
;;              ("\\.jsx\\'" . tsx-ts-mode)
;;              ("\\.json\\'" .  json-ts-mode)
;;              ("\\.Dockerfile\\'" . dockerfile-ts-mode)
;;              ("\\.prisma\\'" . prisma-ts-mode)
;;              ;; More modes defined here...
;;              )
;;       :preface
;;       (defun os/setup-install-grammars ()
;;         "Install Tree-sitter grammars if they are absent."
;;         (interactive)
;;         (dolist (grammar
;;                  '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
;;                    (bash "https://github.com/tree-sitter/tree-sitter-bash")
;;                    (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
;;                    (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
;;                    (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
;;                    (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
;;                    (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
;;                    (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;                    (make "https://github.com/alemuller/tree-sitter-make")
;;                    (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;                    (cmake "https://github.com/uyha/tree-sitter-cmake")
;;                    (c "https://github.com/tree-sitter/tree-sitter-c")
;;                    (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
;;                    (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;                    (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
;;                    (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
;;                    (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
;;                    (prisma "https://github.com/victorhqc/tree-sitter-prisma")))
;;           (add-to-list 'treesit-language-source-alist grammar)
;;           ;; Only install `grammar' if we don't already have it
;;           ;; installed. However, if you want to *update* a grammar then
;;           ;; this obviously prevents that from happening.
;;           (unless (treesit-language-available-p (car grammar))
;;             (treesit-install-language-grammar (car grammar)))))

;;       ;; Optional, but recommended. Tree-sitter enabled major modes are
;;       ;; distinct from their ordinary counterparts.
;;       ;;
;;       ;; You can remap major modes with `major-mode-remap-alist'. Note
;;       ;; that this does *not* extend to hooks! Make sure you migrate them
;;       ;; also
;;       (dolist (mapping
;;                '((python-mode . python-ts-mode)
;;                  (css-mode . css-ts-mode)
;;                  (typescript-mode . typescript-ts-mode)
;;                  (js-mode . typescript-ts-mode)
;;                  (js2-mode . typescript-ts-mode)
;;                  (c-mode . c-ts-mode)
;;                  (c++-mode . c++-ts-mode)
;;                  (c-or-c++-mode . c-or-c++-ts-mode)
;;                  (bash-mode . bash-ts-mode)
;;                  (css-mode . css-ts-mode)
;;                  (json-mode . json-ts-mode)
;;                  (js-json-mode . json-ts-mode)
;;                  (sh-mode . bash-ts-mode)
;;                  (sh-base-mode . bash-ts-mode)))
;;         (add-to-list 'major-mode-remap-alist mapping))
;;       :config
;;       (os/setup-install-grammars))

(unless (package-installed-p 'org-present)
  (package-install 'org-present))

(unless (package-installed-p 'org-tree-slide)
  (package-install 'org-tree-slide))

(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree)
  )

;; keep it at the end
(find-file "/Users/danilamakulov/org-roam/20250909181028-mantra.org")

(defun my/org-set-created-on-first-todo ()
  "Set CREATED property when a task first becomes a TODO."
  (when (and (org-get-todo-state)              ; now is a TODO
             (not (member org-last-state org-done-keywords))
             (not (org-entry-get nil "CREATED")))
    (org-set-property "CREATED"
                      (format-time-string "[%Y-%m-%d %a %H:%M]"))))

(add-hook 'org-after-todo-state-change-hook
          #'my/org-set-created-on-first-todo)
