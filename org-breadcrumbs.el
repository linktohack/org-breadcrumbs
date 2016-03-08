;;; org-breadcrumbs.el --- Breadcrumbs for Org.

;; Copyright (C) 2016 Quang-Linh LE

;; Author: Quang-Linh LE <linktohack@gmail.com>
;; URL: http://github.com/linktohack/org-breadcrumbs
;; Version: 0.0.7
;; Keywords: org-breadcrumbs breadcrumbs breadcrumb focus narrow
;; Package-Requires: ()

;; This file is not part of GNU Emacs.

;;; Code:

(setq org-breadcrumbs-header-format
      '(:eval
        (let ((path (when (> (funcall outline-level) 0)
                      (org-get-outline-path t))))
          (mapconcat #'identity
                     (cons
                      (let ((map (make-sparse-keymap)))
                        (define-key map [header-line mouse-1]
                          #'(lambda ()
                              (interactive)
                              (widen)
                              (org-content 1)
                              (goto-char (point-min))))
                        (concat
                         (propertize
                          " "
                          'display
                          '(space :align-to 0))
                         (propertize
                          "Top"
                          'font-lock-face 'org-link
                          'mouse-face 'highlight
                          'keymap map)))
                      (cl-loop
                       for i downfrom (- (length path) 1)
                       for heading in path
                       collect (let ((map (make-sparse-keymap)))
                                 (define-key map [header-line mouse-1] 
                                   `(lambda ()
                                      (interactive)
                                      (widen)
                                      (if (> (funcall outline-level) 1)
                                        (outline-up-heading ,i))
                                      (org-narrow-to-subtree)))
                                 (propertize
                                  heading
                                  'font-lock-face 'org-link
                                  'mouse-face 'highlight
                                  'keymap map))))
                     " > "))))

(define-minor-mode org-breadcrumbs-mode
  "Breadcrumbs for Org."
  :lighter " b"
  (if org-breadcrumbs-mode
      (setq-local header-line-format org-breadcrumbs-header-format)
    (setq-local header-line-format nil)))

(provide 'org-breadcrumbs)
