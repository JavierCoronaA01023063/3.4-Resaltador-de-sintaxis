#lang racket

(require racket/trace)

; Declare publicly available functions
(provide test get-html-output)

(define (test file-path)
  " Identify strings containing a fixed sequence "
  ; Identify the string hello, with any combination of upper/lower case
  ;(regexp-match #px"[hH][eE][lL][lL][oO]" input-string))
  (regexp-match #px"\\:s*\".+?\"" (file->string file-path)))

(define (get-html-output input-string)
  " Extract only the name part of a file name "
  (let
    ; Define two groups: one for the name and one for the extension
    ; Store the results of the regular expression (a list) in variable 'matches'
    ([matches (regexp-match #px"([\\w-]+)(\\.\\w{1,4})" input-string)])
    ; Take only the first group
    (string-append (cadr matches) ".html")))

(define (read-file in-file-path)
  (call-with-input-file in-file-path
    (lambda (in)
      (let loop
        ([line (read-line in)]
         [result empty])
        (if (eof-object? line)
            result
            (loop (read-line in) (append result (list line))))))))


(define (write-file out-file-path data)
  (call-with-output-file out-file-path
    #:exists 'truncate
    (lambda (out)
      (let loop
        ([lst data])
        (cond
          [(not (empty? lst))
             (displayln (car lst) out)
             (loop (cdr lst))])))))


(define (main in-file-path)
  (define data (read-file in-file-path))
  (define result (list (format (file->string "regexp_site.html") data)))
  (write-file (get-html-output in-file-path) result))