#lang sicp
; Quotations

; Exercise 2.54

; checks top-level contents of a list, and if their identity is equal in memory
(define (equal? l1 l2)
  (cond ((and (null? l1) (null? l2)) #t)
      ((eq? (car l1) (car l2)) (equal? (cdr l1) (cdr l2)))
      (else #f)))


; Exercise 2.56

; Extend basic differentiator to handle more kinds of expressions.

 (define (make-exponentiation base exponent)
   (list '** base exponent))

(define (base exponentiation)
  (cadr exponentation))

(define (exponent exponentiation)
  (caddr exponentation))

(define (exponentiation? x)
  (and (pair? x) (eq? '** (car x))))


(define (deriv exp var)
	(cond ((number? exp) 0)
		  ((variable? exp)
		   (if (same-variable? exp var) 1 0))
		  ((sum? exp)
		   (make-sum (deriv (addend exp) var)
				     (deriv (augend exp) var)))
		 ((product? exp)
	      (make-sum 
		   (make-product
		    (multiplier exp)
		    (deriv (multiplicand exp) var))
		   (make-product
			(deriv (multiplier exp) var)
			(multiplicand exp))))

                 ((exponentation? exp)
                  (let ((base (base exp))
                        (exponent (exponent exp)))
                    (cond ((= exponent 0) 0) ; derivative of 1 is 0
                          ((= exponent 1) (deriv base var))
                          (else 
                           (make-product
                            (make-product
                             exponent
                             (make-exponentation base  (- exponent 1)))
                            (deriv base var))))))
                 
		(else (error "unknown expression type: DERIV" exp))))


; Exercise 2.57
; Extend differentiation to handle sums and products of arbitrary numbers of two or more terms.
; (+ a b c)

(define (make-sum a1 a2) (list '+ a1 a2))
; this was the origfinal representation for a sum. since the inputs can include two or more terms then we have to change the
; selectors.

(define (addend s) (cadr s)) ; first term.
(define (augend s)
  (if (null? (cdddr s)) ; cdr of the cdr of the cdr. checks if there is more than two elements(not including the car which is +)
      (caddr s) ; if so, the augend is just the last term
      (cons '+ (cddr s)))) ; otherwise, we extract the list of remaining elmeents, and attaching the + symbol. 


; Exerice 2.58a
; Changing the deriv program to work with infix operators e.g., (x + (3 * (x + (y + 2))))

(define (=number? exp num)
	(and (number? exp) (= exp num)))

; sums
(define (make-sum a1 a2)
	(cond ((=number? a1 0) a2)
		  ((=number? a2 0) a1)
		  ((and (number? a1) (number? a2))
		    (+ a1 a2))
		  (else (list a1 '+ a2))))

(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))
(define (augend s)
  (caddr s)) ; (x + y) or (x + (3 + y)) car = x, cddr = (y) or ((3 + y)), eitherway we need car of cddr.

; products
(define (make-product m1 m2)
	(cond ((or (=number? m1 0) (=number? m2 0)) 0)
              ((=number? m1 1) m2)
              ((=number? m2 1) m1)
              ((and (number? m1) (number? m2))
               (* m1 m2))
              (else
               (list m1 '* m2))))


(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))
(define (multiplicand p) (caddr p))



; Exercise 2.58b

; Standard algerbraic notation like (x + 3 * (x + y + 2)).
; Drops unnecessary parantheses, and assumes multiplication is done before addition.
; this is different to 2.58 because the top level list not 3 element package anymore; + could be anywhere, so we need to scan

; case 1 (x + 3 * y).
; addend is the left side (x) -> need to clean up single elements
; augend is the right side (3 * y)

; case 2 (x * 3 * 5 + 5)
; addend is (x * 3 * 5)
; augent is (5) -> need to clean up single elements


; sums
(define (split-sum exp)
  (define (iter remaining acc)
    (cond ((null? remaining) #f)
          ((eq? (car remaining) '+)
           (cons (reverse acc) (cdr remaining))))
          (else
           (iter (cdr remaining) (cons (car remaining) acc))))

  (iter exp nil))

(define (sum? x)
  (and (pair? x) (pair? (split-sum x))))

(define (clean-up exp)
  (if (and (list? exp) (= (length exp) 1))
      (car exp)
      exp))

(define (addend s) (clean-up (car (split-sum s))))
(define (augend s) (clean-up (cdr (split-sum s))))


; multiplication - not associative, so dont scan.
; deriv dispatcher checks sum? first, so we dont change product? as it owuld have intercepted an exp which has a top-level +

(define (multiplier p) (clean-up (car p)))
(define (multiplicand p) (clean-up (cddr p)))
           


; exercise 2.59
; to union two sets, we assume we already have the union of cdr set 1 and set 2.
; so only join to join the car1 with the result
; to stop the recursion, we check if set1 is null, if so, return set2.

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        (else (adjoin-set (car set1) (union-set (cdr set1) set2)))))


; Exercise 2.60
; sets can now be internally represented as lists that can have duplicates
; {1, 2, 3} -> (2 3 2 1 3 2 2...)

; element-of-set? wouldn't change as we are still checking if a element is a member of a list. O(n).

; adjoin-set would change, as we don't need to worry about duplicates, which increases efficiency. This is O(1)
(define (adjoin-set x set)
  (cons x set))

; union-set wouldn't change as it is an abstraction that uses adjoin-set, and we already changed adjoin-set. O(n)

; intersection-set wouldn't change as it is an abstraction that uses element-of-set, and we already changed element-of-set. O(nm)

