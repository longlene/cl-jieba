(in-package #:cl-jieba)

(defctype size-t :unsigned-int)

;;#ifndef CJIEBA_C_API_H
;;#define CJIEBA_C_API_H
;;
;;#include <stdlib.h>
;;#include <stdbool.h>
;;
;;typedef void* Jieba;
(defctype jieba* :pointer)

;;Jieba NewJieba(const char* dict_path, const char* hmm_path, const char* user_dict, const char* idf_path, const char* stop_word_path);
(defcfun ("NewJieba" new-jieba) jieba*
         (dict-path :string)
         (hmm-path :string)
         (user-dict :string)
         (idf-path :string)
         (stop-word-path :string))

(defun make-jieba ()
  (let* ((dir (asdf:system-relative-pathname :cl-jieba "dict/"))
         (dict-path (namestring (merge-pathnames "jieba.dict.utf8" dir)))
         (hmm-path (namestring (merge-pathnames "hmm_model.utf8" dir)))
         (user-dict (namestring (merge-pathnames "user.dict.utf8" dir)))
         (idf-path (namestring (merge-pathnames "idf.utf8" dir)))
         (stop-word-path (namestring (merge-pathnames "stop_words.utf8" dir))))
    (new-jieba dict-path hmm-path user-dict idf-path stop-word-path)))

;;void FreeJieba(Jieba);
(defcfun ("FreeJieba" free-jieba) :void
         (jieba jieba*))

;;typedef struct {
;;  const char* word;
;;  size_t len;
;;} CJiebaWord;
(defcstruct %jieba-word
 (word :pointer)
 (len size-t))

;;CJiebaWord* Cut(Jieba handle, const char* sentence, size_t len);
(defun cut (handle sentence)
  (with-foreign-string (str sentence)
      (loop with len = (foreign-funcall "strlen" :pointer str size-t)
            with words = (foreign-funcall "Cut" :pointer handle :pointer str size-t len :pointer)
            for jieba-word = words then (inc-pointer jieba-word (foreign-type-size '(:struct %jieba-word)))
            until (or (null-pointer-p jieba-word) (null-pointer-p (foreign-slot-value jieba-word '(:struct %jieba-word) 'word)))
            collect (with-foreign-slots ((word len) jieba-word (:struct %jieba-word))
                                        (foreign-string-to-lisp word :count len)) into ret
            finally (progn (foreign-funcall "FreeWords" :pointer words)
                           (return ret)))))

;;CJiebaWord* CutWithoutTagName(Jieba, const char*, size_t, const char*);
(defun cut-without-tag (handle sentence tag)
  (with-foreign-string (str sentence)
      (loop with len = (foreign-funcall "strlen" :pointer str size-t)
            with words = (foreign-funcall "CutWithoutTagName" :pointer handle :pointer str size-t len :string tag :pointer)
            for jieba-word = words then (inc-pointer jieba-word (foreign-type-size '(:struct %jieba-word)))
            until (or (null-pointer-p jieba-word) (null-pointer-p (foreign-slot-value jieba-word '(:struct %jieba-word) 'word)))
            collect (with-foreign-slots ((word len) jieba-word (:struct %jieba-word))
                                        (foreign-string-to-lisp word :count len)) into ret
            finally (progn (foreign-funcall "FreeWords" :pointer words)
                           (return ret)))))

;;void FreeWords(CJiebaWord* words);

;;bool JiebaInsertUserWord(Jieba handle, const char* word);
(defcfun ("JiebaInsertUserWord" insert-user-word) :boolean
         (handle :pointer)
         (word :string))

;;typedef void* Extractor;
(defctype extractor* :pointer)

;;Extractor NewExtractor(const char* dict_path,
;;      const char* hmm_path,
;;      const char* idf_path,
;;      const char* stop_word_path,
;;      const char* user_dict_path);
(defcfun ("NewExtractor" new-extractor) extractor*
         (dict-path :string)
         (hmm-path :string)
         (idf-path :string)
         (stop-word-path :string)
         (user-dict-path :string))

(defun make-extractor ()
  (let* ((dir (asdf:system-relative-pathname :cl-jieba "dict/"))
         (dict-path (namestring (merge-pathnames "jieba.dict.utf8" dir)))
         (hmm-path (namestring (merge-pathnames "hmm_model.utf8" dir)))
         (idf-path (namestring (merge-pathnames "idf.utf8" dir)))
         (stop-word-path (namestring (merge-pathnames "stop_words.utf8" dir)))
         (user-dict (namestring (merge-pathnames "user.dict.utf8" dir))))
    (new-extractor dict-path hmm-path idf-path stop-word-path user-dict)))


;;CJiebaWord* Extract(Extractor handle, const char* sentence, size_t len, size_t topn);
(defun extract (extractor sentence topn)
  (with-foreign-string (str sentence)
      (loop with len = (foreign-funcall "strlen" :pointer str size-t)
            with words = (foreign-funcall "Extract" :pointer extractor :pointer str size-t len size-t topn :pointer)
            for jieba-word = words then (inc-pointer jieba-word (foreign-type-size '(:struct %jieba-word)))
            until (or (null-pointer-p jieba-word) (null-pointer-p (foreign-slot-value jieba-word '(:struct %jieba-word) 'word)))
            collect (with-foreign-slots ((word len) jieba-word (:struct %jieba-word))
                                        (foreign-string-to-lisp word :count len)) into ret
            finally (progn (foreign-funcall "FreeWords" :pointer words)
                           (return ret)))))

;;void FreeExtractor(Extractor handle);
(defcfun ("FreeExtractor" free-extractor) :void
         (handle extractor*))

;;#endif
