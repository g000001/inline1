;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :root.function.inline1
  (:use)
  (:nicknames :inline1)
  (:export :defun-inline-self))

(defpackage :root.function.inline1-internal
  (:use :inline1 :cl :fiveam #+sbcl :sb-cltl2)
  (:import-from #+allegro :excl
                #+(or cmu :scl clisp) :ext
                #+ccl :ccl
                :compiler-let))
