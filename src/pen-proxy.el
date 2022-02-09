(defcustom pen-proxy ""
  "Example: localhost:9837"
  :type 'string
  :group 'pen
  :options (list "localhost:9837")
  :set (lambda (_sym value)
         (set _sym value))
  :get (lambda (_sym)
         (eval (sor _sym nil)))
  :initialize #'custom-initialize-default)

(defun pen-proxy-set-localhost ()
  "This is for debugging the proxy"
  (interactive)
  (setq pen-proxy (concat "localhost:" (pen-get-khala-port))))

;; (defset pen-proxy nil)

;; Proxy is a host and a port
;; (defset pen-proxy "localhost:9707")

(provide 'pen-proxy)