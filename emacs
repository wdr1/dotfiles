;; $Id: .emacs,v 1.1.1.1 2010/08/14 04:57:50 wdr1 Exp $

(message "Loading ~/.emacs...")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Start-up Settings                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; These functions are to make it easier to turn backtracing on and off.
(defun dbon () (interactive)
  (setq debug-on-error t))
(defun dboff () (interactive)
  (setq debug-on-error nil))

;; And let's have it on while loading ~/.emacs
(dbon)

(setq meta-flag t)
(setq backup-by-copying              t)  ; To preserve ACLs, date/times, etc.
(setq backup-by-copying-when-linked  t)
(setq inhibit-local-variables        t)	; No Trojan file-variables
(setq enable-recursive-minibuffers   nil)
(setq explicit-shell-file-name "/bin/bash")
(setq inhibit-startup-message t)

(setq load-path
      (append (list 
               "/usr/local/lib/emacs/site-lisp" 
               "/usr/local/lib/emacs/lisp"
               (expand-file-name "~/emacslib/")
               ) load-path))
              
;; fix delete
(setq term-setup-hook
          '(lambda ()
             (setq keyboard-translate-table "\C-@\C-a\C-b\C-c\C-d\C-e\C-f\C-g\C-?")
             (global-set-key "\M-h" 'help-for-help)))


;; Load modes according to file suffixes.
;;;(load-library "php-mode")
;(add-hook 'php-mode-user-hook 'turn-on-font-lock)
(setq auto-mode-alist
      (append auto-mode-alist                
	      '(("\\.doc$"                    . text-mode)
          ("mutt-colorado"              . text-mode)
          ("^cvs"                       . text-mode)
          ("\\.txt$"                    . text-mode)
          ("\\.text$"                   . text-mode)
          ("\\.elc$"                    . emacs-lisp-mode)
          ("\\.ftn$"                    . fortran-mode)   
          ("\\.for$"                    . fortran-mode)
          ("\\.rpt$"                    . rpt-mode)
          ("\\.[.c,h,y]$"               . c-mode)
          ("\\.C$"                      . c-mode)
          ("\\.pl$"                     . cperl-mode)
;;          ("\\.php$" . php-mode)
          ("\\.txt$"                    . text-mode)
          ("\\.bash"                    . sh-mode)
          ("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode)
          ("\\.cgi$"                    . cperl-mode)
          ("\\.t$"                      . cperl-mode)
          ("\\.out$"                    . outline-mode)
          ("\\.sql$"                    . sql-mode)
          ("\\.js$"                     . java-mode)
          ("\\.rb$"                     . ruby-mode)
          ("\\.todo$"                   . cperl-mode)
          ("\\.tmpl$"                   . html-mode)
          ("\\.html$"                   . html-mode))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           Custom Functions                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'time-stamp-yyyy-mm-dd "time-stamp" "Time stamp." t)
(defun insert-date-and-name (arg)
    "Insert time stamp.  With prefix, insert stamp + name."
      (interactive "p")
        (let ((time (concat (time-stamp-yyyy-mm-dd) " "
                                  (substring (time-stamp-hh:mm:ss) 0 5) " EDT")))
              (if current-prefix-arg
                  (insert time " <" user-mail-address ">")
                      (insert time))))

(defun indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if (looking-at "\\>")
      (dabbrev-expand nil)
    (indent-for-tab-command)
    ))

(defun my-comment-block (comment)
  (interactive "sComment: ")
  (let* ((that-string
"############################################################################")
    (but-really 
     (substring that-string (length function-name) (length that-string))))
    (insert (concat but-really
                    "\n\n"
                    "/*****************************************************************\n"
                    "*  "
                    comment
                    "\n"
                    "***************************************************************** */\n"
                    "\n"))))

(defun my-function-skeleton (function-name)
  (interactive "sFunction: ")
  (let* ((that-string
"------------------------------------------------------------------")
    (but-really 
     (substring that-string (length function-name) (length that-string))))
    (insert (concat 
                    "## "
                    but-really
                    "  "
                    function-name
                    "  ---"
                    "\n"
                    "## "
                    "\n"
                    "sub "
                    function-name
                    " {"
                    "\n"
                    "  print \"Please define '"
                    function-name
                    "'.\\n\";\n"
                    "}"
                    "\n\n\n"))))

(defun my-insert-function (function)
  (interactive "SFunction Name: ")
  (let ((that-string "##----------------------------------------------------------------------------"))
    (substring (length function) (length that-string) that-string)
    insert (concat that-string
		   function
		   " ----")))

(defun my-overture-startup ()
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (split-window-vertically -9)
  (other-window 1)
  (switch-to-buffer "*Calendar*")
  (other-window -1)
  (calendar)
  (other-window 2)
  )

(defun my-overture-startup-old ()
  (interactive)
  (calendar)
  (other-window 1)
  )

(defun my-function-comment (function-name)
  (interactive "sFunction: ")
  (let* ((that-string
"##--------------------------------------------------------------------------")
    (but-really 
     (substring that-string (length function-name) (length that-string))))
    (insert (concat but-really
                    "  "
                    function-name
                    "  ###"
                    "\n"
                    "## "
                    "\n"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Mode Specific Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;                                                        == diary/org-mode ==
(autoload 'org-mode "org" "Org mode" t)
(autoload 'org-diary "org" "Diary entries from Org mode")
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-hook 'diary-display-hook 'fancy-diary-display)
(setq org-diary "C:\diary.org")

;;                                                        == wikipedia-mode ==
(autoload 'wikipedia-mode "wikipedia-mode.el"
  "Major mode for editing documents in Wikipedia markup." t)
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . wikipedia-mode))
(add-to-list 'auto-mode-alist '("mozex.\\.*" . wikipedia-mode))

;;                                                            == cperl-mode ==
;; Use cperl-mode instead  perl-mode
;; (autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)

;; (setq interpreter-mode-alist (append interpreter-mode-alist
;;                                      '(("miniperl" . perl-mode))))
(setq auto-mode-alist
      (append '(("\\.\\([pP][Llm]\\|al\\)$" . cperl-mode))  auto-mode-alist ))
(add-hook 'cperl-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "<tab>") 'indent-or-complete)
                      (local-set-key (kbd "TAB") 'indent-or-complete)
                      )))



 ;;                                                            == text-mode ==
;;(define-key text-mode-map (kbd "TAB") 'self-insert-command)
(define-key text-mode-map (kbd "TAB") 'indent-or-complete)

;;                                                           === tramp-mode ==
;; tramp (for working on remote files)
(add-to-list 'load-path "~/emacslib/tramp/")
(require 'ange-ftp)
(require 'tramp)
;; (add-to-list 'Info-default-directory-list "~/emacslib/tramp/texi/")
(setq tramp-default-method "scp")
(setq tramp-auto-save-directory "~/emacslib/.emacs-backup/")

;;                                                           === rmail-mode ==
(setq mail-yank-prefix "> ")
(setq mail-archive-file-name (expand-file-name "~/mail/outbox.txt"))
(setq rmail-ignored-headers "^via:\\|^mail-from:\\|^origin:\\|^status:\\|^received:\\|^x400-originator:\\|^x400-recipients:\\|^x400-received:\\|^x400-mts-identifier:\\|^x400-content-type:\\|^\\(resent-\\|\\)message-id:\\|^summary-line:\\|^resent-date:\\|^nntp-posting-host:|^Content-|^List|^X-Lyris|^Sender:")
(setq rmail-file-name "~/nsmail/inbox.rmail")
(setq sc-citation-leader "")
(setq sc-mumble "????")
(setq sc-preferred-header-style 1)
;; Some packages looks for this (mspool.el specifically)
(require 'custom)
;;   Load & Config mspools
(autoload 'mspools-show "mspools" "Show outstanding mail spools." t)
(setq mspools-folder-directory "~/Mail/")
(global-set-key "\C-cb" 'mspools-show) 
(setq mspools-update t)                ;Automatically update buffer.


;;                                                            === text-mode ==
(add-hook 'text-mode-hook
          (function (lambda () 
                      (auto-fill-mode 1)
                      (abbrev-mode 1))))

;;                                                            === sgml-mode ==
(add-hook 'sgml-mode-hook
          (function (lambda () 
                      (auto-fill-mode 0)
                      )))

;;                                                               === c-mode ==
(setq c-basic-indent 2)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq c-toggle-hungry-state 1)
(setq compilation-window-height 15)
(setq compilation-finish-function
      (lambda (buf str)
        
        (if (string-match "exited abnormally" str)
            ;;there were errors
            (next-error)
          ;;no errors, make the compilation window go away in 0.5 seconds
          ;(run-at-time 0.5 nil 'delete-windows-on buf)
          (message "== Clean Compile, Baby =="))))
(add-hook 'c-mode-common-hook
          (function (lambda ()
                      (local-set-key (kbd "<tab>") 'indent-or-complete)
                      (local-set-key (kbd "TAB") 'indent-or-complete)
                      )))


;;                                                             === c++-mode ==
;; (add-hook c++-mode-hook
;;           (function (lambda () 
;;                       (abbrev-mode 1))))
(define-abbrev-table 'c++-mode-abbrev-table '(
    ("sgg" #("s_.getGlobal(" 0 2 (face font-lock-variable-name-face) 2 13 nil) nil 0)
    ("sgc" "getConstGlobal(" nil 0)
    ))

;;                                                             === sql-mode ==
;; (add-hook sql-mode-hook
;;           (function (lambda () 
;;                       (setq-default tab-width 2)
;;                       )))

(eval-after-load "sql" 
  '(font-lock-add-keywords 
	'sql-mode
	'(("\\<\\(exception\\|notfound\\|pragma\\|cursor_already_open\\|dup_val_on_index\\|invalid_cursor\\|invalid_number\\|login_denied\\|no_data_found\\|not_logged_on\\|program_error\\|storage_error\\|timeout_on_resource\\|too_many_rows\\|transaction_backed_out\\|value_error\\|zero_divide\\|others\\)\\>"
	   . font-lock-warning-face)     ("\\<loop\\>" . font-lock-keyword-face)
	   ("\\<\\(if\\|elsif\\|else\\|while\\|return\\)\\>" . font-lock-function-name-face)))) 
(autoload 'sqlplus "sql-mode"
  "Run an interactive SQL*plus session in a separate buffer." t)

(autoload 'sql-mode "sql-mode"
  "Major mode for editing SQL*plus batch files." t)
(add-hook 'sql-mode-hook'(lambda ()
                             (progn ;;(setq plsql-indent 3)
                                    (turn-on-font-lock))))
(autoload 'pls-mode  "pls-mode" "PL/SQL Editing Mode" t)
(autoload 'diana-mode  "pls-mode" "DIANA for PL/SQL Browsing Mode" t)
(autoload 'plsql-mode "plsql-mode" "PL/SQL Mode" t)
(add-hook 'plsql-mode-hook'(lambda ()
                             (progn (setq plsql-indent 3)
                                    (turn-on-font-lock))))
(setq auto-mode-alist
      (append '(("\\.sql$" . sql-mode)
                ("\\.pls$"  . plsql-mode)
                ("\\.pld$"  . diana-mode)
                 )
              auto-mode-alist))
(define-abbrev-table 'sql-mode-abbrev-table '(
    ("db" "DBMS_OUTPUT.PUT_LINE(" nil 3)
    ("begin" "BEGIN" nil 3)
    ))

;;                                                       === supercite-mode ==
(autoload 'sc-cite-original     "supercite" "Supercite 3.1" t)
(autoload 'sc-submit-bug-report "supercite" "Supercite 3.1" t)
(add-hook 'mail-citation-hook 'sc-cite-original)
(setq sc-preferred-attribution-list
      '("emailname" "x-attribution" "sc-consult" "sc-lastchoice" "initials"
        "firstname" "middlename-1" "lastname") )

;;                                                 === version control mode ==
(setq vc-initial-comment t)
(add-hook 'vc-log-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "<tab>") 'indent-or-complete)
                      (local-set-key (kbd "TAB") 'indent-or-complete)
                      (insert "id: 25862 (LCCM Cluster Test Suite)\n-- ")
                      (end-of-buffer)
                      )))

(eval-and-compile
  (condition-case ()
      (require 'custom)
    (error nil))
  (if (and (featurep 'custom) (fboundp 'custom-declare-variable))
      nil ;; We've got what we needed
    ;; We have the old custom-library, hack around it!
    (defmacro defgroup (&rest args)
      nil)
    (defmacro defcustom (var value doc &rest args) 
      (` (defvar (, var) (, value) (, doc))))))

;;                                                              === hs-mode ==
(add-hook 'hs-minor-mode-hook
          (lambda () (local-set-key "\C-cs" 'hs-show-block)))
(add-hook 'hs-minor-mode-hook
          (lambda () (local-set-key "\C-ch" 'hs-hide-block)))
(add-hook 'hs-minor-mode-hook
          (lambda () (local-set-key "\C-cS" 'hs-show-all)))
(add-hook 'hs-minor-mode-hook
          (lambda () (local-set-key "\C-cH" 'hs-hide-all)))

;;                                                === autosave/backup modes ==
(defvar autosave-dir "~/emacslib/emacs-backup/") 
(make-directory autosave-dir t)
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name (concat "#%" (buffer-name) "#")))))
;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir "~/emacslib/emacs-backup/") 
(setq backup-directory-alist (list (cons "." backup-dir)))
;; ;; Change were backup files go
;; (defun make-backup-file-name (file)
;;   (concat "~/emacslib/emacs-backup/" (file-name-nondirectory file))
;;   )
;; (setq auto-save-directory "~/emacslib/.emacs-backup/")

(setq outline-regexp " *[#\*\f]")

;;                                                  === outline/diary modes ==
(setq outline-level 'wdr1-outline-level)
(defun wdr1-outline-level ()
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "\t ")
      (setq ilevel (+ (current-column) 2))
      (beginning-of-line)
      (if (looking-at "#")
          (setq ilevel 1))
      (+ ilevel 0)
      )))
(require 'time)
(defun insert-diary-entry (arg)
  "Insert a diary entry for the date indicated by point.
Prefix arg will make the entry nonmarking."
  (interactive "P")
  (wdr1-make-diary-entry
   (calendar-date-string (calendar-cursor-to-date t) t t)
   arg))
(setq calendar-date-display-form '((format "%04s-%02d-%02d" year (string-to-int month) (string-to-int day))))
(defun wdr1-make-diary-entry (string &optional nonmarking file)
  "Insert a diary entry STRING which may be NONMARKING in FILE.
If omitted, NONMARKING defaults to nil and FILE defaults to diary-file."
  (setq file (concat
;              "C:/Documents and Settings/wdr1.SEARCH/Desktop/txt/daily/"
              "~/Desktop/txt/daily/"
              "daily_" string ".txt"))
  (find-file-other-window
   (substitute-in-file-name (if file file diary-file)))
  (message "loaded")
  )

;;                                                            === ruby-mode ==
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                              interpreter-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Keyboard Shortcuts                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message "Keyboard mappings")

(define-key global-map [M-S-down-mouse-3] 'imenu)
(define-key global-map [(mouse-3)] 'imenu)

(global-set-key "\C-t" 'indent-or-complete)

(global-set-key "\M-g" 'goto-line)
 
(global-set-key "\C-r" 'replace-regexp)

(global-set-key "\C-r" 'replace-regexp)

(global-set-key "\C-xs" 'ispell-buffer)

(global-set-key "\C-cr" 'recompile)
(global-set-key [f6] 'recompile)
(global-set-key [f7] 'next-error)
(global-set-key [(f9)] 'compile)

(global-set-key "\C-ci" 'imenu)

(global-set-key "\C-c\g" 'my-function-comment)
(global-set-key "\C-cf" 'my-function-skeleton)

(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".imp" ".aux" ".lis" ".bbx")))

(define-key global-map [f4] 'bookmark-jump)
(define-key global-map [f5] 'bookmark-set)

(define-key global-map [f1] 'enlarge-window)

(global-set-key "\C-xd" 'insert-date-and-name)

;; Auto-indent (except in text mode)
(global-set-key (kbd "RET") 'newline-and-indent)
(define-key text-mode-map (kbd "RET") 'newline)

(message "... custom keymappings loaded.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       UI Settings                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Turn off the menubar is we're not going to use it 
(if (not window-system) (menu-bar-mode 0))

;; Help us balance paren's
(show-paren-mode)

;; Overwrite highlighted text
(delete-selection-mode t)

;;;fix the delete key on Solaris 2.5 [ from gnu.emacs.help]
;;;(global-set-key (read-kbd-macro "<delete>") 'delete-char)

;; set the default colors [form gnu.emacs.help] 
;; [[ Useful in Win32, but handled by .Xdefaults otherwise ]]
; (if window-system
;    (progn
;       (setq default-frame-alist 
;             '((width . 80) 
;               (height . 50) 
;               (foreground-color . "darkslateblue")
;               (background-color . "lemonchiffon")
;               (cursor-color . "IndianRed")
;               (pointer-color . "firebrick")
;               ))))


;; Flash rather than beep.
(setq visible-bell t)

;;  Settings that may do be happy in earlier versions of emacs 
(defun my-emacs-21-settings () (interactive) 
    (global-font-lock-mode t)
    (setq font-lock-maximum-decoration t)
    )

(if (>= emacs-major-version 21)
    (my-emacs-21-settings)
  )

(defun setup-hilit () (interactive)
  (global-font-lock-mode t)
  (setq font-lock-maximum-decoration t)
  )

;; do it.
(if window-system (setup-hilit))

;; When searching, highlight the item found so far.
(setq-default search-highlight t)

;; font-lock is syntax-highlighting (and kicks ass)
(defun font-lock-mode-on () (interactive)
  (font-lock-mode 1))

;; Turn on the time, but not the date
;;(display-time)
;;(setq display-time-day-and-date nil)

;; The variable special-display-regexps chooses some buffer names which
;; will bring up new frames rather than using a window within current frame. 
;; The value given here applies to processing traces in AUC-TeX.
(setq special-display-regexps '("\\*.*output\\*"
                                "\\*TeX Help\\*"
                                ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Smaller Tweaks & the Like                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default ispell-program-name "aspell")

(setq bookmark-save-flag 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq imenu-max-item-length 120)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Goodbye                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Now that ~/.emacs loaded successfully, turn
;; off bactracing.
(dboff)
(message "Loading ~/.emacs...done")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  Stuff set by the GUI options below  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  (Automaticly appended to the end of the file)  ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 '(cperl-invalid-face (quote (quote nothing))))
(custom-set-faces
 '(cperl-array-face ((t (:foreground "Gold"))))
 '(font-lock-function-name-face ((t (:foreground "lawn green"))))
 '(cperl-hash-face ((t (:foreground "LightBlue")))))

(put 'downcase-region 'disabled nil)

(fset 'insert-comment-block
   [return ?\C-p tab ?/ ?* escape ?6 ?0 ?* return ?* ?  ?  return escape ?6 ?0 ?* ?* ?/ ?\C-p ?  ? ])

(put 'upcase-region 'disabled nil)
