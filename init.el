;; init.el --- Emacs configuration

;; Font Configuration ----------------------------------------------------------
(set-face-attribute 'default nil :font "Fira Code Retina" :height 100)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 100)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 130 :weight 'regular)

;; Package Manager Configuration -----------------------------------------------
(require 'package)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")
                          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                          ;; ("org" . "https://orgmode.org/elpa/")
                          ("elpa" . "https://elpa.gnu.org/packages/")))
                          ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                          ;; ("marmalade" . "https://marmalade-repo.org/packages/")
(customize-set-variable 'package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
;; For diminish minor modes in modeline
(use-package diminish)

;; ??
(put 'use-package 'lisp-indent-function 1)

;; To see statistics run M-x use-package-report
(setq use-package-compute-statistics t)
;; To always use :ensure t and don't need to specify
(setq use-package-always-ensure t)

(use-package system-packages
  :custom
  (system-packages-noconfirm t))
             
;; keep your packages updated automatically
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package use-package-ensure-system-package)

;; Pip packages
;; pip install flake8 jedi autopep8 ipython --user
;; Need to install by hand because you get the error:
;; Error (use-package): Cannot load [pip/flake8/etc]
;; (use-package pip
;;   :ensure-system-package
;;   (pip . "doas pkg install py37-pip"))

;; (use-package flake8
;;   :ensure-system-package
;;   (flake8 . "pip install flake8 --user"))

;; (use-package jedi
;;   :ensure-system-package
;;   ("~/.local/lib/python3.7/site-packages/jedi" . "pip install jedi --user"))

;; (use-package autopep8
;;   :ensure-system-package
;;   (autopep8 . "pip install autopep8 --user"))

;; (use-package ipython
;;   :ensure-system-package
;;   (ipython . "pip install ipython --user"))
                                                      

;; Install packages

