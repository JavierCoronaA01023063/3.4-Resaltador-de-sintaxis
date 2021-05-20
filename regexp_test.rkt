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

(define (find-strings string)
  (define result (regexp-match #px":\\s*(\".+?\")" string))
  (format "<span class='~a'>~a</span>" "string" (car result)))

(define (find-object-keys string)
  (define result (regexp-match #px"(\".+?\")\\s*:" string))
  (format "<span class='~a'>~a</span>" "object-key" (car result)))

(define (find-numbers string)
  (define result (regexp-match #px"-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?" string))
  (format "<span class='~a'>~a</span>" "number" (car result)))

(define (find-punctuation string)
  (define result (regexp-match #px"[:[\\]{}]" string))
  (format "<span class='~a'>~a</span>" "punctuation" (car result)))

(define (find-reserved-words string)
  (define result (regexp-match #px"true|null|false" string))
  (format "<span class='~a'>~a</span>" "reserved-word" (car result)))


(define (convert-html in-file-path)
  (define file (file->string in-file-path))
  
  (let loop
    ([result ""][file file])
    (if (non-empty-string? file)
        (define token
        (cond
          [(regexp-match #px":\\s*(\".+?\")" file)(list (regexp-match #px":\\s*(\".+?\")" file) "string")]
          [(regexp-match #px"(\".+?\")\\s*:" file) (list (regexp-match #px":\\s*(\".+?\")" file) "string")]
          [(regexp-match #px"-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?" file) (list (regexp-match #px":\\s*(\".+?\")" file) "string")]
          [(regexp-match #px"[:[\\]{}]" file) (list (regexp-match #px":\\s*(\".+?\")" file) "string")]
          [(regexp-match #px"true|null|false" file) (list (regexp-match #px":\\s*(\".+?\")" file) "string")]
          ))
        (loop (string-append result (fun)) (substring file (length (car token))))
        result)))
    
    
  

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

