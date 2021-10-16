#lang racket

(require "scanner-core.rkt")



(define (parse-next input-stack output-stack line)
  )

(define (parser file-name)
  (parse-next (scanner file-name) empty 1))