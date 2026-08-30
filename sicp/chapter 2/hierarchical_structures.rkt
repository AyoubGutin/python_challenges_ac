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
;       - The recursive call then yields a result of ((2 1) 1)
;
; - Element 2 is a pair. (3 4) ... recursive calls yield (4 3)
;
; - Accumulating into result yields the deep reversed list. 


; Exercise 2.28

; Take in a tree, where the return value is the innermost elements (leaves), returned from left to right.

(define (fringe tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (fringe (car tree))
                      (fringe (cdr tree))))))
        



; ----------

; Exercise 2.29

; a object which hangs a weight or another binary mobile on its left and its right. Constructed from two branches
(define (make-mobile left right)
  (list left right))
; a object which has a length, with a structure (number = weight, or another mobile)
(define (make-branch length structure)
  (list length structure))


; selectors to return branches of a mobile
(define left-branch car)
(define right-branch cadr)
; selectors for the legnth and structure of a branch
(define branch-length car)
(define branch-structure cadr)


; mobile with branches. first branch is a brnahc with length 5, and a mobile of branches of length 5 and weight 10 x 2. second branch is a branch of len 20 and weight 30. total weight would be 50. three weights in total. left is nested, right is not.
(define y (make-mobile (make-branch 5 (make-mobile (make-branch 5 10) (make-branch 5 10))) (make-branch 20 30)))
y

(define (total-weight mobile)
  ; if branch-structure is a number, return the weight
  ; if branch-structure is a mobile,. then we recurivsely call

  (define (branch-weight branch)
    (let ((struct (branch-structure branch)))
          (if (pair? struct)
              (total-weight struct) ; assume total-weight will eventually get the right number when passing a mobile.
              struct))) ; base case - return number

  (+ (branch-weight (left-branch mobile)) (branch-weight (right-branch mobile)))) ; wishful thinking - we assume we have an abstracted function that gets the weight of each branch before we make one.

(total-weight y)

