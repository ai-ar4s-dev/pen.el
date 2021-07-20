;; Perspective:
;; Create the language according to speculation and future need.
;; Combine with APIs and LMs according to what they need.

;; TODO It's important to implement single example prompts
;; I can then search for a multi-example prompt

;; TODO examples
;; TODO counterexamples
;; TODO tasks

;; The initial characters of the prompt have more weight than the latter.
;; A 'metaprompt' may be designed which is the initial part of the prompt.
;; It's not a great name as there is no strict part which could be considered.
;; And a metaprompt may be further divided ad infinitum.

;; (defmacro defprompt (inputtype outputtype &rest data)
;;   ""
;;   `(,@data))

(defmacro defprompt (inputtype outputtype &rest data)
  ""
  (let ((external (plist-get data :external))
        (task (plist-get data :task))
        (examples (plist-get data :examples)))
    (loop for ex in examples do
          (cond
           ((eq 1 (length ex)) body)))
    )

  nil
  ;; (etv (plist-get :external data))
  ;; `(,@data)
  )

;; TODO Start with an input/output prompt

;; https://github.com/pemistahl/grex
(defun grex (in)
  (snc "grex" in))

(defun examplary-edit-generator (initial n)
  (pen-str2list (snc (concat (cmd "examplary-edit-generator" "shane") "| head -n " (str n)))))

;; Convert lines to regex
(defprompt lines regex
  ;; Generate input with this
  :sh-gen "examplary-edit-generator shane"
  :gen 'examplary-edit-generator
  ;; An external command to filter input examples and generate output examples
  :sh-filter "grex"
  ;; An emacs function that filters
  ;; :filter 'grex
  ;; The task may also be used as a metaprompt.
  :task "Convert lines to regex"
  ;; The third argument (if supplied) should be incorrect output (a counterexample).
  ;; If the 2nd argument is left out, it will be generated by the command specified by :external
  :examples '(("example 1\nexample2")
              ("example 2\nexample3" "^example [23]$")
              ("pi4\npi5" "^pi[45]$" "pi4\npi5")))

;; (etv (plist-get (expand-macro '(defprompt lines regex
;;                                  :external "grex"
;;                                  ;; The task may also be used as a metaprompt.
;;                                  :task "Convert lines to regex"
;;                                  :examples '(("example 1\nexample2" "^example [12]$")
;;                                              ("example 2\nexample3" "^example [23]$")
;;                                              ("pi4\npi5" "^pi[45]$"))
;;                                  :counterexamples '())) :external))

;; Only use as many examples as required by the model

(defmodel gpt3
  :n-examples 3)

(provide 'pen-examplary)