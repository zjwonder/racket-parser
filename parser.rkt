#lang racket

(require "scanner-core.rkt")

(provide (all-defined-out))

(define (term tokens line) 
  ;(printf "term ~a ~a\n" (first tokens) line)
  (if (or (equal? (first tokens) "id")
          (equal? (first tokens) "num")
          (equal? (first tokens) "left-parens"))
      (factor-tail (factor tokens line) line)
      (list "error" (first tokens))))

(define (term-tail tokens line) 
  ;(printf "term-tail ~a ~a\n" (first tokens) line)
  (cond 
    
    [(equal? (first tokens) "add-op")
      (term-tail (term (rest tokens) line) line)]
    
    [(or  (equal? (first tokens) "right-parens")
          (equal? (first tokens) "id")
          (equal? (first tokens) "read")
          (equal? (first tokens) "write")
          (equal? (first tokens) "eof")
          (equal? (first tokens) "newline"))
      tokens]

    [(equal? (first tokens) "error") tokens]
    
    [else (list "error" (first tokens))]))

(define (factor tokens line) 
  ;(printf "factor ~a ~a\n" (first tokens) line)
  (cond
    
    [(or  (equal? (first tokens) "num")
          (equal? (first tokens) "id"))
      (rest tokens)]
    
    [(equal? (first tokens) "left-parens")
      (let ([next-toks (expr (rest tokens) line)])
        (if (equal? (first next-toks) "right-parens")
          (rest next-toks)
          next-toks))]

    [(equal? (first tokens) "error") tokens]
    
    [else (list "error" (first tokens))]))

(define (factor-tail tokens line) 
  ;(printf "factor-tail ~a ~a\n" (first tokens) line)
  (cond 
    
    [(equal? (first tokens) "mult-op")
      (factor-tail (factor (rest tokens) line) line)]

    [(or  (equal? (first tokens) "add-op")
          (equal? (first tokens) "right-parens")
          (equal? (first tokens) "id")
          (equal? (first tokens) "read")
          (equal? (first tokens) "write")
          (equal? (first tokens) "eof")
          (equal? (first tokens) "newline"))
      tokens]

    [(equal? (first tokens) "error") tokens]

    [else (list "error" (first tokens))]))

(define (expr tokens line) 
  ;(printf "expr ~a ~a\n" (first tokens) line)
  (if (or (equal? (first tokens) "id")
          (equal? (first tokens) "num")
          (equal? (first tokens) "left-parens"))
      (term-tail (term tokens line) line)
      (list "error" (first tokens))))

(define (stmt tokens line)
  ;(printf "stmt ~a ~a\n" (first tokens) line)
  (cond

    [(equal? (first tokens) "id")
      (if (equal? (second tokens) "assign-op")
        (stmt-list (expr (rest (rest tokens)) line) line)
        (rest tokens))]

    [(equal? (first tokens) "read")
      (if (equal? (second tokens) "id")
        (stmt-list (rest (rest tokens)) line)
        (rest tokens))]
    
    [(equal? (first tokens) "write") 
      (stmt-list (expr (rest tokens) line) line)]

    [(equal? (first tokens) "error") tokens]
    
    [else (list "error" (first tokens))]))

(define (stmt-list tokens line)
  ;(printf "stmt-list ~a ~a\n" (first tokens) line)
  (cond

    [(or 
      (empty? tokens) 
      (equal? (first tokens) "eof"))
      "ACCEPT"]

    [(equal? (first tokens) "newline")
      (stmt-list (rest tokens) (+ line 1))]

    [(or 
      (equal? (first tokens) "read")
      (equal? (first tokens) "write")
      (equal? (first tokens) "id")) 
        (stmt tokens line)]
    
    [else 
      (if (equal? (first tokens) "error")
        (printf "Syntax error on line ~a. Unexpected token: {~a}\n" line (second tokens))
        (printf "Syntax error on line ~a. Unexpected token: {~a}\n" line (first tokens)))]))

(define (parser file-name)
  (let ([input (scanner file-name)])
    (if (equal? (first input) "error")
      (second input)
      (stmt-list input 1))))


(displayln (parser "sample-inputs/Input01.txt"))
(displayln (parser "sample-inputs/Input02.txt"))
(displayln (parser "sample-inputs/Input03.txt"))
(displayln (parser "sample-inputs/Input04.txt"))
(displayln (parser "sample-inputs/Input05.txt"))
(displayln (parser "sample-inputs/Input06.txt"))