#lang racket

(require racket/trace)

; Declare publicly available functions
(provide test get-html-output)

(define (test file-path)
  " Identify strings containing a fixed sequence "
  ; Identify the string hello, with any combination of upper/lower case
  ;(regexp-match #px"[hH][eE][lL][lL][oO]" input-string))
  (regexp-match* #px":\\s*\".+?\"" (file->string file-path)))

(define (get-html-output input-string)
  " Extract only the name part of a file name "
  (let
    ; Define two groups: one for the name and one for the extension
    ; Store the results of the regular expression (a list) in variable 'matches'
    ([matches (regexp-match #px"([\\w-]+)(\\.\\w{1,4})" input-string)])
    ; Take only the first group
    (string-append (cadr matches) ".html")))

(define (generate-span string type)
  (format "<span class='~a'>~a</span>" type string))

(define (convert-html in-file-path)
  (define file (file->string in-file-path))
  (let loop
    ([result ""][file file])
    (if (non-empty-string? file)
        (let
            ([token
        (cond
          [(regexp-match #px"^(\"[\\w]+?\")\\s*:" file) (list (cadr (regexp-match #px"^(\"[\\w]+?\")\\s*:" file)) "object-key")]
          [(regexp-match #px"^(\"[a-zA-Z]*\\:?(\\s[A-Z]\\.)?(\\s[a-zA-Z]*)?\")" file)(list (cadr (regexp-match #px"^(\"[a-zA-Z]*\\:?(\\s[A-Z]\\.)?(\\s[a-zA-Z]*)?\")" file)) "string")]
          [(regexp-match #px"^[:[\\]{},]" file) (list (car (regexp-match #px"^[:[\\]{},]" file)) "punctuation")]
          [(regexp-match #px"^-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?" file) (list (car (regexp-match #px"^-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?" file)) "number")]
          [(regexp-match #px"^(true|null|false)" file) (list (cadr (regexp-match #px"^(true|null|false)" file)) "reserved-word")]
          [(regexp-match #px"^\\s+" file) (list (car (regexp-match #px"^\\s+" file)) "space")]
          )])
        (loop (string-append result (generate-span (car token) (cadr token))) (substring file (string-length (car token)))))
        result
        )))
    
    
  

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
  (define result (list (format (file->string "regexp_site.html") (convert-html in-file-path))))
  (write-file (get-html-output in-file-path) result))

