;; Miquel's Emacs customisations
;; Inspired from http://aruljohn.com/info/emacs/

;; Show lines and columns
(line-number-mode "on")
(column-number-mode "on")

;; External packages
(add-to-list 'load-path "~/.emacs.d")

(require 'linum)
(global-linum-mode 1)
(setq linum-format "%3d ")

;; At kill, additional unsolicited spaces will be removed
(defun kill-and-join-forward (&optional arg)
  "If at end of line, join with following; otherwise kill line.
Deletes whitespace at join."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (delete-indentation t)
    (kill-line arg)))

(global-set-key "\C-k" 'kill-and-join-forward)

;; At yank, indentation is automatic
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      python-mode
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))

;; Linux indentation by default (not GNU default)
(setq c-default-style "linux-tabs-only"
      c-basic-offset 8)

;; Linux Kernel C-style vs any other C file
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "linux")
                                       filename))
                (setq indent-tabs-mode t)
                (setq show-trailing-whitespace t)
                (c-set-style "linux-tabs-only")))))

;; DTS mode
(require 'dts-mode)
(load-file "~/.emacs.d/dts-mode.el")

;; 80th column limit
(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "grey80")
(setq-default fci-rule-character-color "green")
;(add-hook 'after-change-major-mode-hook 'fci-mode)
(load-file "~/.emacs.d/fill-column-indicator.el")

;; Whitespaces and 80th column rule
 (require 'whitespace)
 (setq whitespace-style '(face empty lines-tail trailing))
 (global-whitespace-mode t)
