(ignore-errors
  (require 'package)

  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  ;; Enable ssl
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (package-initialize)

  ;; (package-refresh-contents)

  ;; Require dependencies
  (require 'shut-up)
  (require 'org-brain)
  (require 'dash)
  (require 'popup)
  (require 'right-click-context)
  (require 'projectile)
  (require 'transient)
  (require 'iedit)
  (require 'ht)
  (require 'helm)
  (require 'memoize)
  (require 'ivy)
  (require 'pp)
  (require 's)
  (require 'f)
  ;; builtin
  ;; (require 'cl-macs)
  (require 'company)
  (require 'selected)
  (require 'yasnippet)
  (require 'pcsv)
  (require 'sx)
  (require 'pcre2el)

  (let ((openaidir (concat (getenv "EMACSD") "/openai-api.el"))
        (pendir (concat (getenv "EMACSD") "/pen.el"))
        (contribdir (concat (getenv "EMACSD") "/pen-contrib.el")))
    (add-to-list 'load-path (concat openaidir "/src"))
    (load (concat openaidir "/openai-api.el"))
    (add-to-list 'load-path (concat pendir "/src"))
    (load (concat pendir "/src/pen.el"))
    (add-to-list 'load-path (concat pendir "/src/in-development"))
    (add-to-list 'load-path (concat contribdir "/src"))
    (load (concat contribdir "/src/init-setup.el"))
    (load (concat contribdir "/src/pen-contrib.el"))

    (load (concat pendir "/src/pen-example-config.el"))))