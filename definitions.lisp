(defpackage "MANDELBROT"
  (:use "CL" "SB-EXT" "SB-C"))

(in-package "MANDELBROT")

(defknown (f4+ f4* f4-) ((simd-pack single-float) (simd-pack single-float))
    (simd-pack single-float)
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(defknown f4<= ((simd-pack single-float) (simd-pack single-float))
    (simd-pack (signed-byte 32))
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(defknown i4- ((simd-pack (signed-byte 32)) (simd-pack (signed-byte 32)))
    (simd-pack (signed-byte 32))
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(defknown f4-sign-mask (simd-pack) (unsigned-byte 4)
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(defknown f4-sign-all-zero (simd-pack) boolean
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

;; AVX2
#+avx2
(progn
  (defknown (f8+ f8* f8-) ((simd-pack-256 single-float) (simd-pack-256 single-float))
      (simd-pack-256 single-float)
      (movable flushable always-translatable)
    :overwrite-fndb-silently t)

  (defknown f8<= ((simd-pack-256 single-float) (simd-pack-256 single-float))
      (simd-pack-256 (signed-byte 32))
      (movable flushable always-translatable)
    :overwrite-fndb-silently t)

  (defknown i8- ((simd-pack-256 (signed-byte 32)) (simd-pack-256 (signed-byte 32)))
      (simd-pack-256 (signed-byte 32))
      (movable flushable always-translatable)
    :overwrite-fndb-silently t)

  (defknown f8-sign-mask (simd-pack-256) (unsigned-byte 4)
      (movable flushable always-translatable)
    :overwrite-fndb-silently t)

  (defknown f8-sign-all-zero (simd-pack-256) boolean
      (movable flushable always-translatable)
    :overwrite-fndb-silently t)
)
