;; I suppose that `chann`, being the mantissa of chann.el is the unique name-or-names identifying Chann.el

(require 'async)

(defun channel-chatbot-from-name (name-or-names command &optional auto closeframe)
  "`name-or-names` is the name-or-names of the personalit(y|ies).
`command` is the terminal command the personality commands.
`auto`, if set to `t` will come up with the personality blurb without human interaction."
  (interactive (list (read-string-hist "personalit(y|ies): "
                                       "The March Hare, the Hatter and the Dormouse"
                                       nil
                                       "The March Hare, the Hatter and the Dormouse")
                     (fz '("madteaparty"
                           "bash"))))

  (if (and (not (pen-inside-docker))
           (not (pen-container-running)))
      (progn
        (pen-term-nsfa (pen-cmd "pen" "-n"))
        (message "Starting Pen server")))

  (if (not (sor name-or-names))
      (setq name-or-names "The March Hare, the Hatter and the Dormouse"))

  (if (not (sor command))
      (setq command (pen-cmd "madteaparty" name-or-names)))

  (let* ((blurb
          (if auto
              (car (pen-one (pf-generate-wiki-blurb-for-a-famous-person/1 name-or-names :no-select-result t)))
            (progn
              ;; Select from possible blurbs, then do a final human edit with a different emacs daemon
              (message "Final human edit of blurb")
              (pen-eipec
               (fz (pf-generate-wiki-blurb-for-a-famous-person/1 name-or-names :no-select-result nil)
                   nil nil "Select blurb:")))))
         (slug (slugify command nil 30))
         (bufname (concat "chann-" slug))
         ;; modename should give me
         ;; - a channel-term-mode,
         ;; - channel-term-mode-map, and
         ;; - channel-term-mode-hook
         (modename bufname)
         (buf
          ;; Do I want to run in a term? Or would I rather run this in a tmux split pane
          ;; I probably want to do both.
          (pen-term (pen-nsfa command) closeframe modename bufname t)))

    ;; If I want to spawn channel without an emacs term, then do it the following way.
    ;; Start a cterm with the channeled chatbot running as a program loop inside of that buffer
    ;; (let* ((el (pen-snc (pen-cmd "channel-repl" "-getcomintcmd" name-or-names "" blurb))))
    ;;   (pen-e-sps (pen-lm (pen-eval-string el))))
    ))

(defun channel-get-room ()
  (let* ((screen (buffer-string-visible)
                 ;; (pen-selected-or-preceding-context)
                 )
         (room (car (scrape-list "\\[#[a-z_-]+\\]" screen))))
    room))

(defun channel-get-your-name ()
  (let* ((screen (buffer-string-visible)
                 ;; (pen-selected-or-preceding-context)
                 )
         (yourname (car (scrape-list "\\[.*(\\+i)\\]" screen)))
         (yourname (s-replace-regexp "\\[\\(.*\\)(\\+i)\\]" "\\1" yourname))
         (yourname (pen-snc "tr -d '[<>@ ]'" yourname)))
    yourname))

(defun channel-get-users ()
  (let* ((screen (buffer-string-visible))
         (conversation (pen-snc "sed \"/^[0-9]/s/^/\\n/g\" | sed -z \"s/\\n    \\+/ /g\" | sed '/^[^0-9]/d'" screen))
         (users-joined (pen-str2lines (pen-snc "sed -n '/-!-.*has joined/p' | cut -d ' ' -f 3 | tr -d '[[]@]'" (buffer-string-visible))))
         (users (s-split " " (pen-snc "sed -n '/Users/{n;n;p}' | grep '\\[' | sed 's/[^ ]* //' | tr -d '[[]@]' | sed 's/  / /g'" conversation)))
         (users-from-conversation (pen-str2lines (pen-snc "tr -d '[<>@ ]'" (scrape "<[ @][^>]*>" conversation))))
         ;; (yo (pen-tv (pps (-uniq (-sort #'string-lessp users-from-conversation)))))
         (total-users (s-join ", " (-filter-not-empty-string
                                    (-uniq (-sort #'string-lessp (append
                                                                    users-joined
                                                                    users
                                                                    users-from-conversation))))))
         (total-users (or (sor total-users) "all of them")))
    total-users))

;; For the moment I should preprocess IRC content to make it better
;; sed "/^[0-9]/s/^/\n/g" | sed -z "s/\n \+/ /g" | sed '/^[^0-9]/d'
(defun channel-get-conversation ()
  (let* ((screen (buffer-string-visible)
                 ;; (pen-selected-or-preceding-context)
                 )
         (conversation (pen-snc "sed \"/^[0-9]/s/^/\\n/g\" | sed -z \"s/\\n    \\+/ /g\" | sed '/^[^0-9]/d'" screen))
         (conversation (pen-snc "grep -v -- \"\\[\"" conversation))
         (conversation (pen-snc "grep -vP -- \"^$\"" conversation))
         (conversation (pen-snc "grep -v -- \"-\\!-\"" conversation))
         (conversation (pen-snc "sed 's/^<[@ ]\\(.*\\)>/\\1:/'" conversation))
         (conversation (pen-snc "sed 's/^[0-9].*<[@ ]//' | sed 's/> /: /'" conversation)))
    conversation))

(defun async-pf (prompt-function &rest args)
  (async-start-process
   "pen-async-pf"
   (eval `(pen-nsfa (pen-cmd "pen-run-and-write" tf "unbuffer" "pen" "--pool" (str prompt-function) ,@args)))
   (eval
    `(lambda (proc)
       (with-current-buffer ,(current-buffer)
         (pen-insert (chomp (cat ,tf)))
         (if ,auto
             (pen-insert "\n"))
         (f-delete ,tf))))))

(defun channel-say-something (&optional auto)
  (interactive)
  (ignore-errors
    (let* ((room (channel-get-room))
           (yourname (channel-get-your-name))
           (conversation (channel-get-conversation))
           (users (channel-get-users))
           (tf (make-temp-file "channel-"))
           (dialog
            (async-start-process
             "channel-speak"
             (pen-nsfa (pen-cmd "pen-run-and-write" tf "unbuffer" "pen" "--pool" "pf-say-something-on-irc/4" room users conversation yourname))
             (eval
              `(lambda (proc)
                 (with-current-buffer ,(current-buffer)
                   (pen-insert (chomp (cat ,tf)))
                   (if ,auto
                       (pen-insert "\n"))
                   (f-delete ,tf))))))))))

(defun channel (personality)
  (interactive (list
                (fz (pen-list-fictional-characters channel-get-users)
                    nil nil "Person: ")
                ;; (read-string-hist "person: ")
                ))

  ;; TODO
  ;; - Initiate a Mad-TeaParty client
  ;; - Run a loop which gets the chatbot to speak
  )


;; TODO I have to make this even work
;; TODO I have to make this asynchronous with emacs async - This is a must
;; and also make use of the daemons.
;; TODO I have to make this bound to a certain buffer
;; I must ensure that for emacs daemons, they use their own stdout return file
(defun channel-loop-chat ()
  (interactive)
  (let ((b (current-buffer)))
    (run-with-timer 2 6
                    (eval
                     `(lambda ()
                        (with-current-buffer ,b
                          ;; (pen-insert "hello")
                          (channel-say-something t)))))))

(provide 'pen-channel)