;; el-patch  para parchear  funciones en  caliente  y te  avisa si  se
;; actualiza  la funcion  para que  veas  si te  interesa mantener  el
;; parche o no
(use-package el-patch)
(eval-when-compile
  (require 'el-patch))

(use-package better-defaults)

;; (use-package elpy
;;   :after python
;;   :custom
;;   (elpy-rpc-python-command "python3")
;;   :config
;;   (elpy-enable)
;;   (remove-hook 'elpy-modules  'elpy-module-flymake)
;;   (add-hook 'elpy-mode-hook 'flycheck-mode)
;;   (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

(use-package exwm
  ;; Lo instalamos a nivel de OS
  :ensure nil
  :custom
  ;; some popups disappear if force tiling is nil
  (exwm-manage-force-tiling t)
  :config
  (exwm-input-set-key (kbd "s-<return>") 'eshell)
  (exwm-input-set-key (kbd "C-s-<return>") 'shell)
  (exwm-input-set-key (kbd "s-<f2>")
    (lambda () (interactive)
      (start-process-shell-command "" nil "xset dpms force off; slock")))
  (exwm-input-set-key (kbd "s-f")
    (lambda () (interactive)
      (start-process-shell-command "" nil "firefox")))
  (exwm-input-set-key (kbd "s-F")
    (lambda () (interactive)
      (start-process-shell-command "" nil "firefox --private-window")))
  (exwm-input-set-key (kbd "s-m")
    (lambda () (interactive)
      (start-process-shell-command "" "*Messages*" "~/Downloads/browser/run.sh")))
  (exwm-input-set-key (kbd "s-c")
    (lambda () (interactive)
      (start-process-shell-command "" nil "chromium")))
  (exwm-input-set-key (kbd "s-C")
    (lambda () (interactive)
      (start-process-shell-command "" nil "chromium --incognito")))
  (exwm-input-set-key (kbd "s-+") 'desktop-environment-volume-increment)
  (exwm-input-set-key (kbd "s--") 'desktop-environment-volume-decrement)
  (exwm-input-set-key (kbd "s-.") 'desktop-environment-toggle-mute)
  (exwm-input-set-key (kbd "s-s")
    (lambda () (interactive)
      ;; Mirar de poner un timestamp en el fichero creado para no sobreescribir
      (start-process-shell-command "" nil (concat "maim -s ~/Downloads/" (format-time-string "%d%m%Y_%H%M%S") "_Screenshot.jpg"))))

  ;; Insert code from exwm-config file here because considered obsolete
  (defun exwm-config-example ()
    ;; Set the initial workspace number.
    (unless (get 'exwm-workspace-number 'saved-value)
      (setq exwm-workspace-number 4))
    ;; Make class name the buffer name
    (add-hook 'exwm-update-class-hook
              (lambda ()
                (exwm-workspace-rename-buffer exwm-class-name)))
    ;; Global keybindings.
    (unless (get 'exwm-input-global-keys 'saved-value)
      (setq exwm-input-global-keys
            `(
              ;; 's-r': Reset (to line-mode).
              ([?\s-r] . exwm-reset)
              ;; 's-w': Switch workspace.
              ([?\s-w] . exwm-workspace-switch)
              ;; 's-&': Launch application.
              ([?\s-&] . (lambda (command)
                           (interactive (list (read-shell-command "$ ")))
                           (start-process-shell-command command nil command)))
              ;; 's-N': Switch to certain workspace.
              ,@(mapcar (lambda (i)
                          `(,(kbd (format "s-%d" i)) .
                            (lambda ()
                              (interactive)
                              (exwm-workspace-switch-create ,i))))
                        (number-sequence 0 9)))))
    ;; Line-editing shortcuts
    (unless (get 'exwm-input-simulation-keys 'saved-value)
      (setq exwm-input-simulation-keys
            '(([?\C-b] . [left])
              ([?\C-f] . [right])
              ([?\C-p] . [up])
              ([?\C-n] . [down])
              ([?\C-a] . [home])
              ([?\C-e] . [end])
              ([?\M-v] . [prior])
              ([?\C-v] . [next])
              ([?\C-d] . [delete])
              ([?\C-k] . [S-end delete]))))
    ;; Enable EXWM
    (exwm-enable)
    ;; Configure Ido
    (with-no-warnings (exwm-config-ido))
    )

  (defun exwm-config--fix/ido-buffer-window-other-frame ()
    "Fix `ido-buffer-window-other-frame'."
    (defalias 'exwm-config-ido-buffer-window-other-frame
      (symbol-function 'ido-buffer-window-other-frame))
    (defun ido-buffer-window-other-frame (buffer)
      "This is a version redefined by EXWM.
  You can find the original one at `exwm-config-ido-buffer-window-other-frame'."
      (with-current-buffer (window-buffer (selected-window))
        (if (and (derived-mode-p 'exwm-mode)
                 exwm--floating-frame)
            ;; Switch from a floating frame.
            (with-current-buffer buffer
              (if (and (derived-mode-p 'exwm-mode)
                       exwm--floating-frame
                       (eq exwm--frame exwm-workspace--current))
                  ;; Switch to another floating frame.
                  (frame-root-window exwm--floating-frame)
                ;; Do not switch if the buffer is not on the current workspace.
                (or (get-buffer-window buffer exwm-workspace--current)
                    (selected-window))))
          (with-current-buffer buffer
            (when (derived-mode-p 'exwm-mode)
              (if (eq exwm--frame exwm-workspace--current)
                  (when exwm--floating-frame
                    ;; Switch to a floating frame on the current workspace.
                    (frame-selected-window exwm--floating-frame))
                ;; Do not switch to exwm-mode buffers on other workspace (which
                ;; won't work unless `exwm-layout-show-all-buffers' is set)
                (unless exwm-layout-show-all-buffers
                  (selected-window)))))))))

  (defun exwm-config-ido ()
    "Configure Ido to work with EXWM."
    (declare-function ido-mode "ido")
    (ido-mode 1)
    (add-hook 'exwm-init-hook #'exwm-config--fix/ido-buffer-window-other-frame))

  (exwm-config-example)
  )

(use-package exwm-randr
  :ensure nil
  :custom
  (exwm-randr-workspace-monitor-plist '(3 "VGA1"))
  :config
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output VGA1 --left-of HDMI1 --auto")))
  (exwm-randr-enable))

;; (use-package exwm-systemtray
;;   :custom
;;   (exwm-systemtray-height 16)
;;   :config
;;   (exwm-systemtray-enable))

;; ;; Obsolete
;; (use-package exwm-config
;;   :ensure nil
;;   ;; Because exwm-config-example runs (exwm-enable) (must be enabled at the end)
;;   :after exwm exwm-randr ;; exwm-systemtray
;;   :config
;;   (exwm-config-example))

;; (use-package flycheck
;;   :after elpy)

;; (use-package flycheck-pyflakes
;;   :after flycheck)
;;   ;; :config
;;   ;; (add-hook 'python-mode-hook 'flycheck-mode))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom
  (projectile-completion-system 'ido)
  (projectile-switch-project-action #'projectile-dired)
  ;; Indexing a large project can take a while.
  ;; You can enable caching to prevent additional reindexing
  (projectile-enable-caching t)
  :bind-keymap
  ("s-p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects"))))
  
(use-package flx-ido
  :config
  (flx-ido-mode)
  ;; Para que 'SPC' no autocomplete (usamos 'TAB') y se inserte el caracter
  (define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)
  :init
  (ido-everywhere t)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))


