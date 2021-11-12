;; When you paste, also change to the correct mode?

;; Only do this if it's in foundation mode?

(defun paste-around-advice (proc &rest args)
  (let* ((text (car kill-ring))
         (res (apply proc args)))

    (if (major-mode-p 'foundation-modee)
        (detect-language-set-mode))
    res))
(advice-add 'paste :around #'cua-paste)
(advice-add 'paste :around #'lispy-yank)

(provide 'pen-edit)