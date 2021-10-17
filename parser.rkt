#lang racket

(require "scanner-core.rkt")



(define (parse-next input output-stack line states)
  (let (
    [in (first input)]
    [input (rest input)])
    (cond
      [(equal? in "newline") 
        (cond 
          [(equal? (length states) 0)
            (parse-next input output-stack (+ line 1) '())]
          [(and (equal? state-depth 1) (equal? state "expr"))
            (parse-next input (cons state output-stack) (+ line 1) "")]
          [else (error "Syntax error on line ~a: unexpected newline")])]

      [(equal? in "read")
        (if (equal? (first input) "id")
          (cons "stmt" output-stack)
          (printf "shits broke"))]
      
      [(equal? in "write")]

      [(equal? in "assign-op")]

      [(equal? in "id")]

      [(equal? in "num")]

      [(equal? in "add-op")]

      [(equal? in "mult-op")]

      [(equal? in "left-parens")]

      [(equal? in "right-parens")]

      [(equal? in "right-parens")]

      [(equal? in "eof")]

      [(equal? 0 0)])))

(define (parser file-name)
  (let ([input (scanner file-name)])
    (parse-next input empty 1 0)))

(parser "sample-inputs/Input01.txt")