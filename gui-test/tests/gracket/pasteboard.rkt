#lang racket/gui

(module+ test
  (module config info
    (define lock-name "x-server")))

;; GH issue #18
(send the-clipboard set-clipboard-string "x" 0)
(send (new pasteboard%) paste)(send (new pasteboard%) paste)
