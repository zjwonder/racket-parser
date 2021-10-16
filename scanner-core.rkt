#lang racket
(require racket/trace)



;; each type of recognized symbol has a comparison fn below
;; except for alphabetic chars which have a built-in fn built in


(define (eof? sym)
  (cond
    [(equal? sym #\$) true]
    [else false]))

(define (space? sym)
  (cond
    [(equal? sym #\space) true]
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



;; alphabetic id tokenizer
;; takes in char list and returns the next whole token
;; token terminates at any non-alphanumeric character

(define (alpha-tokenize current-token input-stack)
  (cond
    [(not (or (char-alphabetic? (first input-stack)) (char-numeric? (first input-stack))))
     (cons current-token input-stack)]
    [else
     (if (char? current-token)
         (alpha-tokenize (string current-token (first input-stack)) (rest input-stack))
         (alpha-tokenize (string-append current-token (string (first input-stack))) (rest input-stack)))]))



;; numeric value tokenizer
;; takes in char list and returns the next whole token
;; token terminates at any non-numeric and non-decimal character

(define (num-tokenize current-token input-stack)
  (cond
    [(not (digit? (first input-stack)))
     input-stack]
    [else
     (if (char? current-token)
         (num-tokenize (string current-token (first input-stack)) (rest input-stack))
         (num-tokenize (string-append current-token (string (first input-stack))) (rest input-stack)))]))



;; main scanner logic
;; recursive function that iterates through list of chars and outputs lexical structure
;; execution ends when a lexical error is located
;; initial parameters: list of chars, empty list, 1st line number

(define (scan-next raw-input-stack output-stack line)

  ; save a bit of typing later
  (define current-char (first raw-input-stack))
  (define input-stack (rest raw-input-stack))

  (cond

    ; check for '$$' (end-of-file)
    [(eof? current-char)
     (if (eof? (first input-stack))
         (reverse output-stack)
         (printf "Lexical error on line ~a. Unexpected symbol: {~a}\n" line current-char))]

    ; check for space or return
    [(space? current-char)
     (scan-next input-stack output-stack line)]

    ; check for newline
    [(newline? current-char)
     (scan-next input-stack (cons "newline" output-stack) (+ line 1))]

    ; check for '+' or '-' (addition or subtraction operator)
    [(add-op? current-char)
     (scan-next input-stack (cons "add-op" output-stack) line)]

    ; check for '/' or '*' (multiplication or division operator)
    [(mult-op? current-char)
     (scan-next input-stack (cons "mult-op" output-stack) line)]

    ; check for '(' (left parenthesis)
    [(left-parens? current-char)
     (scan-next input-stack (cons "left-parens" output-stack) line)]

    ; check for ')' (right parenthesis)
    [(right-parens? current-char)
     (scan-next input-stack (cons "right-parens" output-stack) line)]

    ; check for ':' (left assignment char)
    [(left-assign? current-char)
     (if (right-assign? (first input-stack))
         (scan-next (rest input-stack) (cons "assign" output-stack) line)
         (printf "Lexical error on line ~a. Unexpected symbol: {~a}\n" line current-char))]

    ; check for alphabetic characters
    [(char-alphabetic? current-char)
     (define alpha-result (alpha-tokenize current-char input-stack))
     (define alpha-token (first alpha-result))
     (define alpha-rest (rest alpha-result))
     (if (or (equal? alpha-token "read") (equal? alpha-token "write"))
         (scan-next alpha-rest (cons alpha-token output-stack) line)
         (scan-next alpha-rest (cons "id" output-stack) line))]

    ; check for numeric characters
    [(digit? current-char)
     (scan-next (num-tokenize current-char input-stack) (cons "num" output-stack) line)]
      
    [else
     (printf "Lexical error on line ~a. Unexpected symbol: {~a}\n" line current-char)]))



;; take filename and pass contents into scanner core logic

(define (scanner file-name)
  (cond
    [(not (file-exists? file-name)) (error file-name "File does not exist")]
    [else
     (displayln file-name)
     (scan-next [string->list (file->string file-name)] empty 1)]))



(scanner "sample-inputs/Input01.txt")
(scanner "sample-inputs/Input02.txt")
(scanner "sample-inputs/Input03.txt")
(scanner "sample-inputs/Input04.txt")
(scanner "sample-inputs/Input05.txt")
(scanner "sample-inputs/Input06.txt")