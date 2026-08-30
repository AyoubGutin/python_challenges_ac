#lang sicp

(define (square x) (* x x))


; Procedure for getting the length of list - linear recursion - expands and contracts.
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define list1 (list 1 2 3 4 5 6 7 8 9 10 11))

; recreating list-ref using linear recursion
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

; !Exercise 2.17

; returns the list that contains the last element
(define (last-pair items)
  (if (null? (cdr items)) ; this means only one element left
      items
      (last-pair (cdr items))))


; !Exercise 2.18

; cons car recursivley, until length = n - 1
(define (pop items)
  (define (pop-iter remaining)
    (if (=  (length remaining) 1) ; if length of remaining list, stop
        nil
        (cons (car remaining) (pop-iter (cdr remaining))))) ; append first item of remaining list, one at a time
  
  (pop-iter items))

(define (reverse items)
  (if (null? items)
      nil
      (cons (car (last-pair items)) (reverse (pop items)))))

; The above solution is unoptimised. It recursively extracts last element, and pops it from the list.
; exponential time complexity, and linear space complexity.
; below is a better solution, with O(n) time, O(1) space.

(define (reverse-new items)
  (define (iter remaining result)
    (if (null? remaining)
        result
        (iter (cdr remaining) (cons (car remaining) result))))
  (iter items nil))



; -----------------------

; Exercise 2.19

(define (cc amount coin-values)
  (cond ((= amount 0) 
         1)
        ((or (< amount 0) 
             (no-more? coin-values)) 
         0)
        (else
         (+ (cc 
             amount
             (except-first-denomination 
              coin-values))
            (cc 
             (- amount
                (first-denomination 
                 coin-values))
             coin-values)))))

; replaces the exercise 1.2.2, as we are passing a list this time, rather than hardcoding a procedure to store values of coins.
; it is more flexible now, and possibly more efficient as there are no conditional checks for first-denomination.

(define no-more? null?)
(define first-denomination car)
(define except-first-denomination cdr)



; ----------------------------

; Exercise 2.20

; A proceudre, like +, *, can take abritrary arguments. (define f x y . z) x, y = vars z = vars as a lsit. like *args in python

; same-parity, a procedure to return a list of all arguments that have the same even-odd parity as the first argument

(define (same-parity a . z)
  (define (same-parity-iter remaining result flag)
    (cond ((null? remaining) (reverse-new result))
          ((= (remainder (car remaining) 2) flag)
           (same-parity-iter (cdr remaining) (cons (car remaining) result) flag))
          (else (same-parity-iter (cdr remaining) result flag))))
  
  (same-parity-iter z (list a) (remainder a 2)))

(same-parity 2 3 4 5 6 7 8)
        


; ----------------------------

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items)) (map proc (cdr items)))))

; Exercise 2.21

; without abstraction of mapping
(define (square-list items)
  (if (null? items)
      nil
      (cons (* (car items) (car items)) (square-list (cdr items)))))

; with abstraction of mapping
(define (square-list-map items)
  (map (lambda (x) (* x x)) items))

(square-list (list 1 2 3 4 5 6))


; Exercise 2.22

(define (square-list-iter items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) (cons (square (car things)) answer))))
  
  (iter items nil))

; tracing the above procedure with a list
; 1) (iter (1 2 3 4) nil)
; 2) (iter (2 3 4) (cons 1 nil)
; 3) (iter (3 4) (cons 4 (1 nil))
; 4) (iter 4) (cons 9 (4 (1 nil)))
; 5 (cons 16 (9 (4 (1 nil))))
; 6) (16 9 4 1)

; It is in reverse order, because of the recursive nature of the procedure, so we combine the 1st element of the list each pass
; to the remaining list each pass. As the remaining list gets smaller, cons prepends each term to the front, resulting in a reverse list


; If you interchange the arguments it will output as follows:
; 1) (iter (1 2 3) nil)
; 2) (iter 2 3) (cons nil 1) = (() . 1)
; 3) (iter 3) ((nil 1 (4)) =
; 4) (((nil 1 (4 (16)) -> there is no nil condition in the cdrs, and would result in dot notation, due ot raw numbers being last elemens


; Exercise 2.23

; to make a for-each implementation, we would need to apply a function, f, to the first element, then minimise the running list.
(define (for-each proc items)
  (cond ((null? items) #t)
        (else
         (proc (car items))
         (for-each proc (cdr items)))))

(for-each abs (list -1 -2 3 4 5))