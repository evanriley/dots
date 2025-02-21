;; WARNING: Some options may require an incredibly recent commit 
(in-package :lem-user)
;; When evaluating Lisp, do so with Lem's package
(lem-lisp-mode/internal::lisp-set-package "LEM")

;;vi-mode
(lem-vi-mode:vi-mode)
(setf (lem-vi-mode:option-value "scrolloff") 5)
(add-hook lem-lisp-mode:*lisp-repl-mode-hook* 'lem-vi-mode/commands:vi-insert)

;; enable line numbers, and make them relative
(lem/line-numbers:toggle-line-numbers)
(setf lem/line-numbers:*relative-line* t)

;; font
(lem-if:set-font-size(implementation) 20)
(lem-core/commands/frame::maximize-frame)

;;nord theme
(lem-base16-themes::define-base16-color-theme "nord"
  :base00 "#2e3440"
  :base01 "#3b4252"
  :base02 "#434c5e"
  :base03 "#4c566a"
  :base04 "#d8dee9"
  :base05 "#e5e9f0"
  :base06 "#eceff4"
  :base07 "#8fbcbb"
  :base08 "#bf616a"
  :base09 "#d08770"
  :base0a "#ebcb8b"
  :base0b "#a3be8c"
  :base0c "#88c0d0"
  :base0d "#81a1c1"
  :base0e "#b48ead"
  :base0f "#5e81ac")
(lem-core:load-theme "nord")

;; bindings similar to doom emacs
;; Doom-like keybindings using Space as leader
(define-key lem-vi-mode:*normal-keymap* "Space w s" 'split-active-window-horizontally)
(define-key lem-vi-mode:*normal-keymap* "Space w v" 'split-active-window-vertically)
(define-key lem-vi-mode:*normal-keymap* "Space w w" 'switch-to-last-focused-window)
(define-key lem-vi-mode:*normal-keymap* "Space w q" 'delete-active-window)
(define-key lem-vi-mode:*normal-keymap* "Space b k" 'kill-buffer)
(define-key lem-vi-mode:*normal-keymap* "Space b b" 'select-buffer)
(define-key lem-vi-mode:*normal-keymap* "Space f f" 'find-file)
(define-key lem-vi-mode:*normal-keymap* "Space f s" 'save-current-buffer)

;; Buffer navigation
(define-key lem-vi-mode:*normal-keymap* "C-h" 'window-move-left)
(define-key lem-vi-mode:*normal-keymap* "C-j" 'window-move-down)
(define-key lem-vi-mode:*normal-keymap* "C-k" 'window-move-up)
(define-key lem-vi-mode:*normal-keymap* "C-l" 'window-move-right)

;; Common Doom-like operations
(define-key lem-vi-mode:*normal-keymap* "g c c" 'lem/language-mode::comment-or-uncomment-region)
(define-key lem-vi-mode:*normal-keymap* "Space h k" 'describe-key)
(define-key lem-vi-mode:*normal-keymap* "Space q q" 'exit-lem)

;; Buffer management
(define-key lem-vi-mode:*normal-keymap* "Space b n" 'next-buffer)
(define-key lem-vi-mode:*normal-keymap* "Space b p" 'previous-buffer)
(define-key lem-vi-mode:*normal-keymap* "Space b d" 'kill-buffer)

;; File operations
(define-key lem-vi-mode:*normal-keymap* "Space f r" 'revert-buffer)

;; Search and replace
(define-key lem-vi-mode:*normal-keymap* "Space s r" 'lem/isearch::query-replace)

;; Toggle commands
(define-key lem-vi-mode:*normal-keymap* "Space t l" 'lem/line-numbers::toggle-line-numbers)
(define-key lem-vi-mode:*normal-keymap* "Space t w" 'lem-core/commands/window::toggle-line-wrap)

;; Window management
(define-key lem-vi-mode:*normal-keymap* "Space w d" 'delete-active-window)
(define-key lem-vi-mode:*normal-keymap* "Space w m" 'maximize-frame)

;; Lisp Evaluation (similar to Doom's SPC m or local leader bindings)
(define-key lem-vi-mode:*normal-keymap* ", e b" 'lem-lisp-mode/eval::lisp-eval-buffer)
(define-key lem-vi-mode:*visual-keymap* ", e r" 'lem-lisp-mode/eval::lisp-eval-region)
(define-key lem-vi-mode:*normal-keymap* ", e e" 'lem-lisp-mode/eval::lisp-eval-defun)

;; REPL interactions
(define-key lem-vi-mode:*normal-keymap* "Space m s i" 'lem-lisp-mode::start-lisp-repl)
(define-key lem-vi-mode:*normal-keymap* "Space m s s" 'lem-lisp-mode::lisp-switch-to-repl-buffer)

;; Project search
(define-key lem-vi-mode:*normal-keymap* "Space p s" 'lem/grep::project-grep)

(lem:add-hook lem-lisp-mode:*lisp-repl-mode-hook* 'lem-vi-mode/commands:vi-insert)
(lem:add-hook lem-lisp-mode:*lisp-sldb-mode-hook* 'lem-vi-mode/commands:vi-normal)

;;;; -- auto save --
(setf (lem:variable-value 'lem/auto-save::auto-save-checkpoint-frequency :global) 1.5)
;; NOTE: Don't set the key count threshold, or it will conflict with the auto-save, causing it unable to undo.
(setf (lem:variable-value 'lem/auto-save::auto-save-key-count-threshold :global) 8)
(lem/auto-save::auto-save-mode t)

;; show the completion list directly, without a first press on TAB:
(add-hook *prompt-after-activate-hook*
          (lambda ()
            (call-command 'lem/prompt-window::prompt-completion nil)))

(add-hook *prompt-deactivate-hook*
          (lambda ()
            (lem/completion-mode:completion-end)))

;; Paredit-like functionality for Lisp modes
(add-hook lem-lisp-mode:*lisp-mode-hook*
          (lambda ()
            (lem-paredit-mode:paredit-mode t)))
