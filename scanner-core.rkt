#lang racket
(require racket/trace)

;(for ([line (file->lines "input01.txt")])
;  (displayln line))

(define fileName "input01.txt")

(cond
  [(not (file-exists? fileName)) (error "File not found.")])

;; single-char symbols have a function below

(define (addOp? sym)
  (cond
    [(equal? sym #\+) true]
    [(equal? sym #\-) true]
    [else false]
  ))

(define (multOp? sym)
  (cond
    [(equal? sym "/#/") true]
    [(equal? sym "/#*") true]
    [else false]
  ))


(define (lst-length lst)
  (define (iter lst len)
    (cond
      [(empty? lst) len]
      [else
       (iter (rest lst) (+ len 1))]))
  (iter lst 0))

#;(define (calcGramScan charList)
  (define (iter charList stack)
    (cond
      [(empty? charList) (write "EOF")]
      [(equal? 
       (cond
         [(addOp? (first charList)) (write "cool story")]
         [else (write "bro")])
       (iter (rest charList) (append stack (first charList)))
      )]
    (iter charList stack))))

(addOp? "+")


(lst-length [string->list (file->string fileName)])

