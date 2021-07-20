;; defprompt should generate a yaml file
;; The entire YAML file.

;; args is a lot like haskell args
;; It's a list of the arguments.
;; The last element in the list is the output/return value
(defmacro defprompt (args &rest data)
  ""
  (let* ((task (plist-get data :task))
         (gen (plist-get data :gen))
         (filter (plist-get data :filter))
         (examples (plist-get data :examples)))

    (if (not task)
        (setq task
         (cond
          ((eq 1 (length args))
           (concat "generate " (symbol-name (car args))))
          ((eq 2 (length args))
           (concat "convert "
                   (symbol-name (car args))
                   " to "
                   (symbol-name (cadr args))))
          (t nil))))

    (if (stringp gen)
        (setq gen (eval
                   `(lambda (initial n)
                      (pen-str2list
                       (snc
                        (concat
                         (cmd ,gen initial)
                         "| head -n "
                         (str n))))))))

    (if (stringp filter)
        (setq filter (eval
                      `(lambda (in)
                         (snc ,filter in)))))

    ;; Generate examples if none

    ;; Add outputs to examples if there is a filter
    (loop for ex in examples do
          (cond
           ((and (eq 1 (length ex))
                 filter) body))))

  nil
  ;; (etv (plist-get :external data))
  ;; `(,@data)
  )

;; https://github.com/pemistahl/grex
(defun grex (in)
  (snc "grex" in))

;; A gen function must take an initial value and a number for how many to generate
(defun examplary-edit-generator (initial n)
  (pen-str2list (snc (concat (cmd "examplary-edit-generator" "shane") "| head -n " (str n)))))

;; Convert lines to regex
(defprompt (lines regex)
  :task "Convert lines to regex"
  ;; Generate input with this
  ;; :gen "examplary-edit-generator shane"
  :gen 'examplary-edit-generator
  :filter "grex"
  ;; The third argument (if supplied) should be incorrect output (a counterexample).
  ;; If the 2nd argument is left out, it will be generated by the command specified by :external
  :examples '(("example 1\nexample2")
              ("example 2\nexample3" "^example [23]$")
              ("pi4\npi5" "^pi[45]$" "pi4\npi5"))
  :lm-command "openai-complete.sh")

(provide 'pen-examplary)