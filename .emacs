
;;(set-default-font "-adobe-courier-medium-r-normal--12-120-75-75-m-70-iso10646-1")


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/color-theme/")

;(add-to-list 'load-path "~/.emacs.d/")

(defun force-revert ()
  (interactive)
  (revert-buffer 'ignore-auto 'dont-compileask))

(defun reload-emacs-file ()
  (interactive)
  (load "~/.emacs"))

(setq auto-mode-alist
      (append '(("\\.proto" . c++-mode)) auto-mode-alist))

;; doesn't work :(
(setq mac-command-modifier 'meta)

(setq column-number-mode t)

(setq tab-width 2)
(setq-default indent-tabs-mode nil)
(setq truncate-lines t)

;; (global-set-key "\C-o" 'other-window)
(global-set-key "\C-o" 'next-multiframe-window)
(global-set-key "\C-p" 'previous-multiframe-window)

(global-set-key "\C-f" 'recenter)

(global-set-key (kbd "A-<up>") 'beginning-of-buffer)
(global-set-key (kbd "A-<down>") 'end-of-buffer)

(global-set-key [(control ?\()] 'start-kbd-macro)
(global-set-key [(control ?\))] 'end-kbd-macro)

(global-set-key [(control ?\+)] 'my-call-last-kbd-macro-region)
(global-set-key [(control ?\=)] 'call-last-kbd-macro)

(defun my-call-last-kbd-macro-region (beg end)
  "Calls last kbd macro for given region."
  (interactive "r")
  (goto-char (min beg end))
  (call-last-kbd-macro (count-lines beg end)))

;; (global-set-key "\C-(" 'definining-kbd-macro)
;; (global-set-key "\C-p" 'end-kbd-macro)
;; (global-set-key "\C-\=" 'call-last-kbd-macro)
(global-set-key "\C-b" 'buffer-menu)
(global-set-key "\C-q" 'kill-buffer)
(global-set-key "\M-/" 'undo)
(global-set-key "\M-S" 'query-replace)
(global-set-key "\M-r" 'reload-emacs-file)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\M-c" 'clipboard-kill-ring-save)
(global-set-key "\C-l" 'goto-line)
(global-set-key "\M-l" 'goto-line)
(global-set-key "\M-v" 'yank)

;; (global-set-key "\C-f" 'scroll-down)
(global-set-key (kbd "M-<up>") 'beginning-of-buffer)
(global-set-key (kbd "M-<down>") 'end-of-buffer)
(global-set-key "\M-/" 'dabbrev-expand)
(global-set-key [f5] 'revert-buffer)
(setq revert-without-query '(".*"))

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

(global-set-key "\M-R" 'force-revert)

(global-set-key (kbd "ESC <up>") 'backward-paragraph)
(global-set-key (kbd "ESC <down>") 'forward-paragraph)

(global-set-key (kbd "M-[ 5 c") 'forward-word)
(global-set-key (kbd "M-[ 5 d") 'backward-word)

;; doesn't work :(
;;(set-cursor-color "red")
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; (require 'color-theme)
;; (defun color-theme-djcb-dark ()
;;   "dark color theme created by djcb, Jan. 2009."
;;   (interactive)
;;   (color-theme-install
;;     '(color-theme-djcb-dark
;;        ((foreground-color . "#a9eadf")
;;          (background-color . "black") 
;;          (background-mode . dark))
;;        (bold ((t (:bold t))))
;;        (bold-italic ((t (:italic t :bold t))))
;;        (default ((t (nil))))
       
;;        (font-lock-builtin-face ((t (:italic t :foreground "#a96da0"))))
;;        (font-lock-comment-face ((t (:italic t :foreground "#bbbbbb"))))
;;        (font-lock-comment-delimiter-face ((t (:foreground "#666666"))))
;;        (font-lock-constant-face ((t (:bold t :foreground "#197b6e"))))
;;        (font-lock-doc-string-face ((t (:foreground "#3041c4"))))
;;        (font-lock-doc-face ((t (:foreground "gray"))))
;;        (font-lock-reference-face ((t (:foreground "white"))))
;;        (font-lock-function-name-face ((t (:foreground "#356da0"))))
;;        (font-lock-keyword-face ((t (:bold t :foreground "#bcf0f1"))))
;;        (font-lock-preprocessor-face ((t (:foreground "#e3ea94"))))
;;        (font-lock-string-face ((t (:foreground "#ffffff"))))
;;        (font-lock-type-face ((t (:bold t :foreground "#364498"))))
;;        (font-lock-variable-name-face ((t (:foreground "#7685de"))))
;;        (font-lock-warning-face ((t (:bold t :italic nil :underline nil 
;;                                      :foreground "yellow"))))
;;        (hl-line ((t (:background "#112233"))))
;;        (mode-line ((t (:foreground "#ffffff" :background "#333333"))))
;;        (region ((t (:foreground nil :background "#555555"))))
;;        (show-paren-match-face ((t (:bold t :foreground "#ffffff" 
;;                                     :background "#050505")))))))

;; (color-theme-djcb-dark)


(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(defun ryan/set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell.

from http://stackoverflow.com/questions/8606954/path-and-exec-path-set-but-emacs-does-not-find-executable"
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(ryan/set-exec-path-from-shell-PATH)

;; Add opam emacs directory to the load-path
(setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
;; Load merlin-mode
(require 'merlin)
;; Start merlin on ocaml files
(add-hook 'tuareg-mode-hook 'merlin-mode t)
(add-hook 'caml-mode-hook 'merlin-mode t)
;; Enable auto-complete
(setq merlin-use-auto-complete-mode 't)
;; Use opam switch to lookup ocamlmerlin binary
(setq merlin-command 'opam)

(setq merlin-ac-setup 't)

; Make company aware of merlin
(with-eval-after-load 'company
 (add-to-list 'company-backends 'merlin-company-backend))
; Enable company on merlin managed buffers
(add-hook 'merlin-mode-hook 'company-mode)
; Or enable it globally:
; (add-hook 'after-init-hook 'global-company-mode)

(add-to-list 'load-path "/Users/ryan/.opam/4.02.1/share/emacs/site-lisp")
(require 'ocp-indent)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
