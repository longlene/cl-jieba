(in-package #:cl-jieba)

(defvar *dict-path*)
(defvar *hmm-path*)
(defvar *user-dict*)
(defvar *idf-path*)
(defvar *stop-word-path*)

(let ((dir (asdf:system-relative-pathname :cl-jieba "dict/")))
  (setq *dict-path* (namestring (merge-pathnames "jieba.dict.utf8" dir)))
  (setq *hmm-path* (namestring (merge-pathnames "hmm_model.utf8" dir)))
  (setq *user-dict* (namestring (merge-pathnames "user.dict.utf8" dir)))
  (setq *idf-path* (namestring (merge-pathnames "idf.utf8" dir)))
  (setq *stop-word-path* (namestring (merge-pathnames "stop_words.utf8" dir))))

(defun make-jieba (&key (dict-path *dict-path*) (hmm-path *hmm-path*) (user-dict *user-dict*) (idf-path *idf-path*) (stop-word-path *stop-word-path*))
  (new-jieba dict-path hmm-path user-dict idf-path stop-word-path))

(defmacro with-jieba ((jieba &key (dict-path *dict-path*) (hmm-path *hmm-path*) (user-dict *user-dict*) (idf-path *idf-path*) (stop-word-path *stop-word-path*)) &body body)
  `(let ((,jieba (new-jieba ,dict-path ,hmm-path ,user-dict ,idf-path ,stop-word-path)))
     (unwind-protect (progn ,@body)
       (free-jieba ,jieba))))
