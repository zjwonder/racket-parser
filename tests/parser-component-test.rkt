#lang racket

(require rackunit "../parser.rkt")


(check-equal? (parse-next '("read") 1) '(#\space #\1))
(check-exn exn:fail? (lambda () (num-tokenize #\1 '(#\2 #\C #\. #\space) 1)))
(check-equal?(eof? #\$) #t)




(printf "end of test execution")