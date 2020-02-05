(in-package #:cl-markov/english)
(import '(split-sequence:split-sequence))

(defun whitespacep(c)
  (or (char= #\space c)
      (char= #\tab c)
      (char= #\newline c)))
(defun punctuationp(c)
  (or (char= #\? c)
      (char= #\. c)
      (char= #\! c)))

(defun split-sentences(str)
  (split-sequence:split-sequence-if #'punctuationp str :remove-empty-subseqs t))
(let ((test "Hello there good friend. How are you?"))
  (assert (equalp (split-sentences test)
                  '("Hello there good friend" " How are you"))))
(defun split-words(str)
  (split-sequence:split-sequence-if #'whitespacep str :remove-empty-subseqs t))
(let ((test "Hello there friend")
      (result '("Hello" "there" "friend")))
  (assert (equal (split-words test) result)))

(defun build-model(text &key (degree 1) (markov nil))
  "Build a model, roughly suitable for english"
  (let ((mt (if markov markov (make-markov :degree degree))))
    (loop for sentence in (split-sentences text)
          do(fill-table mt (split-words sentence)))
    mt
    ))
(export '(build-model))
