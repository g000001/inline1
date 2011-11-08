;;;; inline1.lisp

(cl:in-package :root.function.inline1-internal)

(def-suite inline1)

(in-suite inline1)

(defmacro adefun (name args &body body)
  `(defun ,name (,@args)
     (macrolet ((self (,@args) `(,',name ,,@args)))
       ,@body)))


(eval-when (:compile-toplevel :load-toplevel :execute)
  (adefun rename-to-inline (new old expr)
    (cond ((atom expr) expr)
          ((consp (car expr))
           (cons (cond ((eq 'cl:quote (caar expr))
                        (car expr) )
                       ((eq old (caar expr))
                        (cons new (cdar expr)) )
                       (T (self new old (car expr))) )
                 (self new old (cdr expr)) ))
          (T (cons (car expr)
                   (self new old (cdr expr)) )))))


(declaim (type (unsigned-byte 4) *depth*))
(defvar *depth* 0)


(defmacro defun-inline-self (name level (&rest args) &body body)
  (let* ((inline-name (gensym (format nil "INLINE-~A-" name)))
         (gargs (map-into (copy-list args) #'gensym))
         (binds (mapcar (lambda (x y) ``(,',x ,,y))
                        args
                        gargs)))
    `(defun ,name (,@args)
       (macrolet ((,inline-name (,@gargs)
                    (if (< ,level *depth*)
                        `(let (,,@binds)
                           ,@',body )
                        `(compiler-let ((*depth* (1+ *depth*)))
                           (let (,,@binds)
                               ,@',(rename-to-inline inline-name
                                                     name
                                                     body ))))))
         ,@(rename-to-inline inline-name
                             name
                             body )))))


;;; test
(test fib
  (is (= 55
         (progn
           (locally (declare (optimize (safety 0) (speed 3) (debug 0)))
             (defun-inline-self fib 4 (n)
               (declare (fixnum n))
               (the fixnum
                 (if (< n 2)
                     n
                     (+ (fib (1- n))
                        (fib (- n 2)) ))))
             (fib 10) )))))

;;; eof