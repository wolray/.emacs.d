;; !!buffer
(delete-selection-mode 1)
(electric-pair-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq x-select-enable-clipboard t)
(setq-default cursor-type 'bar)
(setq-default indent-tabs-mode t)
(show-paren-mode 1)

;; !!save
(defun BeforeSave ()
  (save-excursion
    (goto-char (point-max))
    (newline 1))
  (delete-trailing-whitespace))
(add-hook 'before-save-hook 'BeforeSave)

;; !!window
(column-number-mode 1)
(line-number-mode 1)
(scroll-bar-mode 0)
(winner-mode 1)
(global-linum-mode 1)

;; !package-menu-mode
(require 'package)
;; (setq package-archives '(("melpa" . "http://melpa.org/packages/")))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(defun PackageMenuMode ()
  (local-set-key (kbd "[") 'package-menu-describe-package)
  (local-set-key (kbd "]") 'next-line)
  (local-unset-key (kbd "n"))
  )
(add-hook 'package-menu-mode-hook 'PackageMenuMode)

;; avy
(setq avy-keys (number-sequence ?a ?z))

;; bs-mode
(defun BsMode ()
  (local-set-key (kbd "-") 'bs-set-current-buffer-to-show-never)
  (local-set-key (kbd "=") 'bs-set-current-buffer-to-show-always)
  (local-set-key (kbd "[") 'bs-select)
  (local-set-key (kbd "]") 'bs-down)
  (local-set-key (kbd "r") 'bs-select-other-window)
  (local-set-key (kbd "w") 'bs-toggle-readonly)
  (local-unset-key (kbd "%"))
  (local-unset-key (kbd "+"))
  (local-unset-key (kbd "C"))
  (local-unset-key (kbd "M"))
  (local-unset-key (kbd "S"))
  (local-unset-key (kbd "b"))
  (local-unset-key (kbd "f"))
  (local-unset-key (kbd "n"))
  (local-unset-key (kbd "o"))
  (local-unset-key (kbd "t"))
  (local-unset-key (kbd "u"))
  (local-unset-key (kbd "~"))
  )
(add-hook 'bs-mode-hook 'BsMode)

;; latex-mode
(defun LatexMode ()
  (my-paragraph-set)
  )
(add-hook 'latex-mode-hook 'LatexMode)

;; magit-mode
(setenv "GIT_ASKPASS" "git-gui--askpass")
(defun MagitMode ()
  (local-set-key (kbd "[") 'magit-section-toggle)
  (local-set-key (kbd "]") 'magit-section-forward)
  (local-unset-key (kbd "TAB"))
  (local-unset-key (kbd "n"))
  )
(add-hook 'magit-mode-hook 'MagitMode)
(defun MagitStatusSections ()
  (magit-insert-status-headers)
  (magit-insert-tracked-files)
  (magit-insert-unstaged-changes)
  (magit-insert-staged-changes)
  (magit-insert-unpulled-from-pushremote)
  (magit-insert-unpushed-to-pushremote)
  (magit-insert-am-sequence)
  (magit-insert-bisect-log)
  (magit-insert-bisect-output)
  (magit-insert-bisect-rest)
  (magit-insert-merge-log)
  (magit-insert-sequencer-sequence)
  (magit-insert-stashes)
  ;; (magit-insert-rebase-sequence)
  ;; (magit-insert-unpulled-from-upstream)
  ;; (magit-insert-unpushed-to-upstream)
  ;; (magit-insert-untracked-files)
  )
(add-hook 'magit-status-sections-hook 'MagitStatusSections)
(defun MagitStatusHeaders ()
  (magit-insert-head-branch-header)
  (magit-insert-diff-filter-header)
  (magit-insert-error-header)
  (magit-insert-repo-header)
  (magit-insert-tags-header)
  ;; (magit-insert-push-branch-header)
  ;; (magit-insert-upstream-branch-header)
  )
(add-hook 'magit-status-headers-hook 'MagitStatusHeaders)

;; org-mode
(setq org-startup-indented t)
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(defun OrgMode ()
  (local-set-key (kbd "C-c C--") 'OrgEvaluateTimeRange)
  (local-set-key (kbd "C-c C-=") 'org-time-stamp)
  (local-set-key (kbd "C-c C-M-]") 'org-clock-out)
  (local-set-key (kbd "C-c C-M-d") 'org-deadline)
  (local-set-key (kbd "C-c C-M-p") 'org-clock-in)
  (local-set-key (kbd "C-c C-M-s") 'org-schedule)
  (local-set-key (kbd "C-c C-]") 'outline-next-visible-heading)
  (local-set-key (kbd "C-c C-d") 'org-sparse-tree)
  (local-set-key (kbd "C-c C-s") 'org-sort)
  (local-set-key (kbd "C-c M-ESC") 'org-clock-cancel)
  (local-set-key (kbd "C-c e") 'org-edit-special)
  (local-set-key (kbd "C-c t") 'org-table-toggle-coordinate-overlays)
  (local-unset-key (kbd "C-c ["))
  (local-unset-key (kbd "C-c ]"))
  (setq skip-chars " \t*")
  )
(add-hook 'org-mode-hook 'OrgMode)

;; python-mode
(defun PythonMode ()
  (local-set-key (kbd "C-<return>") 'PythonShellSendLine)
  (local-set-key (kbd "C-c C-d") 'python-shell-send-defun)
  (local-set-key (kbd "C-c C-e") 'run-python)
  (local-unset-key (kbd "C-c C-p"))
  )
(add-hook 'python-mode-hook 'PythonMode)

;; racket-mode
(setq racket-racket-program "racket")
(setq racket-raco-program "raco")
(defun RacketMode ()
  (local-set-key (kbd "C-<return>") 'racket-send-last-sexp)
  (local-set-key (kbd "C-c C-e") 'RacketSendBuffer)
  (local-unset-key (kbd "C-c C-p"))
  )
(add-hook 'racket-mode-hook 'RacketMode)
