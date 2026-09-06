#lang sicp
; Exercise 2.42

(define (filter predicate seq)
  (cond ((null? seq) nil)
        ((predicate (car seq)) (cons (car seq) (filter predicate (cdr seq))))
        (else
         (filter predicate (cdr seq)))))

; assume (k -1) queens are placed in a chess board. place the kth queen (last column), in each row, and filter for the positions that are not check.

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board) ; if k = 0, then init a list that is an empty board
        (filter 
         (lambda (positions)
           (safe? k positions))
         (flatmap
          (lambda (rest-of-queens) ; way to place k-1 queens in the first k-1 columns
            (map (lambda (new-row) ; proposed row to place the queen for kth column
                   (adjoin-position
                    new-row
                    k
                    rest-of-queens))
                 (enumerate-interval
                  1
                  board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(define empty-board nil)

(define (adjoin-position row column set)
  (cons (list row column) set))

; proc to check if a queen is safe with respective to other queens
(define (safe? k positions)
  (let ((row (car (car positions)))
        (column (cadr (car positions))))

    (define (is-check compare-queen)
      (cond ((= (abs (- row (car compare-queen))) (abs (- column (cadr compare-queen)))) #t)
            ((= row (car compare-queen)) #t)
            (else
             #f)))

    (null? (filter (lambda (other-queen) (is-check other-queen)) (cdr positions)))))







; -- recursion practice

; sum-positives, takes list of numbers, returns numbers that are greater than 0

(define (sum-positives num-list)
  (cond ((null? num-list) 0) ; base-case
        ((> (car num-list) 0) (+ (car num-list) (sum-positives (cdr num-list)))) ; wishful thinking, we assume that recursive call already has the sum of > 0 and just add onto it.
        (else
         (sum-positives (cdr num-list)))))

(define (censor words)
  (cond ((null? words) nil)
        ((eq? (car words) 'bad) (cons 'beep (censor (cdr words))))
        (else
         (cons (car words) (censor (cdr words))))))
    
    
 ; Exercise 2.45

; Right split and up split can be abstracted as higher order operations, via the split procedure

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split (painter (- n 1)))))

        (beside painter (below smaller smaller)))))


; op1 = outer combiner, op2 = inner combiner.
(define (split op1 op2)
  (lambda (painter)
    (if (= n 0)
        painter
        (let ((smaller (split (painter (-n 1)))))

          (op1 painter (op2 smaller smaller))))))
