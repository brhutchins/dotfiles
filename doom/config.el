;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Barnaby Hutchins"
      user-mail-address "bhutchins@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hasklug Nerd Font Mono" :size 11)
      doom-variable-pitch-font (font-spec :family "Inter" :size 11))

;; Ligatures support
(let ((alist '((?! . "\\(?:!\\(?:==\\|[!=]\\)\\)")
              (?# . "\\(?:#\\(?:###?\\|_(\\|[!#(:=?[_{]\\)\\)")
              (?$ . "\\(?:\\$>\\)")
              (?& . "\\(?:&&&?\\)")
              (?* . "\\(?:\\*\\(?:\\*\\*\\|[/>]\\)\\)")
              (?+ . "\\(?:\\+\\(?:\\+\\+\\|[+>]\\)\\)")
              (?- . "\\(?:-\\(?:-[>-]\\|<<\\|>>\\|[<>|~-]\\)\\)")
              (?. . "\\(?:\\.\\(?:\\.[.<]\\|[.=?-]\\)\\)")
              (?/ . "\\(?:/\\(?:\\*\\*\\|//\\|==\\|[*/=>]\\)\\)")
              (?: . "\\(?::\\(?:::\\|\\?>\\|[:<-?]\\)\\)")
              (?\; . "\\(?:;;\\)")
              (?< . "\\(?:<\\(?:!--\\|\\$>\\|\\*>\\|\\+>\\|-[<>|]\\|/>\\|<[<=-]\\|=\\(?:=>\\|[<=>|]\\)\\||\\(?:||::=\\|[>|]\\)\\|~[>~]\\|[$*+/:<=>|~-]\\)\\)")
              (?= . "\\(?:=\\(?:!=\\|/=\\|:=\\|=[=>]\\|>>\\|[=>]\\)\\)")
               (?> . "\\(?:>\\(?:=>\\|>[=>-]\\|[]:=-]\\)\\)")
               (?? . "\\(?:\\?[.:=?]\\)")
              (?\[ . "\\(?:\\[\\(?:||]\\|[<|]\\)\\)")
              (?\ . "\\(?:\\\\/?\\)")
              (?\] . "\\(?:]#\\)")
              (?^ . "\\(?:\\^=\\)")
              (?_ . "\\(?:_\\(?:|?_\\)\\)")
              (?{ . "\\(?:{|\\)")
              (?| . "\\(?:|\\(?:->\\|=>\\||\\(?:|>\\|[=>-]\\)\\|[]=>|}-]\\)\\)")
              (?~ . "\\(?:~\\(?:~>\\|[=>@~-]\\)\\)"))))
  (dolist (char-regexp alist)
   (set-char-table-range composition-function-table (car char-regexp)
                         `([,(cdr char-regexp) 0 font-shape-gstring]))));

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-oceanic-next)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Org-reveal
(require 'ox-reveal)

;; Evil-lion
(use-package evil-lion
;;  :ensure t
  :config
  (evil-lion-mode))

;;
;; Org-mode-specific config
;;
(require 'org)

;; Key binding for inserting zero-width space in org-mode
;; Taken from This Month in Org, May 2021
(define-key org-mode-map (kbd "M-SPC M-SPC")
  (lambda () (interactive) (insert "\u200b")))

;; Remove zero-width spaces from org-mode output
;; Taken from This Month in Org, May 2021
(defun +org-export-remove-zero-width-space (text _backend _info)
  "Remove zero width spaces from TEXT."
  (unless (org-export-derived-backend-p 'org)
    (replace-regexp-in-string "\u200b" "" text)))

(add-to-list 'org-export-filter-final-output-functions #'+org-export-remove-zero-width-space t)

;; Key binding for inserting section symbol in org-mode
(define-key org-mode-map (kbd "M-S")
  (lambda () (interactive) (insert "\u00a7")))

;; org-mode LaTeX export
(add-to-list 'org-latex-classes
             '("simpleDoc"
               "\\documentclass{simpleDoc}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; nov (ebook reader)
(use-package! nov
  ;; :mode ("\\.epub\\'" . nov-mode)
  :init (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places"))
  )

;; Haskell
;; (require 'haskell-mode)
;; (setq haskell-process-type 'cabal-repl)
;; (use-package! nix-haskell-mode
  ;; :hook (haskell-mode . nix-haskell-mode))

(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)
