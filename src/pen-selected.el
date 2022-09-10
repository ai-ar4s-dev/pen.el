(defun pen-turn-on-selected-minor-mode ()
  (interactive)

  (selected-minor-mode -1)
  (selected-region-active-mode -1)
  (selected-minor-mode 1))

(define-globalized-minor-mode
  global-selected-minor-mode selected-minor-mode pen-turn-on-selected-minor-mode)
(global-selected-minor-mode t)

(defun filter-region-through-external-script ()
  "docstring"
  (interactive)
  (if (region-active-p)
      (let ((script
             (read-string "!")))
        (pen-region-pipe script))))

(defun selected-backspace-delete-and-deselect ()
  (interactive)
  (ekm "")
  (deactivate-mark))

(defun open-region-untitled ()
  (interactive)
  (new-buffer-from-string
   (pen-selected-text))
  (save-temp-if-no-file)
  (deactivate-mark))

(defun pen-selected-kill-rectangle ()
  (interactive)
  ;; (call-interactively 'kill-rectangle)
  (if (bound-and-true-p lispy-mode)
      (let ((selected-minor-mode nil)
            (selected-region-active-mode nil))
        (ekm "D"))
    (call-interactively 'kill-rectangle)))

(defun goto-thing-at-point ()
  (interactive)
  (j (intern (pen-thing-at-point))))

(require 'mc-edit-lines)

(defun selected-keyboard-quit ()
  "keyboard-quit and turn off selected mode"
  (interactive)
  (ignore-errors
    (selected-off))
  (deactivate-mark))

(defun get-vimlinks-url ()
  (interactive)
  (if mark-active
      (pen-copy (se show (concat "vim +/\"" (escape "\`\"$*[]" (pen-selected-text)) "\" " (pen-q (bp github-url-to-raw (get-current-url))))))
        (pen-copy cmd)
        (message "%s" cmd)))

(defun vim-escape (s)
  "Escape a string for a vim pattern"
  (concat "\"" (escape "`/\"$*[]\\" (escape "\\" s)) "\""))

(defun open-selection-sps ()
  (interactive)

  (if mark-active
      (let ((sel (pen-umn (pen-selected-text))))
        (pen-edit-fp-on-path sel))))

(defun sel-flush-left-p ()
  (let ((bol (point-at-bol))
        (p (point))
        (m (mark)))
    (and mark-active
         (or (eq bol p)
             (eq bol m)))))

(defun get-vim-link (&optional editor)
  (interactive)
  (if (not editor)
      (setq editor "v"))
  (defvar uri)
  (defvar vimcmd)
  (setq uri (pen-mnm (get-path t)))

  (setq vimcmd
        (cond ((derived-mode-p 'eww-mode) "ewwlinks")
              ((derived-mode-p 'Info-mode) "emacshelp")
              (t editor)))

  (if mark-active
      (let* ((pat (pen-bp head -n 1 (pen-selected-text)))
             (vimpat
              (if (sel-flush-left-p)
                  (vim-escape (concat "^" pat))
                (vim-escape pat)))
             (link-cmd (concat vimcmd " +/" vimpat " " (pen-q uri))))
        (xc link-cmd)
        (message "%s" link-cmd)
        (deactivate-mark))))

(defun get-emacs-link (&optional editor)
  (interactive)

  (if (and
       (derived-mode-p 'eww-mode)
       (>= (prefix-numeric-value current-prefix-arg) 4)
       mark-active)
      (xc (concat (get-path) "#:~:text=" (urlencode (e/chomp-all (pen-selected-text)))))

      (progn
        (if (not editor)
            (setq editor "sp"))
        (get-vim-link editor))))

(defun forget-region ()
  (interactive)
  (set-marker m1 nil)
  (set-marker m2 nil))

(defun selected--on ()
  (if (not (or (bound-and-true-p lispy-mode)
               (pen-evil-enabled)))
      (selected-region-active-mode 1)))

;; (define-key selected-keymap (kbd "M-3") #'pen-grep-for-thing-select)

(provide 'pen-selected)
