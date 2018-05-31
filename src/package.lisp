(defpackage #:cl-jieba
  (:nicknames #:jieba)
  (:use #:cl #:cffi #:alexandria)
  (:export #:new-jieba
           #:make-jieba
           #:free-jieba
           #:cut
           #:cut-without-tag
           #:insert-user-word
           #:new-extractor
           #:make-extractor
           #:extract
           #:free-extractor
           #:with-jieba))
