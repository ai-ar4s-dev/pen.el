(require 'pcase)

(defalias 're-match-p 'string-match)
(defalias 'pen-empty-string-p 's-blank?)
(defalias 'tv 'pen-tv)
(defalias 'etv 'pen-etv)
(defalias 'f-basename 'f-filename)
(defalias 'region2string 'buffer-substring)
(defalias 'let-values 'pcase-let)
(defalias 'string-or 'str-or)
(defalias 'get-top-level 'projectile-project-root)
(defalias 'current-buffer-name 'buffer-name)
(defalias 'locate-binary 'executable-find)
(defalias 'deselect 'deactivate-mark)
(defalias 'sleep 'sleep-for)
(defalias 'tryonce 'tryelse)
(defalias 'goto-byte 'pen-goto-byte)
(defalias 'function-p 'fboundp)
(defalias 'pen-haskell-fill-hole 'pen-haskell-hoogle-type)

(provide 'pen-aliases)
