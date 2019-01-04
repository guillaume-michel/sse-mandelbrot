(in-package "MANDELBROT")

(macrolet ((define-stub (name)
             `(defun ,name (x y)
                (,name x y))))
  (define-stub f4+)
  (define-stub f4*)
  (define-stub f4-)
  (define-stub f4<=)
  (define-stub i4-)
  #+avx2
  (progn
    (define-stub f8+)
    (define-stub f8*)
    (define-stub f8-)
    ;;  (define-stub f8<=)
    (define-stub i8-))
  )

(defun f4-sign-mask (x)
  (f4-sign-mask x))

(defun f4-sign-all-zero (x)
  (f4-sign-all-zero x))

(deftype f4 ()
  '(simd-pack single-float))

(declaim (inline replicate-float))
(defun replicate-float (x)
  (%make-simd-pack-single x x x x))

#+avx2
(progn
  (defun f8-sign-mask (x)
    (f8-sign-mask x))

  (defun f8-sign-all-zero (x)
    (f8-sign-all-zero x))

  (deftype f8 ()
    '(simd-pack-256 single-float))

  (declaim (inline replicate-float-8))
  (defun replicate-float-8 (x)
    (%make-simd-pack-256-single x x x x x x x x))
)
