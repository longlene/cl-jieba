(in-package #:cl-user)

#+sbcl
(declaim (sb-ext:muffle-conditions sb-kernel:character-decoding-error-in-comment))

(defpackage #:cl-jieba-asd
  (:use :cl :asdf))

(in-package :cl-jieba-asd)

(defsystem #:cl-jieba
  :version "0.0.1"
  :author "loong0"
  :license "MIT"
  :description "Common Lisp bindings of cjieba"
  :depends-on (#:cffi
	       #:alexandria)
  :serial t
  :pathname "src"
  :components
  ((:file "package")
   (:file "library")
   (:file "jieba")
   (:file "macro"))
  :in-order-to ((test-op (test-op cl-jieba-test))))
