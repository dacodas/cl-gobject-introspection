(require :uiop)

(let ((argument (first (uiop:command-line-arguments))))
  (push (intern (format nil "GTYPE-TEST-HARNESS-~A" (string-upcase argument))
		"KEYWORD")
	*features*))

(format t
	"Will read system from ~A~%"
	(asdf:system-source-directory "cl-gobject-introspection"))

#+gtype-test-harness-alpha
(progn
  (asdf:load-system "cl-gobject-introspection" :force t)
  (asdf:load-system "cl-gobject-introspection-test" :force t)
  (quit))

;; TODO: Why can't I use a `progn` here?
#+gtype-test-harness-beta
(require "cl-gobject-introspection-test")

#+gtype-test-harness-beta
(progn
  (gir-test::run! 'gir-test::cross-platform-gtype)
  (quit))
