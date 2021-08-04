;; emacs/share/emacs/28.0.50/lisp/subr.el.gz

;; This is probably from emacs 28
(defun string-replace (fromstring tostring instring)
  "Replace FROMSTRING with TOSTRING in INSTRING each time it occurs."
  (declare (pure t))
  (when (equal fromstring "")
    (signal 'wrong-length-argument fromstring))
  (let ((start 0)
        (result nil)
        pos)
    (while (setq pos (string-search fromstring instring start))
      (unless (= start pos)
        (push (substring instring start pos) result))
      (push tostring result)
      (setq start (+ pos (length fromstring))))
    (if (null result)
        ;; No replacements were done, so just return the original string.
        instring
      ;; Get any remaining bit.
      (unless (= start (length instring))
        (push (substring instring start) result))
      (apply #'concat (nreverse result)))))

;; Also, mouse configs dont work with emacs 27
;; http://github.com/semiosis/pen.el/blob/master/src/pen-mouse.el

(defun string-search (needle haystack &optional start-pos)
  (setq start-pos (or start-pos 0))
  (let ((results (s-matched-positions-all needle haystack)))
    (cl-loop for tp in results
             if (>= (car tp) start-pos)
             return (car tp))))

(defun string-search-beta (needle haystack &optional start-pos)
  (setq start-pos (or start-pos 0))
  (let ((results (s-matched-positions-all needle haystack)))
    (cl-loop for tp in results
             if (>= (car tp) start-pos)
             return (car tp))))

(defun string-search-test ()
  (interactive)
  ;; (etv (string-search-beta "shane" "is shane cool"))
  (etv (string-search-beta "shane" "is shane cool" 3)))

(defun string-search-test ()
  (interactive)
  ;; (etv (string-search-beta "shane" "is shane cool"))
  (etv (string-search "shane" "is shane cool" 3)))