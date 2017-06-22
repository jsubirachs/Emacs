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
    material-theme
    py-autopep8))
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
;; ######################################
;; PYTHON CONFIGURATION
(elpy-enable)
(elpy-use-ipython)
;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;; ######################################
;; OTHER STUFF
;; enable better-defaults
(require 'better-defaults)
;; move between windows with S-(arrow keys)
(windmove-default-keybindings)
;; .emacs ends here
;; --------------------------------------
;; --------------------------------------
;; --------------------------------------
;; CUSTOM OPTIONS
(custom-set-variables
 '(elpy-rpc-python-command "python2")
 '(package-selected-packages
   (quote
    (better-defaults py-autopep8 material-theme flycheck elpy jedi magit)))
 '(python-shell-interpreter "python2")
 '(tab-width 4))
(custom-set-faces
 )
