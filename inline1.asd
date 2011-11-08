;;;; inline1.asd

(cl:in-package :asdf)

(defsystem :inline1
  :serial t
  :depends-on (:fiveam)
  :components ((:file "package")
               (:file "inline1")))

(defmethod perform ((o test-op) (c (eql (find-system :inline1))))
  (load-system :inline1)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :root.function.inline1-internal :inline1))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

