;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :root.function.inline1
  (:use)
  (:nicknames :inline1)
  (:export :defun-inline-self))

(defpackage :root.function.inline1-internal
  (:use :inline1 :cl :fiveam #+sbcl :sb-cltl2))

