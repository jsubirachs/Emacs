;; init.el --- Emacs configuration

(require 'package)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")
                          ("melpa-stable" . "https://stable.melpa.org/packages/")
                          ("marmalade" . "https://marmalade-repo.org/packages/")))
(customize-set-variable 'package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)

;; To see statistics run M-x use-package-report
(setq use-package-compute-statistics t)

(use-package system-packages
  :ensure t
  :custom
  (system-packages-noconfirm t))
             
;; keep your packages updated automatically
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package use-package-ensure-system-package
  :ensure t)

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

(use-package better-defaults
  :ensure t)

(use-package elpy
  :ensure t
  :after python
  :custom
  (elpy-rpc-python-command "python")
  :config
  (elpy-enable)
  (remove-hook 'elpy-modules  'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

(use-package exwm
  :ensure t
  :custom
  ;; some popups disappear if force tiling is nil
  (exwm-manage-force-tiling t)
  :config
  (exwm-input-set-key (kbd "s-<return>") 'shell)
  (exwm-input-set-key (kbd "s-<f2>")
    (lambda () (interactive)
      (start-process-shell-command "" nil "xset dpms force off; slock")))
  (exwm-input-set-key (kbd "s-f")
    (lambda () (interactive)
      (start-process-shell-command "" nil "firefox")))
  (exwm-input-set-key (kbd "s-F")
    (lambda () (interactive)
      (start-process-shell-command "" nil "firefox --private-window"))))

(use-package exwm-randr
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

(use-package exwm-config
  ;; Because exwm-config-example runs (exwm-enable) (must be enabled at the end)
  :after exwm exwm-randr ;; exwm-systemtray
  :config
  (exwm-config-example))

(use-package flycheck
  :ensure t
  :after elpy)

(use-package flycheck-pyflakes
  :ensure t
  :after flycheck)
  ;; :config
  ;; (add-hook 'python-mode-hook 'flycheck-mode))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind
  (:map projectile-mode-map ("s-p" . projectile-command-map))
  :custom
  ;; Indexing a large project can take a while.
  ;; You can enable caching to prevent additional reindexing
  (projectile-enable-caching t))

(use-package py-autopep8
  :ensure t
  :after elpy)

(use-package slime
  :ensure t
  :defer t
  :custom
  (inferior-lisp-program "/usr/local/bin/sbcl")
  (slime-contribs '(slime-fancy)))

;; Try packages without installing
(use-package try
  :ensure t
  :defer t)

(use-package wttrin
  :ensure t
  :defer t
  :custom
  (wttrin-default-cities '("Barcelona" "Mataro"))
  (wttrin-default-accept-language '("Accept-Language" . "es-ES")))


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
  ;; Emacs server is not required to run EXWM but it has some interesting uses
  ;; If you start server you can use emacsclient from terminal, git or wherever
  (server-start)
  :custom
  (inhibit-startup-screen t "Don't show splash screen")
  (make-backup-files nil "Don't create backup files")
  (blink-cursor-mode nil "Cursor without blink")
  (window-divider-mode t)
  (display-time-format "%d-%m-%Y %H:%M")
  ;; Margen en la izquierda de 5 pixels
  ;; (fringe-mode 5)
  (custom-file null-device "Don't store customizations")
  (tab-width 4))

(use-package python
  :defer t
  :custom
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "--simple-prompt -i"))

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

;; (use-package cus-edit
;;   :custom
;;   (custom-file null-device "Don't store customizations"))

;; Execute xmodmap tool for change keymaps
(defun run-xmodmap()
  (call-process "xmodmap" nil 0 nil
                (expand-file-name "~/.Xmodmap")))
(run-xmodmap)
