;; .emacs --- Emacs configuration
;; INSTALL PACKAGES
(require 'package)
(setq package-archives
       '(("gnu" . "https://elpa.gnu.org/packages/")
         ("melpa" . "https://melpa.org/packages/")
         ("melpa-stable" . "https://stable.melpa.org/packages/")
         ("marmalade" . "https://marmalade-repo.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
;; pip install flake8 jedi autopep8
;; pip install ipython
(defvar myPackages
  '(better-defaults
    magit
    ;; ein ;; add the ein package (Emacs ipython notebook)
    elpy
    flycheck
    py-autopep8
    material-theme
    exwm
    projectile
    slime
    wttrin))
;; install every package of variable 'myPackages'
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)
;; BASIC CUSTOMIZATION
(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(setq make-backup-files nil) ;; don't create backup files
(setq blink-cursor-mode nil) ;; cursor without blink
;; ######################################
;; MAGIT CONFIGURATION
(global-set-key (kbd "C-x g") 'magit-status)
;; --------------------------------------
;; ######################################
;; WTTRIN CONFIGURATION (weather application)
(setq wttrin-default-cities '("Barcelona" "Mataro"))
(setq wttrin-default-accept-language '("Accept-Language" . "es-ES"))
;; --------------------------------------
;; ######################################
;; PROJECTILE CONFIGURATION
; (add-to-list 'load-path "/path/to/projectile/directory")
(require 'projectile)
 ;; to enable in all buffers
(projectile-global-mode)
;; Indexing a large project can take a while.
;; You can enable caching to prevent additional reindexing
(setq projectile-enable-caching t)
;; --------------------------------------
;; ######################################
;; PYTHON CONFIGURATION
(elpy-enable)
;;(elpy-use-ipython)
;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;; --------------------------------------
;; ######################################
;; OTHER STUFF
;; enable better-defaults
(require 'better-defaults)
;; move between windows with S-(arrow keys)
(windmove-default-keybindings)
;; windows separator
(window-divider-mode t)
;; .emacs ends here
;; --------------------------------------
;; --------------------------------------
;; --------------------------------------
;; CUSTOM OPTIONS
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-rpc-python-command "python")
 '(package-selected-packages
   (quote
    (ghub slime wttrin projectile exwm better-defaults py-autopep8 material-theme flycheck elpy jedi magit)))
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "--simple-prompt -i")
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; ######################################
;; EXWM CONFIGURATION
;; No se si funciona el fringe
(fringe-mode 1)
;; Emacs server is not required to run EXWM but it has some interesting uses
(server-start)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
;; + 'slock' is a simple X display locker provided by suckless tools.
(exwm-input-set-key (kbd "s-<f2>")
                    (lambda () (interactive) (start-process "" nil "slock")))
;; Emacs to show you the time (format-time-string describe formats)
(setq display-time-format "%d-%m-%Y %H:%M")
(display-time-mode 1)
;; Execute Emacs "shell"
(exwm-input-set-key (kbd "s-<return>") 'shell)
;; RandR configuration
(require 'exwm-randr)
(setq exwm-randr-workspace-output-plist '(3 "VGA1"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output VGA1 --left-of HDMI1 --auto")))
(exwm-randr-enable)
;; System tray (tengo que estudiar como funciona, a secas no aparece nada)
;(require 'exwm-systemtray)
;(exwm-systemtray-enable)
;; some popups disappear if force tiling is nil
(setq exwm-manage-force-tiling t)
;; --------------------------------------
;; ######################################
;; ACTIVATE SLIM AND STEEL BANK COMMON LISP compilator
;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))
