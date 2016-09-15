(defmacro m-cycle-values (var values)
  `(let ((i 0) (j t))
     (while (and (< i (length ,values)) j)
       (when (equal ,var (elt ,values i)) (setq j nil))
       (setq i (1+ i)))
     (setq ,var (if (= i (length ,values)) (car ,values) (elt ,values i)))))

(defmacro m-map-key (obj key)
  `(if (symbolp ,obj)
       (let ((map-key (kbd (concat "M-g " (cadr ',key)))))
	 (global-set-key map-key ,obj)
	 (define-key key-translation-map ,key map-key))
     (define-key key-translation-map ,key ,obj)))

(defun f-backward-kill-line ()
  (interactive)
  (kill-region (line-beginning-position) (point))
  (indent-for-tab-command))

(defun f-copy-buffer ()
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (unless (or (eobp) buffer-read-only) (newline 1)))
  (delete-trailing-whitespace)
  (kill-ring-save (point-min) (point-max))
  (message "(f-copy-buffer)"))

(defun f-cua-sequence-rectangle (first incr fmt)
  (interactive
   (let ((seq (split-string
	       (read-string (concat "1 (+1) ("
				    (substring cua--rectangle-seq-format 1)
				    "): ") nil nil))))
     (list (string-to-number (or (car seq) "1"))
    	   (string-to-number (or (cadr seq) "1"))
	   (concat "%" (cadr (cdr seq))))))
  (if (string= fmt "%") (setq fmt cua--rectangle-seq-format)
    (setq cua--rectangle-seq-format fmt))
  (cua--rectangle-operation 'clear nil t 1 nil
			    (lambda (s e _l _r)
			      (delete-region s e)
			      (insert (format fmt first))
			      (setq first (+ first incr)))))

(defun f-cycle-paren-shapes ()
  (interactive)
  (save-excursion
    (unless (looking-at-p (rx (any "([")))
      (backward-up-list))
    (let ((pt (point))
	  (new (cond ((looking-at-p (rx "(")) (cons "[" "]"))
		     ((looking-at-p (rx "[")) (cons "(" ")"))
		     (t (beep) nil))))
      (when new
	(forward-sexp)
	(delete-char -1)
	(insert (cdr new))
	(goto-char pt)
	(delete-char 1)
	(insert (car new))))))

(defun f-cycle-search-whitespace-regexp ()
  (interactive)
  (m-cycle-values search-whitespace-regexp '("\\s-+" ".*?"))
  (message "search-whitespace-regexp: \"%s\"" search-whitespace-regexp))

(defun f-dired ()
  (interactive)
  (switch-to-buffer (dired-noselect default-directory))
  (revert-buffer))

(defun f-incf (&optional first incr repeat)
  (let ((index (floor (/ (cl-incf count 0) (or repeat 1)))))
    (+ (or first 1) (* (or incr 1) index))))
(defun f-each (ls &optional repeat)
  (let ((index (floor (/ (cl-incf count 0) (or repeat 1)))))
    (if (< index (length ls)) (elt ls index)
      (keyboard-quit))))

(defun f-indent-paragraph ()
  (interactive)
  (save-excursion
    (mark-paragraph)
    (indent-region (region-beginning) (region-end))))

(defun f-kill-region ()
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-whole-line 1)
    (back-to-indentation)))

(defun f-kill-ring-save ()
  (interactive)
  (if (use-region-p)
      (kill-ring-save (region-beginning) (region-end))
    (save-excursion
      (back-to-indentation)
      (skip-chars-forward v-skip-chars)
      (kill-ring-save (point) (line-end-position)))
    (unless (minibufferp) (message "(f-kill-ring-save)"))))

(defun f-kmacro-end-or-call-macro (arg)
  (interactive "P")
  (cond ((minibufferp)
	 (if (eq last-command 'f-kmacro-apply-macro) (insert "'()")
	   (insert "\\,(f-each )"))
	 (left-char 1))
	(defining-kbd-macro (kmacro-end-macro arg))
	((use-region-p)
	 (apply-macro-to-region-lines (region-beginning) (region-end)))
	(t (kmacro-call-macro arg t))))

(defun f-kmacro-start-macro (arg)
  (interactive "P")
  (cond ((minibufferp)
	 (insert "\\,(f-incf)")
	 (left-char 1))
	(t (setq defining-kbd-macro nil)
	   (kmacro-start-macro arg))))

(defun f-kmacro-view-or-delete-macro ()
  (interactive)
  (cond ((or (eq last-command 'kmacro-cycle-ring-previous)
	     (eq last-command 'kmacro-cycle-ring-next))
	 (kmacro-delete-ring-head))
	((eq last-command 'kmacro-view-macro) (keyboard-quit))
	(t (kmacro-view-macro))))

(defun f-paragraph-set ()
  (interactive)
  (setq paragraph-start "\f\\|[ \t]*$"
	paragraph-separate "[ \t\f]*$")
  (message "(f-paragraph-set)"))

(defun f-revert-buffer ()
  (interactive)
  (if (minibufferp) (kill-whole-line)
    (when (buffer-modified-p) (revert-buffer t t))))

(defun f-set-or-exchange-mark (arg)
  (interactive "P")
  (if (use-region-p)
      (exchange-point-and-mark)
    (set-mark-command arg)))

(defun f-sort-lines ()
  (interactive)
  (when (use-region-p)
    (sort-lines nil (region-beginning) (region-end))))

(defun f-sort-paragraphs ()
  (interactive)
  (sort-paragraphs nil (point-min) (point-max))
  (message "(f-sort-paragraphs)"))

(defun f-switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun f-toggle-comment (beg end)
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2))))
  (comment-or-uncomment-region beg end))

(defun f-transpose-lines-down ()
  (interactive)
  (move-end-of-line 1)
  (unless (eobp)
    (next-line 1)
    (unless (eobp)
      (transpose-lines 1)
      (previous-line 1)
      (move-end-of-line 1))))

(defun f-transpose-lines-up ()
  (interactive)
  (move-beginning-of-line 1)
  (unless (or (bobp) (eobp))
    (next-line 1)
    (transpose-lines -1)
    (previous-line 2))
  (back-to-indentation))

(defun f-transpose-paragraphs-down ()
  (interactive)
  (backward-paragraph)
  (forward-paragraph)
  (unless (eobp) (transpose-paragraphs 1)))

(defun f-transpose-paragraphs-up ()
  (interactive)
  (backward-paragraph)
  (forward-paragraph)
  (unless (bobp)
    (transpose-paragraphs -1)
    (backward-paragraph)))

(defun f-word-capitalize ()
  (interactive)
  (capitalize-word -1))

(defun f-word-downcase ()
  (interactive)
  (downcase-word -1))

(defun f-word-upcase ()
  (interactive)
  (upcase-word -1))

(defvar v-frame 100)
(defun f-toggle-v-frame ()
  (interactive)
  (m-cycle-values v-frame '(100 70))
  (set-frame-parameter (selected-frame) 'alpha v-frame))

(defvar v-page 10)
(make-variable-buffer-local 'v-page)
(defun f-toggle-v-page ()
  (interactive)
  (m-cycle-values v-page '(10 20 50))
  (message "v-page: %s" v-page))
(defun f-page-up ()
  (interactive)
  (move-beginning-of-line (- (1- v-page))))
(defun f-page-down ()
  (interactive)
  (move-beginning-of-line (1+ v-page)))

(defvar v-skip-chars " \t")
(make-variable-buffer-local 'v-skip-chars)
(defun f-move-up-line ()
  (interactive)
  (skip-chars-backward v-skip-chars)
  (move-beginning-of-line (if (bolp) 0 1))
  (skip-chars-forward v-skip-chars))
(defun f-move-up-line-end ()
  (interactive)
  (move-end-of-line 0))
(defun f-move-down-line ()
  (interactive)
  (if (minibufferp) (move-end-of-line 1)
    (save-excursion
      (move-end-of-line 1)
      (when (and (eobp) (not buffer-read-only)) (newline 1)))
    (skip-chars-backward v-skip-chars)
    (move-beginning-of-line 2)
    (skip-chars-forward v-skip-chars)))
(defun f-move-down-line-end ()
  (interactive)
  (move-end-of-line (if (eolp) 2 1)))

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
	try-expand-dabbrev-visible
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-complete-file-name-partially
	try-complete-file-name
	try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol
	))
