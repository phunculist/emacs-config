;;;###autoload
(defun phunculist/erb-insert-or-toggle-erb-tag ()
  "Insert an ERb tag if the point isn't currently in one, or toggle the type."
  (interactive)
  (let ((action))
    (if (looking-at "[\s\t\n]*<%")
        (setq action 'insert)
      (save-excursion
        (let ((regex (concat "\\`<%.*%>\\'")))
          (while (or (not (region-active-p))
                     (not (or (and (= (point-min) (region-beginning))
                                   (= (point-max) (region-end)))
                              (string-match regex (buffer-substring-no-properties
                                                   (region-beginning)
                                                   (region-end))))))
            (let ((expand-region-fast-keys-enabled))
              (er/expand-region 1)))
          (let ((matched (buffer-substring-no-properties (region-beginning)
                                                         (region-end))))
            (if (string-match regex matched)
                (progn (goto-char (+ (if (< (point) (mark)) (point) (mark)) 2))
                       (cond ((looking-at "=")
                              (delete-char 1))
                             ((looking-at "#")
                              (delete-char 1)
                              (insert "="))
                             (t
                              (insert "#"))))
              (setq action 'insert))))))
    (if (eq action 'insert)
        (progn (insert "<%=  %>")
               (backward-char 3)))))
