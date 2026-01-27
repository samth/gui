#lang racket/load

(module+ test
  (module config info
    (define lock-name "x-server")))

(require racket/gui)

(load-relative "editor.rktl")
(load-relative "paramz.rktl")
(load-relative "cache-image-snip-test.rktl")
(load-relative "windowing.rktl")

(require "./issue-119.rkt")
