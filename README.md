# cl-jieba

Common Lisp bindings for cjieba

## Installation
```bash
git clone https://github.com/longlene/cl-jieba.git ~/.quicklisp/local-projects/cl-jieba
```

## Usage example
```lisp
CL-USER> (defparameter *jieba* (jieba:make-jieba))
*JIEBA*
CL-USER> (jieba:cut *jieba* "人艰不拆")
("人艰" "不" "拆")
CL-USER> (jieba:free-jieba *jieba*)
```
