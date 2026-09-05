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

  (+ (branch-weight (left-branch mobile)) (branch-weight (right-branch mobile)))) ; wishful thinking - we assume we have an abstracted function that gets the weight of each branch before we make one.

(define (branch-weight branch)
  (let ((struct (branch-structure branch)))
    (if (pair? struct)
        (total-weight struct)
        struct)))

; a mobile is balanced if:
; Length(left) * Weight(left) = Length(right) * Weight(right). -> Weight would be recurivsely calculated downwards of that specific branch.
; sub mobiles are balanced.

(define (balanced? mobile)
  (define (branch-balanced? branch)
    (let ((struct (branch-structure branch)))
      (if (pair? struct)
          (balanced? struct)
          #t)))
  
    (let ((lb (left-branch mobile))
          (rb (right-branch mobile)))
      (and (= (* (branch-length lb) (branch-weight lb)) (* (branch-length rb) (branch-weight rb)))
          (branch-balanced? lb)
          (branch-balanced? rb))))

(balanced? y)
  
  

#lang sicp

; -- helpers 
(define (square x) (* x x))

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)))))

(define (square-list-m items)
  (map square items))


; Exercise 2.30

; Define a procedure square-tree analogous to square-list.

; directly without map
(define (square-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (square tree))
        (else
         (cons (square-tree (car tree)) (square-tree (cdr tree))))))

; with map
(define (square-tree-map tree)
  (map (lambda (sub-tree)
         (if (not (pair? sub-tree))
             (square sub-tree)
             (square-tree-map sub-tree)))
       tree))

; Exercixe 2.31

; Abstract 2.30 to produce tree-map

(define (tree-map proc tree)
  (map (lambda (sub-tree)
         (if (not (pair? sub-tree))
             (proc sub-tree)
             (tree-map proc sub-tree)))
       tree))

(define (square-tree-abstract tree)
  (tree-map square tree))

(square-tree-abstract (list 3 4 (list 4 5 6) 23))


; 2.32

; set -> distinct elements
; set of all subsets of the set as a list of lists
; (1 2 3) -> set of all subsets = (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

(define (subset s)
  (if (null? s)
      (list nil)
      (let ((rest (subset (cdr s))))
        (append rest (map
                      (lambda (sub-tree)
                        (cons (car s) sub-tree))
                      rest)))))

; Explanation
; we assume (rest (subset (cdr s))) gets all the subsets for the cdr of s.
; once assumed, we note down the result of what this would be. it is half of the answer.
; to get the other half, we cons the car of s to every element of s, which would be a map function.

; trace:
; (subset ( 1 2 3))
; wind down the call stack to base case: (subset nil).
; wind up once the call stack. (subset = 3) -> (append (nil) ((3))) = ( () (3))
; wind up again (subset 2 3) -> rest = ( () (3) ). (map ... ) -> ((2) (2 3)). (append rest mapped) = ( rest mapped ).

(define (sum-odd-squares tree)
	(cond ((null? tree) 0)
		  ((not (pair? tree))
			  (if (odd? tree) 
				  (square tree) 
				  0))
		  (else
			  (+ (sum-odd-squares (car tree))
				 (sum-odd-squares (cdr tree))))))




(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))

(define (reverse sequence)
  (accumulate (lambda (x y) (append y (list x))) nil sequence))

(reverse (list 3 4 5))
	


; redefinition of count-leaves using accumulate.
; maps through a deep list, replacing each leave with 1, to be counted using accumulate.
(define (count-leaves t)
  (accumulate +
              0
              (map (lambda (subtree)
                     (if (not (pair? subtree))
                         1
                         (count-leaves subtree)))
                   t)))



; this procedure needs to combine sequences of a sequence, like matrix addition
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(accumulate-n + 0 (list (list 1 2 3 4) (list 5 6 7 8)))


; dot product of vectors, represented as sequence of numbers
(define (dot-product v w) (accumulate + 0 (map * v w)))

; multiplication of matrix and vector. 
(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v))
      m))

(matrix-*-vector (list (list 1 2) (list 3 4)) (list 5 10))

; transpose of matrix
(define (transpose mat)
  (accumulate-n cons nil (list (list 1 2 3) (list 4 5 6))))


(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (map (lambda (col) (dot-product row col)) cols)) m)))



; flat list of integers from low to high. tail-recursive, counting down from high to low to build list in asc order.
(define (enumerate-interval low high)
  (define (iter current acc)
    (if (< current low)
        acc
        (iter (- current 1) (cons current acc))))
  (iter high nil))

(enumerate-interval 1 5)



; ---------



; Exercise 2.40

; unique-pairs, given integer n, genrate pairs (i, j), with 1 <= j < i <= n.
; it calls on flatmap, which uses accumulate and append to make a flat sequence from our nested map. 

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (unique-pairs n)
  (flatmap (lambda (i) (map (lambda (j) (list i j)) (enumerate-interval 1 (- i 1)))) (enumerate-interval 1 n)))

(unique-pairs 5)


; Exercise 2.41
; Ordered triples of distinct positive integers, i, j, k, <= n that sum to a given integer s.

(define (filter predicate seq)
  (cond ((null? seq) nil)
        ((predicate (car seq)) (cons (car seq) (filter predicate (cdr seq))))
        (else
         (filter predicate (cdr seq)))))

  
(define (unique-triples n)
  (flatmap (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                             (enumerate-interval 1 (- j 1)))) 
                      (enumerate-interval 1 (- i 1))))         
           (enumerate-interval 1 n)))

(define (triple-sum-s n s)
  (filter (lambda (triple) (= (accumulate + 0 triple) s)) (unique-triples n)))

(triple-sum-s 6 10)




  
  