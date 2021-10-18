#lang racket

(require rackunit "../parser.rkt")

(check-equal? (parser "../sample-inputs/Input01.txt") (void))
(check-exn exn:fail? (lambda () (parser "../sample-inputs/Input02.txt")))
(check-exn exn:fail? (lambda () (parser "../sample-inputs/Input03.txt")))
(check-equal? (parser "../sample-inputs/Input04.txt") (void))
(check-equal? (parser "../sample-inputs/Input05.txt") (void))
(check-exn exn:fail? (lambda () (parser "../sample-inputs/Input06.txt")))

(printf "end of test execution")