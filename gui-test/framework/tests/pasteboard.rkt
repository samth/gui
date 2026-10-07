#lang racket/base
(require "test-suite-utils.rkt"
         rackunit
         framework
         racket/gui/base
         racket/class)

(define (test-creation the-frame% the-editor% name)
  (check-not-exn
   (λ ()
     (define c (make-channel))
     (queue-callback
      (λ ()
        (define f
          (new (class the-frame%
                 (define/override (get-editor%) the-editor%)
                 (super-new))))
        (preferences:set 'framework:exit-when-no-frames #f)
        (send f show #t)
        (channel-put c f)))
     (define f (channel-get c))
     ;; Close `f` itself, not the focus window: DrDr runs all tests on one
     ;; X display, so another test's window may have the focus. The #f
     ;; priority lets the eventspace first handle the events from showing `f`.
     (queue-callback
      (λ ()
        (send f close)
        (channel-put c (void)))
      #f)
     (channel-get c))))

(define (run-tests)
  (test-creation frame:editor%
                 (editor:basic-mixin pasteboard%)
                 'editor:basic-mixin-creation)
  (test-creation frame:editor%
                 pasteboard:basic%
                 'pasteboard:basic-creation)

  (test-creation frame:editor%
                 (editor:file-mixin pasteboard:keymap%)
                 'editor:file-mixin-creation)
  (test-creation frame:editor%
                 pasteboard:file%
                 'pasteboard:file-creation)

  (test-creation frame:editor%
                 (editor:backup-autosave-mixin pasteboard:file%)
                 'editor:backup-autosave-mixin-creation)
  (test-creation frame:editor%
                 pasteboard:backup-autosave%
                 'pasteboard:backup-autosave-creation)

  (test-creation frame:pasteboard%
                 (editor:info-mixin pasteboard:backup-autosave%)
                 'editor:info-mixin-creation)
  (test-creation frame:pasteboard%
                 pasteboard:info%
                 'pasteboard:info-creation))

(void
 (yield
  (thread
   run-tests)))

;; this seems to be needed so that the autosave timer's
;; weak boxes empty, so the autosave timer turns itself
;; off, so that racket exits
(void
 (thread
  (λ ()
    (for ([i (in-range 10)])
      (collect-garbage)
      (sleep 1)))))
