#lang sicp
; Exercise 2.27

; takes in a list, and reverses it, but it doesn't reverse deep lists
(define (reverse items)
  (define (iter remaining result)
    (if (null? remaining)
        result
        (iter (cdr remaining) (cons (car remaining) result))))
  (iter items nil))

; reverses sublists
(define (deep-reverse items)
  (define (iter remaining result)
    (cond ((null? remaining) result)
          ((pair? (car remaining))
               (iter (cdr remaining) (cons (deep-reverse (car remaining)) result)))
          (else (iter (cdr remaining) (cons (car remaining) result)))))
  (iter items nil))

(define x (list (list 1 (list 1 2)) (list 3 4)))

(deep-reverse x)
         

; trace call

; - Element 1 is a pair. (1 (1 2)). 
;   - Recursive call for (deep-reverse '(1 (1 2)))
;       - Element 1 is not a pair, keeps 1.
;       - Element 2 is a pair, call (deep-reverse '(1 2))
;           - This yields a list of (2 1)
        - The recursive call then yields a result of ((2 1) 1)
;
; - Element 2 is a pair. (3 4) ... recursive calls yield (4 3)
;
; - Accumulating into result yields the deep reversed list. 
