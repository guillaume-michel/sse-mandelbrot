(in-package "SB-VM")

(define-vop (mandelbrot::f4+)
  (:translate mandelbrot::f4+)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r)
         (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (single-sse-reg)))
  (:result-types simd-pack-single)
  (:generator 4
    (cond ((location= r y)
           (inst addps y x))
          (t
           (move r x)
           (inst addps r y)))))

(define-vop (mandelbrot::f4*)
  (:translate mandelbrot::f4*)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r)
         (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (single-sse-reg)))
  (:result-types simd-pack-single)
  (:generator 4
    (cond ((location= r y)
           (inst mulps y x))
          (t
           (move r x)
           (inst mulps r y)))))

(define-vop (mandelbrot::f4-)
  (:translate mandelbrot::f4-)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r) (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (single-sse-reg) :from (:argument 0)))
  (:result-types simd-pack-single)
  (:generator 4
    (move r x)
    (inst subps r y)))

(define-vop (mandelbrot::f4<=)
  (:translate mandelbrot::f4<=)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r) (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (int-sse-reg) :from (:argument 0)))
  (:result-types simd-pack-int)
  (:generator 4
    (move r x)
    (inst cmpps :le r y)))

(define-vop (mandelbrot::i4-)
  (:translate mandelbrot::i4-)
  (:policy :fast-safe)
  (:args (x :scs (int-sse-reg) :target r) (y :scs (int-sse-reg)))
  (:arg-types simd-pack-int simd-pack-int)
  (:results (r :scs (int-sse-reg) :from (:argument 0)))
  (:result-types simd-pack-int)
  (:generator 4
    (move r x)
    (inst psubd r y)))

(define-vop (mandelbrot::f4-sign-mask)
  (:translate mandelbrot::f4-sign-mask)
  (:policy :fast-safe)
  (:args (x :scs (int-sse-reg single-sse-reg double-sse-reg)))
  (:arg-types simd-pack)
  (:results (r :scs (unsigned-reg)))
  (:result-types unsigned-num)
  (:generator 4
    (inst movmskps r x)))

(define-vop (mandelbrot::f4-sign-all-zero)
  (:translate mandelbrot::f4-sign-all-zero)
  (:policy :fast-safe)
  (:args (x :scs (int-sse-reg single-sse-reg double-sse-reg)))
  (:arg-types simd-pack)
  (:temporary (:sc unsigned-reg) bits)
  (:conditional :z)
  (:generator 4
    (inst movmskps bits x)
    (inst test bits bits)))

;; AVX2
#+avx2
(progn
  (define-vop (mandelbrot::f8+)
    (:translate mandelbrot::f8+)
    (:policy :fast-safe)
    (:args (x :scs (single-avx2-reg) :target r)
           (y :scs (single-avx2-reg)))
    (:arg-types simd-pack-256-single simd-pack-256-single)
    (:results (r :scs (single-avx2-reg)))
    (:result-types simd-pack-256-single)
    (:generator 4
                (inst vaddps r x y)))

  (define-vop (mandelbrot::f8*)
    (:translate mandelbrot::f8*)
    (:policy :fast-safe)
    (:args (x :scs (single-avx2-reg) :target r)
           (y :scs (single-avx2-reg)))
    (:arg-types simd-pack-256-single simd-pack-256-single)
    (:results (r :scs (single-avx2-reg)))
    (:result-types simd-pack-256-single)
    (:generator 4
                (inst vmulps r x y)))

  (define-vop (mandelbrot::f8-)
    (:translate mandelbrot::f8-)
    (:policy :fast-safe)
    (:args (x :scs (single-avx2-reg) :target r) (y :scs (single-avx2-reg)))
    (:arg-types simd-pack-256-single simd-pack-256-single)
    (:results (r :scs (single-avx2-reg) :from (:argument 0)))
    (:result-types simd-pack-256-single)
    (:generator 4
                (inst vsubps r x y)))

;; (define-vop (mandelbrot::f8<=)
;;   (:translate mandelbrot::f8<=)
;;   (:policy :fast-safe)
;;   (:args (x :scs (single-avx2-reg) :target r) (y :scs (single-avx2-reg)))
;;   (:arg-types simd-pack-256-single simd-pack-256-single)
;;   (:results (r :scs (int-avx2-reg) :from (:argument 0)))
;;   (:result-types simd-pack-256-int)
;;   (:generator 4
;;     (inst vcmpps :le r x y)))

  (define-vop (mandelbrot::i8-)
    (:translate mandelbrot::i8-)
    (:policy :fast-safe)
    (:args (x :scs (int-avx2-reg) :target r) (y :scs (int-avx2-reg)))
    (:arg-types simd-pack-256-int simd-pack-256-int)
    (:results (r :scs (int-avx2-reg) :from (:argument 0)))
    (:result-types simd-pack-256-int)
    (:generator 4
                (inst vpsubd r x y)))

  (define-vop (mandelbrot::f8-sign-mask)
    (:translate mandelbrot::f8-sign-mask)
    (:policy :fast-safe)
    (:args (x :scs (int-avx2-reg single-avx2-reg double-avx2-reg)))
    (:arg-types simd-pack-256)
    (:results (r :scs (unsigned-reg)))
    (:result-types unsigned-num)
    (:generator 4
                (inst vmovmskps r x)))

  (define-vop (mandelbrot::f8-sign-all-zero)
    (:translate mandelbrot::f8-sign-all-zero)
    (:policy :fast-safe)
    (:args (x :scs (int-avx2-reg single-avx2-reg double-avx2-reg)))
    (:arg-types simd-pack-256)
    (:temporary (:sc unsigned-reg) bits)
    (:conditional :z)
    (:generator 4
                (inst vmovmskps bits x)
                (inst test bits bits)))
)
