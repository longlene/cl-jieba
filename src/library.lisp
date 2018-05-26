(in-package #:cl-jieba)

(defun get-library-path (suffix)
  (asdf:system-relative-pathname :cl-jieba suffix))

(pushnew (get-library-path "lib/")
         cffi:*foreign-library-directories* :test #'equal)

(define-foreign-library libjieba
                        (:darwin "libjieba.dylib")
                        (:unix "libjieba.so")
                        (:windows "jieba.dll")
                        (t (:default "libjieba")))

(unless (foreign-library-loaded-p 'libjieba)
  (use-foreign-library libjieba))

