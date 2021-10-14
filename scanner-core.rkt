#lang racket
(require racket/trace)

;; each type of recognized symbol has a matching function below
;; except for alphabetic character matching which is built in

(define (eof? sym)
  (cond
    [(equal? sym #\$) true]
    [else false]))

(define (space? sym)
  (cond
    [(equal? sym #\space) true]
    [(equal? sym #\ ) true]
    [(equal? sym #\return) true]
    [else false]))

(define (newline? sym)
  (cond
    [(equal? sym #\newline) true]
    [else false]))

(define (add-op? sym)
  (cond
    [(equal? sym #\+) true]
    [(equal? sym #\-) true]
    [else false]))

(define (mult-op? sym)
  (cond
    [(equal? sym #\/) true]
    [(equal? sym #\*) true]
    [else false]))

(define (left-parens? sym)
  (cond
    [(equal? sym #\() true]
    [else false]))

(define (right-parens? sym)
  (cond
    [(equal? sym #\)) true]
    [else false]))

(define (left-assign? sym)
  (cond
    [(equal? sym #\:) true]
    [else false]))

(define (right-assign? sym)
  (cond
    [(equal? sym #\=) true]
    [else false]))

(define (digit? sym)
  (cond
    [(char-numeric? sym) true]
    [(equal? sym #\.) true]
    [else false]))


;; tokenizer
;; takes in char list and returns the current token
;; should be called in cases where a token could be multiple chars

(define (tokenize current-token input)
  (cond
    [(space? (first input)) current-token]
    [else (tokenize (string current-token (first input)) (rest input))]))


;; main scanner logic

(define (scan-next raw-input output line)

  (define (current-char) (first raw-input))
  (define (input) (rest raw-input))
  

  (cond
    
    [(eof? (current-char))
     (if (eof? (first input))
         (printf "LEXING PASS\n")
         output)]
      
    [(space? (current-char))
     ;(printf "SPACE\n")
     (scan-next input output line)]
      
    [(newline? (current-char))
     ;(printf "NEWLINE\n")
     (scan-next input (cons output "newline") (+ line 1))]

    [(add-op? (current-char))
     ;(printf "ADDOP:  ~a\n" (current-char))
     (scan-next input (cons output "add-op") line)]

    [(mult-op? (current-char))
     ;(printf "MULTOP: ~a\n" (current-char))
     (scan-next input (cons output "mult-op") line)]

    [(left-parens? (current-char))
     ;(printf "PARENS: ~a\n" (current-char))
     (scan-next input (cons output "left-parens") line)]
      
    [(right-parens? (current-char))
     ;(printf "PARENS: ~a\n" (current-char))
     (scan-next input (cons output "right-parens") line)]

    [(left-assign? (current-char))
     ;(printf "ASSIGN: ~a\n" (current-char))
     (if (right-assign? (first input))
         (scan-next input (cons output "assign") line)
         (printf "Lexical error on line ~a. Missing assignment symbol." line))
     ]
      
    [(char-alphabetic? (current-char))
     (printf "CHAR:   ~a\n" (current-char))
     (scan-next input (cons output ) line)]

    [(digit? (current-char))
     (printf "DIGIT:  ~a\n" (current-char))
     (scan-next (input) line)]
      
    [else
     (printf "Lexical error on line ~a. Unexpected symbol: ~a" line current-char)]))


;; take filename and pass contents into scanner core logic

(define (scanner file-name)
  (cond
    [(not (file-exists? file-name)) (error file-name "File does not exist")]
    [else
     (printf "Scanning file ~a\n" file-name)
     (scan-next [string->list (file->string file-name)] empty 1)]))


(scanner "Input01.txt")
(scanner "Input02.txt")
(scanner "Input03.txt")
(scanner "Input04.txt")
(scanner "Input05.txt")
(scanner "Input06.txt")
