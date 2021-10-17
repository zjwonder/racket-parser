#lang racket

(require racket/match "parser.rkt")

(define (lst-length lst)
  (define (iter lst len)
    (cond
      [(empty? lst) len]
      [else
       (iter (rest lst) (+ len 1))]))
  (iter lst 0))


;;(lst-length [string->list (file->string fileName)])



(string-append "Look, a space:::::" (string #\ ) ":::::")

;(equal? #\space (string->char " "))

(regexp-match? #rx"([A-Z]|[a-z])+" (string #\A))

(char-downcase #\a)
(char-upcase #\a)
(char-upcase #\A)

