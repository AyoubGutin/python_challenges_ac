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


; Exercixe 2.46

(define (make-vect x y)
  (cons x y))

(define (xcor-vect v) (car v))

(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect v s)
  (make-vect (* s (xcor-vect v)) (* s (ycor-vect v))))



; Exerecise 2.47
(define (make-frame1 origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame1 v)
  (car v))

(define (edge1-frame1 v)
  (cadr v))

(define (edge2-frame1 v)
  (car (cdr (cdr v))))


(define (make-frame2 origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame2 v)
  (car v))

(define (edge1-frame2 v)
  (cadr v))

(define (edge2-frame2 v)
  (cdr (cdr v)))
  

; Exercise 2.48
(define (make-segment start end)
  (cons start end))

(define (start-segment s)
  (car s))

(define (end-segment s)
  (cdr s))



; Exercixe 2.49
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) 
         (start-segment segment))
        ((frame-coord-map frame) 
         (end-segment segment))))
     segment-list)))

; outline of the frame
(define outline-painter
  (segments->painter
    (list
      (make-segment (make-vect 0.0 0.0) (make-vect 1.0 0.0))
      (make-segment (make-vect 1.0 0.0) (make-vect 1.0 1.0))
      (make-segment (make-vect 1.0 1.0) (make-vect 0.0 1.0))
      (make-segment (make-vect 0.0 1.0) (make-vect 0.0 0.0)))))

; Draws an x
(define x-painter
  (segments->painter
   (list
    (make-segment (make-vect 0.0 0.0) (make-vect 1.0 1.0))
    (make-segment (make-vect 0.0 1.0) (make-vect 1.0 0.0)))))

; Draws a diamond
(define diamond-painter
  (segments->painter
   (list
    (make-segment (make-vect 0.0 0.5) (make-vect 0.5 1.0))
    (make-segment (make-vect 0.5 1.0) (make-vect 1.0 0.5))
    (make-segment (make-vect 1.0 0.5) (make-vect 0.5 0.0))
    (make-segment (make-vect 0.5 0.0) (make-vect 0 0.5)))))



; Exercise 2.50
(define (transform-painter 
         painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame new-origin
                  (sub-vect (m corner1) 
                            new-origin)
                  (sub-vect (m corner2)
                            new-origin)))))))

; flips a painter horizontally
(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate-180 painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 0.0)))

(define (rotate-270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(define (rotate-90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

; Exercixe 2.51
(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left  (transform-painter 
                        painter1
                        (make-vect 0.0 0.0)
                        split-point
                        (make-vect 0.0 1.0)))
          (paint-right (transform-painter
                        painter2
                        split-point
                        (make-vect 1.0 0.0)
                        (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point))
          (paint-top
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))

(define (below-2 painter1 painter2)
  (rotate-90 (beside (flip-270 painter1)
                     (flip-270 painter2))))

