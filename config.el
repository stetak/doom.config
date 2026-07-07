;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;(when (eq system-type 'darwin)
;;  (setenv "CC" "/opt/homebrew/bin/gcc-16")
;;  (setenv "CXX" "/opt/homebrew/bin/g++-16")
;;  (setenv "FC" "/opt/homebrew/bin/gfortran-16")
;;  (add-to-list 'exec-path "/opt/homebrew/bin"))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;;
;; Default: doom-one
;; Other options: doom-manegarm, doom-sorcerer, and doom gruvbox
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; 2026-02-04
;; Start the server - in particular to do org-capture with a shell script
(server-start)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; 2025-04-14
;; Remap mac keys to be in the same physical position as my linux keyboard
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super))

;; 2026-06-22
;; Fix monospace font in mac
;; brew install --cask font-jetbrains-mono
(setq doom-font (font-spec :family "JetBrains Mono" :size 12))

;; 2025-04-09
;; Fix symbols for org-modern
;; brew install --cask font-noto-sans-symbols
(after! core-fonts
  (set-fontset-font t 'symbol "Noto Sans Symbols" nil 'prepend))

;; 2026-01-08 - Disabled due to this breaking LSP in general
;; 2025-03-28 - Github actions support
;;
;; Requires: npm install -g yaml-language-server
;;(after! lsp-yaml
;;  (add-to-list 'lsp-yaml-schema-store
;;               '("https://json.schemastore.org/github-worflow.json" . "/.github/workflows/*.yml")))

;; Extra config for github workflows
;;(add-hook! 'yaml-mode-hook
;;           (when (and buffer-file-name
;;                      (string-match-p "github/worflows" buffer-file-name))
;;             (setq-local indent-tabs-mode nil)
;;             (setq-local yaml-indent-offset 2)))

;; 2026-01-06 - Needed to explicitly include homebrew path for aspell
;; 2025-03-28 - Spell check
;; 
;; Requires brew install aspell
(when (eq system-type 'darwin)
  (setq ispell-program-name "/opt/homebrew/bin/aspell"))
(setq ispell-dictionary "en_US")

;; Enable in text-modes
(add-hook! '(test-mode-hook markdown-mode-hook org-mode-hook)
           #'flyspell-mode)

;; Enable in comments in code
(add-hook! '(prog-mode-hook)
           #'flyspell-prog-mode)

;; 2025-03-26
;; Turn off auto-complete popups in org mode - I don't need autocomplete for English
(after! org
  (add-hook! 'org-mode-hook
    (corfu-mode -1)))

;; 2025-05-08 Simplify org todo sequences
(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)" ;; A task that needs to be done
           "LOOP(r)" ;; A recurring task
           "STRT(s)" ;; A task that has started
           "WAIT(w)" ;; A task that is waiting on something
           "HOLD(h)" ;; On hold
           "IDEA(i)" ;; Uncommitted idea
           "|"
           "DONE(d)" ;; Completed
           "OBYE(o)" ;; Overcome by events
           "CNCL(c)") ;; Cancelled)
          ))
  (setq org-todo-keyword-faces
        '(("STRT" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("OBYE" . +org-todo-done)
          ("CNCL" . +org-todo-cancel)
          )
        ))

;; 2026-01-26 Change org header font-face sizes
(after! org
  (set-face-attribute 'org-level-1 nil
                      :height 1.3
                      :weight 'bold
                      :box `(:line-width 10 :color ,(face-background 'default))
                      )
  )

;; 2026-02-02 Fix the missing arrows from the third level!
(after! org
  (setq org-modern-fold-stars
        '(("▶" . "▼") ("▷" . "▽") ("⏵" . "⏷") ("▹" . "▿") ("▸" . "▾"))))

;; 2026-02-04 Setup a default org capture to use with a shortcut
;;
;; Shortcut script is in ~/bin/org-capture.sh
(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Documents/StratOps/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a  \n  %i")
          ("x" "Todo" entry (file+headline "~/Documents/StratOps/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %(shell-command-to-string \"pbpaste\")\n")))
  ;; Put new items at the top of the list
  (setq org-reverse-note-order t))


;; 2026-01-26 Remove keybindings from company so arrows don't interact with
;; autocomplete popups
(after! company
  (setq company-active-map (make-sparse-keymap))
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil))

;; 2026-01-08 Trying to enable tree-sitter for python
;;(after! tree-sitter
;;  (global-tree-sitter-mode)
;;  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;  (add-hook 'python-mode-hook #'tree-sitter-mode))


;; Commented 2025-10-20 when switching to ECA
;; 2025-07-07 Configure Copilot tab-completion
;;(use-package! copilot
;;  :hook (prog-mode . copilot-mode)
;;  :bind (:map copilot-completion-map
;;              ("<tab>" . 'copilot-accept-completion)
;;              ("TAB" . 'copilot-accept-completion)
;;              ("C-<tab>" . 'copilot-accept-completion-by-word)
;;              ("C-TAB" . 'copilot-accept-completion-by-word)))

;; frontend could also be org-mode if I prefer
;;(use-package! copilot-chat
;;  :after (copilot shell-maker)
;;  :config
;;  (setq copilot-chat-frontend 'shell-maker))


;; Need to setup keybindings AFTER copilot-chat is loaded
;;(after! copilot-chat
;;  (map! :map copilot-chat-mode-map
;;        :n "C-c C-c" #'copilot-chat-send
;;        :n "C-c C-r" #'copilot-chat-reset))        


;; 2026-06-22 agent-shell
(require 'acp)
(require 'agent-shell)
(require 'agent-shell-attention)

;; Copy environment variables from emacs process
(setq agent-shell-anthropic-claude-environment
      (agent-shell-make-environment-variables
       "CLAUDE_CODE_USE_VERTEX" "1"
       "CLOUD_ML_REGION" "global"
       "ANTHROPIC_VERTEX_PROJECT_ID" "viasat-claude-code"
       :inherit-env t))

(setopt agent-shell-attention-render-function
        #'agent-shell-attention-render-active)
(setopt agent-shell-attention-indicator-location 'global-mode-string)
(setopt agent-shell-attention-show-zeros t)
(agent-shell-attention-mode 1)
      