;; (use-package py-autopep8
;;   :after elpy)

;; (use-package slime
;;   :defer t
;;   :custom
;;   (inferior-lisp-program "/usr/local/bin/sbcl")
;;   (slime-contribs '(slime-fancy)))

;; Try packages without installing
(use-package try
  :defer t)

;; (use-package wttrin
;;   :defer t
;;   :custom
;;   (wttrin-default-cities '("Barcelona" "Mataro"))
;;   (wttrin-default-accept-language '("Accept-Language" . "es-ES")))


;; Built-in packages

(use-package emacs
  :init
  (put 'narrow-to-region 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  :bind ("C-z" . nil)
  :config
  (windmove-default-keybindings)
  (display-time-mode t)
  (column-number-mode t)
  ;; Emacs server is not required to run EXWM but it has some interesting uses
  ;; If you start server you can use emacsclient from terminal, git or wherever
  (server-start)
  :custom
  (tooltip-mode nil "Don't displays help when put mouse on")
  (inhibit-startup-screen t "Don't show splash screen")
  (make-backup-files nil "Don't create backup files")
  (blink-cursor-mode nil "Cursor without blink")
  (window-divider-mode t)
  (display-time-format "%d-%m-%Y %H:%M")
  ;; (set-fringe-mode 10)
  (fringe-mode 1)
  (custom-file null-device "Don't store customizations")
  (tab-width 4))

;; (use-package python
;;   :defer t
;;   :custom
;;   (python-shell-interpreter "ipython")
;;   (python-shell-interpreter-args "--simple-prompt -i"))

;; This is similar to what 'linum-mode' provides, but much faster
(use-package display-line-numbers
  :config
  (defcustom display-line-numbers-exempt-modes
    '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode
                 wl-summary-mode compilation-mode org-mode text-mode image-mode
                 doc-view-mode)
    "Major modes on which to disable the linum mode, exempts them from global requirement"
    :group 'display-line-numbers
    :type 'list
    :version "green")
  (defun display-line-numbers--turn-on ()
    "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
    (if (and
         (not (member major-mode display-line-numbers-exempt-modes))
         (not (minibufferp))
         (not (string-match "*" (buffer-name)))
         (not (> (buffer-size) 3000000)))  ;; disable linum on buffer greater than 3MB
        (display-line-numbers-mode)))
  (global-display-line-numbers-mode))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package helpful
  :defer t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; Org Mode Configuration ------------------------------------------------------

(use-package org
  :pin gnu
  ;; needed for org-contacts
  :ensure org-contrib
  :hook (org-mode . (lambda ()
                      (org-indent-mode)
                      (variable-pitch-mode 1)
                      (visual-line-mode 1)))
  :config
  (setq org-ellipsis " ▾")
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))
  ;; See if needed ?
  (require 'org-indent)
  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  ;; Org agenda
  (setq org-agenda-start-with-log-mode t
        org-log-done 'time
        org-log-into-drawer t
        org-agenda-files
	    '("~/Agenda/Tasks.org"
	      "~/Agenda/Habits.org"
          "~/Agenda/Contacts.org"))
  ;; Org habit
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)
  ;; Org TODO states
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))
  ;; Org refiling
  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))
  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  ;; Org tags
  (setq org-tag-alist
        '((:startgroup)
          ;; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)))
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))
          ("W" "Work Tasks" tags-todo "@work")
          ;; Low-effort next actions
          ("e" "EffortLess Tasks" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))
          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))
  ;; Org capture templates
  (setq org-capture-templates
        `(("t" "Tasks / Projects")
          ("tt" "Task" entry (file+olp "~/Agenda/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
          ("j" "Journal Entries")
          ("jj" "Journal" entry
           (file+olp+datetree "~/Agenda/Journal.org")
           "* %<%H:%M> - Journal :journal:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
          ("jm" "Meeting" entry
           (file+olp+datetree "~/Agenda/Journal.org")
           "* %<%H:%M> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
          ("w" "Workflows")
          ("we" "Checking Email" entry (file+olp+datetree "~/Agenda/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
          ("m" "Metrics Capture")
          ("mw" "Weight" table-line (file+headline "~/Agenda/Metrics.org" "Weight")
           "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)
          ("c" "Contacts" entry
           (file+headline "~/Agenda/Contacts.org" "Contacts")
           ,(concat "*  %(org-contacts-template-name)\n"
                    ":PROPERTIES:\n"
                    ":EMAIL: %(org-contacts-template-email)\n"
                    ":PHONE: %^{PHONE}\n"
                    ":NOTE: %^{NOTE}\n"
                    ":BIRTHDAY: %^{yyyy-mm-dd}\n"
                    ":END:")
           :empty-lines 1)))
  ;; Org-babel supported languages for execute
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))
  ;; Not confirm every src execution
  (setq org-confirm-babel-evaluate nil)
  ;; Org-babel add conf-unix for edit and tangle key=value src block
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  ;; This is needed as of Org 9.2
  (require 'org-tempo)
  ;; Add templates for src blocks '<sh + TAB'
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  ;; Define key
  ;; For Journal entry template
  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))
  ;; For org-capture general menu
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)))

(use-package org-contacts
  :pin gnu
  :after org-agenda
  :custom
  (org-contacts-files '("~/Agenda/Contacts.org")))

;; Org-Roam para tener nustro Zettlekasten
(use-package org-roam
  ;; :init
  ;; (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/ZK")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "\n%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
      :unnarrowed t)
     ("l" "programming language" plain
      "\n* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
      :unnarrowed t)
     ;; Si quieres usar fichero org como template
     ;; ("b" "book notes" plain (file "~/template.org")
     ("b" "book notes" plain
      "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
      :unnarrowed t)
     ("p" "project" plain
      "\n* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package visual-fill-column
  :hook (org-mode . (lambda()
                      (setq visual-fill-column-width 100
                            visual-fill-column-center-text t)
                      (visual-fill-column-mode 1))))




;; Execute xmodmap tool for change keymaps
(defun run-xmodmap()
  (call-process "xmodmap" nil 0 nil
                (expand-file-name "~/.Xmodmap")))
(run-xmodmap)

;; ;; Test y si rula, ponerlo en mejor lugar del fichero
;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   ;; Necesario ?¿
;;   :hook (lsp-mode . yas-global-mode)
;;   ;; A falta de company para snippets y para emmet
;;   :bind (("C-ñ" . yas-expand)
;;          ("C-<tab>" . emmet-expand-line))
;;   :config
;;   (lsp-enable-which-key-integration t))

;; Hay que instalar el server: M-x lsp-install-server RET ts-ls RET
;; (use-package typescript-mode
;;   :mode "\\.ts\\'"
;;   :hook (typescript-mode . lsp-deferred)
;;   :config
;;   (setq typescript-indent-level 2))

;; (use-package js
;;   :hook ((js-mode . lsp-deferred)
;;          (js-mode . emmet-mode))
;;   :config
;;   (setq js-indent-level 2))

;; ;; Hay que instalar el server: M-x lsp-install-server RET emmet-ls RET
;; (use-package emmet-mode
;;   :hook ((emmet-mode . lsp-deferred)
;;          ;; Auto-start on any markup modes
;;          ;; ((sgml-mode html-mode css-mode) . emmet-mode))
;;          ((sgml-mode html-mode css-mode) . lsp-deferred))
;;   :config
;;   (setq emmet-indentation 2))

;; ;; Hay que instalar el server: M-x lsp-install-server RET css-ls RET
;; (use-package css-mode
;;   :hook (css-mode . lsp-deferred)
;;   :config
;;   (setq css-indent-offset 2))

;; ;; 1. Start the server with 'httpd-start'
;; ;; 2. Use 'impatient-mode' on any buffer
;; ;; 3. Visit 'http://localhost:8080/imp/' with any browser
;; (use-package impatient-mode
;;   :defer t)

;; (use-package php-mode
;;   :defer t
;;   :config
;;   (add-hook 'php-mode-hook
;;             '(lambda ()
;;                ;; Enable company-mode
;;                (company-mode t)
;;                (set (make-local-variable 'company-backends)
;;                     '((company-ac-php-backend company-dabbrev-code)
;;                       company-capf company-files))
;;                ;; Enable flycheck-mode // instalar interprete php en el sistema
;;                (flycheck-mode t)
;;                ;; Enable yasnippet mode
;;                ;; (yas-reload-all)
;;                (yas-minor-mode t)
;;                ;; Enable ElDoc support (optional)
;;                (ac-php-core-eldoc-setup)
;;                ;; Jump to definition (optional)
;;                (define-key php-mode-map (kbd "M-.")
;;                  'ac-php-find-symbol-at-point)
;;                ;; Return back (optional)
;;                (define-key php-mode-map (kbd "M-,")
;;                  'ac-php-location-stack-back))))

;; ;; (electric-pair)
;; ;; (subword-mode 1)

;; (use-package ac-php
;;   :defer t)

;; (use-package company-php
;;   :defer t)

;; (use-package yasnippet-snippets
;;   :defer t)

;; (use-package js-react-redux-yasnippets
;;   :defer t)

;; para ordenar dired con directorios primero
(setq dired-listing-switches "-lAh --group-directories-first") 

;; Pinentry
;; Se supone que epg es el nuevo pero no rula, rula con epa
;; (require 'epg)
;; (setq epg-pinentry-mode 'loopback)

(use-package pinentry
  :custom
  (epa-pinentry-mode 'loopback)
  :config
  (pinentry-start))

;; Config built-in auth-source package
(use-package auth-source
  :init
  ;; Activa auth-source para que busque en password-store
  (auth-source-pass-enable))

;; Pass (major mode for password-store and password-store-otp)
(use-package pass
  :defer t
  :bind ("C-x w" . pass)
  :custom
  (pass-username-fallback-on-filename t)
  :config/el-patch
  ;; Add my function for sync my password-store backup
  (defun backup-my-pass-before-quit ()
    (let ((on-save-program (concat (getenv "HOME") "/ZK/pass/.on-save"))
          (secret (auth-source-pick-first-password :host "backup.local" :user "passphrase")))
      (if (not secret)
          (message "Error getting password for backup sync!!")
        (when (not (zerop (call-process on-save-program nil nil nil secret)))
          (error (format "Error executing %s" on-save-program))))
      ))

  ;; Patch pass-quit
  (el-patch-defun pass-quit ()
    "Kill the buffer quitting the window."
    (interactive)
    (when (y-or-n-p "Kill all pass entry buffers? ")
      (dolist (buf (buffer-list))
        (with-current-buffer buf
          (when (eq major-mode 'pass-view-mode)
            (kill-buffer buf)))))
    ;; Parche para que si algo va mal con el backup no salir del programa
    (el-patch-swap (quit-window t)
                   (unless (backup-my-pass-before-quit)
                       (quit-window t))))
  )

(use-package password-store-otp
  :defer t
  :custom
  (password-store-otp-screenshots-path "/tmp")
  :config/el-patch
  ;; Parche de la funcion que ejecuta zbarimg
  (el-patch-defun password-store-otp-append-from-image (entry)
    "Check clipboard for an image and scan it to get an OTP URI, append it to ENTRY."
    (interactive (list (password-store-otp-completing-read)))
    (let ((qr-image-filename (password-store-otp--get-qr-image-filename entry))
          (screenshot-executable
           (el-patch-swap (password-store-otp--get-screenshot-executable) "maim")
           ))
      (when (not (zerop (call-process screenshot-executable nil nil nil qr-image-filename)))
        (error "Couldn't get image from clipboard"))
      (with-temp-buffer
        (condition-case nil
            (call-process "zbarimg" nil t nil "-q" "--raw"
                          (el-patch-add "--nodbus")
                          qr-image-filename)
          (error
           (error "It seems you don't have `zbar-tools' installed")))
        (password-store-otp-append
         entry
         (buffer-substring (point-min) (point-max))))
      (when (not password-store-otp-screenshots-path)
        (delete-file qr-image-filename)))))

