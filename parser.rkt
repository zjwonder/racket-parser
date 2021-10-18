#lang racket

(require "scanner-core.rkt")


(define (syntax-error token line)
  (error "Syntax error on line ~a. Unexpected token: {~a}\n" line token))

(define (expr tokens line) 
  (printf "expr ~a ~a\n" (first tokens) line)
  (if (or (equal? (first tokens) "id")
          (equal? (first tokens) "num")
          (equal? (first tokens) "left-parens"))
      (term-tail (term (rest tokens) line) line)
      (syntax-error (first tokens) line)))

(define (term tokens line) 
  (printf "term ~a ~a\n" (first tokens) line)
  (if (or (equal? (first tokens) "id")
          (equal? (first tokens) "num")
          (equal? (first tokens) "left-parens"))
      (factor-tail (factor (rest tokens) line) line)
      (syntax-error (first tokens) line)))

(define (term-tail tokens line) 
  (printf "term-tail ~a ~a\n" (first tokens) line)
  (cond 
    
    [(equal? (first tokens) "add-op")
      (term-tail (term (rest tokens) line) line)]
    
    [(or  (equal? (first tokens) "right-parens")
          (equal? (first tokens) "id")
          (equal? (first tokens) "read")
          (equal? (first tokens) "write")
          (equal? (first tokens) "eof"))
      tokens]
    
    [else (syntax-error (first tokens) line)]))

(define (factor tokens line) 
  (printf "factor ~a ~a\n" (first tokens) line)
  (cond
    
    [(or  (equal? (first tokens) "num")
          (equal? (first tokens) "id"))
      (rest tokens)]
    
    [(equal? (first tokens) "left-parens")
      (let ([next-toks (expr (rest tokens))])
        (if (equal? (first next-toks) "right-parens")
          (rest next-toks)
          (syntax-error (first next-toks) line)))]
    
    [else (syntax-error (first tokens) line)]))

(define (factor-tail tokens line) 
  (printf "factor-tail ~a ~a\n" (first tokens) line)
  (cond 
    
    [(equal? (first tokens) "mult-op")
      (factor-tail (factor (rest tokens) line) line)]

    [(or  (equal? (first tokens) "add-op")
          (equal? (first tokens) "right-parens")
          (equal? (first tokens) "id")
          (equal? (first tokens) "read")
          (equal? (first tokens) "write")
          (equal? (first tokens) "eof"))
      tokens]

    [else (syntax-error (first tokens) line)]))

(define (stmt tokens line)
  (printf "stmt ~a ~a\n" (first tokens) line)
  (cond

    [(equal? (first tokens) "id")
      (if (equal? (second tokens) "assign")
        (stmt-list (expr (rest (rest tokens)) line) line)
        (syntax-error (second tokens) line))]

    [(equal? (first tokens) "read")
      (if (equal? (second tokens) "id")
        (stmt-list (rest (rest tokens)) line)
        (syntax-error (second tokens) line))]
    
    [(equal? (first tokens) "write") 
      (stmt-list (expr (rest tokens) line) line)]
    
    [else (syntax-error (first tokens) line)]))

(define (stmt-list tokens line)
  (printf "stmt-list ~a ~a\n" (first tokens) line)
  (cond

    [(or 
      (empty? tokens) 
      (equal? (first tokens) "eof"))
      (printf "ACCEPT")]

    [(equal? (first tokens) "newline")
      (stmt-list (rest tokens) (+ line 1))]

    [(or 
      (equal? (first tokens) "read")
      (equal? (first tokens) "write")
      (equal? (first tokens) "id")) 
        (stmt tokens line)]
    
    [else
      (syntax-error (first tokens) line)]))

(define (parser file-name)
  (let ([input (scanner file-name)])
    (stmt input 1)))


(parser "sample-inputs/Input01.txt")