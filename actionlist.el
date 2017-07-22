;; ########################################################################
;;
;; Actionlist
;;
;;
;; Actionlist reads input, builds a numbered list from it, attaches an
;; action for each list element and displays it in a new buffer. Single
;; actions can be performed by pressing and confirming the according
;  number. Action*lines* are TUI elements that bind a certain text
;; element to a predefined action.
;;
;; ########################################################################


;; Requires

(require 'widget)


;; Varialbes

(defvar actionlist '())

(defvar actionlist-buffer "*Actionlist*")


;; Faces

(defgroup actionlist  nil
  "Actionlist group"
  :group 'local)

(defgroup actionline-faces nil
  "Actionlist faces"
  :group 'actionlist
  :group 'faces)

(defface actionline-number-face
  '((t :inherit font-lock-keyword-face :bold t))
  :group 'actionline-faces)

(defface actionline-text-face
  '((t :inherit font-lock-comment-face :bold t))
  :group 'actionline-faces)

(defface actionline-button-face
  '((t :inherit font-lock-constant-face :bold t))
  :group 'actionline-faces)


;; Functions

(defun actionlist-build (list)
  "Take LIST and build an associative list from it.
Every cons of the associative list has the form (index . string)."
  (let ((idx 0))
    (setq idx 0)
    (dolist (element list)
      (setq idx (+ idx 1))
      (add-to-list 'actionlist (cons idx element) t))))

(setq testlist '("red" "green" "blue" "yellow"))

(let ()
  (setq actionlist '())
  (actionlist-build testlist)
  (print actionlist))

(defun actionlist-insert ()
  (actionlist-build testlist)
  (switch-to-buffer-other-window actionlist-buffer)
  (with-selected-window (get-buffer-window actionlist-buffer)
    (erase-buffer)
    (dolist (list-element actionlist)
      (insert-actionline list-element))))

(defun actionlist-kill-buffer ()
  (kill-buffer actionlist-buffer))

(defun insert-actionline (list-element)
  (let ((number (format "%s" (car list-element)))
	(text (cdr list-element)))
    (widget-insert
     (propertize number 'face 'actionline-number-face))
    (widget-insert
     (propertize text 'face 'actionline-text-face))
    (actionlist-button-widget text)
    (widget-insert "\n")))


(defun actionlist-button-widget (text)
  (progn
    (widget-create 'link
		   :button-prefix "["
		   :button-suffix "]"
		   :button-face 'actionline-button-face
		   :format "%v%"
		   :tag text
		   :help-echo "Action"
		   )
    (widget-insert (propertize text 'face 'actionline-button-face))))


;; Sample usage:
;;
;; (let (al (build-actionlist testlist))
;;   (dolist (n al)
;;     (message (format "%s" n))))

(progn
  (actionlist-insert))

(provide 'actionlist)