;; Timer for fun
(use-package tea-time
  :custom
  (tea-time-sound "~/Downloads/llop.mp3")
  (tea-time-sound-command "mpv %s")
  :config/el-patch
  (el-patch-defun tea-time (timeval)
    "Ask how long the tea should draw and start a timer.
Cancel prevoius timer, started by this function"
    (interactive "sHow long (min)? ")
    (if (not (string-match "\\`\\([0-9]+\\)\\'" timeval))
        (tea-show-remaining-time)
      (let* ((minutes ((el-patch-swap string-to-int string-to-number) (substring timeval (match-beginning 1)
					                                                             (match-end 1))))
	         (seconds (* minutes 60)))
        (progn
	      (tea-timer-cancel)
	      (setq tea-active-timer (tea-timer seconds))
	      )))
    )
  )


;; (message (format "Pass: %s" (auth-source-pick-first-password :host "backup.local" :user "passphrase")))

;; Function for sync some folders
(defun folder-action-save-hook ()
  "A file save hook that will look for a script in the same
    directory, called .on-save.  It will then execute that script
    synchronously."
  (when (and (stringp buffer-file-name)
             (or (string-match "/ZK/" buffer-file-name)
                 (string-match "/Agenda/" buffer-file-name)))
    (let* ((filename (buffer-file-name))
           (dir      (locate-dominating-file filename ".on-save"))
           (script   (concat dir ".on-save")))
      (when (file-exists-p script)
        (message "Starting Sync %s..." dir)
        ;; asynchronously can't check if runs ok
        ;; (start-process "" nil script)
        (if (zerop (call-process script))
            (message "Sync %s Finished." dir)
          (message "ERROR Syncing %s" dir))
        ))))

(add-hook 'after-save-hook 'folder-action-save-hook)
