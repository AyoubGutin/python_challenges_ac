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