(require 'package)

(prefer-coding-system 'utf-8)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Enable ssl
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

(package-refresh-contents)

;; Install dependencies
(package-install 'shut-up)
;; For org-roam
(package-install 'emacsql)
(package-install 'guess-language)
(package-install 'language-detection)
(package-install 'org-roam)
(package-install 'org-brain)
(package-install 'dash)
(package-install 'eterm-256color)
;; (package-install 'flyspell)
(package-install 'evil)
(package-install 'popup)
(package-install 'right-click-context)
(package-install 'projectile)
(package-install 'transient)
(package-install 'el-patch)
(package-install 'lsp-mode)
(package-install 'lsp-ui)
(package-install 'iedit)
(package-install 'ht)
(package-install 'sx)
(package-install 'helm)
(package-install 'memoize)
(package-install 'ivy)
(package-install 'counsel)
(package-install 'yaml-mode)
(package-install 'pp)
(package-install 'yaml)
(package-install 'which-key)
(package-install 'lispy)
(package-install 's)
(package-install 'f)
;; builtin
;; (package-install 'cl-macs)
(package-install 'company)
(package-install 'selected)
(package-install 'yasnippet)
(package-install 'pcsv)
(package-install 'sx)
(package-install 'pcre2el)
(package-install 'helpful)

;; Require dependencies
(require 'shut-up)
;; For org-roam
(require 'emacsql)
(require 'guess-language)
(require 'language-detection)
(require 'org-roam)
(require 'org-brain)
(require 'dash)
(require 'eterm-256color)
;; (require 'flyspell)
(require 'evil)
(require 'popup)
(require 'right-click-context)
(require 'projectile)
(require 'transient)
(require 'el-patch)
(require 'lsp-mode)
(require 'lsp-ui)
(require 'iedit)
(require 'ht)
(require 'helm)
(require 'memoize)
(require 'ivy)
(require 'counsel)
(require 'yaml-mode)
(require 'pp)
(require 'yaml)
(require 'which-key)
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
(require 'cua-base)
(require 'helpful)

(let ((openaidir (f-join user-emacs-directory "openai-api.el"))
      (openaihostdir (f-join user-emacs-directory "host/openai-api.el"))
      (pendir (f-join user-emacs-directory "pen.el"))
      (penhostdir (f-join user-emacs-directory "host/pen.el"))
      (contribdir (f-join user-emacs-directory "pen-contrib.el"))
      (contribhostdir (f-join user-emacs-directory "host/pen-contrib.el")))

  (if (f-directory-p (f-join openaihostdir "src"))
      (setq openaidir openaihostdir))
  (add-to-list 'load-path openaidir)
  (require 'openai-api)

  (if (f-directory-p (f-join penhostdir "src"))
      (setq pendir penhostdir))
  (add-to-list 'load-path (f-join pendir "src"))
  (require 'pen)

  (add-to-list 'load-path (f-join pendir "src/in-development"))
  (add-to-list 'load-path (f-join contribdir "src"))

  (load (f-join contribdir "src/init-setup.el"))
  (load (f-join contribdir "src/pen-contrib.el"))

  (load (f-join pendir "src/pen-example-config.el")))
