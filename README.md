# stone-store
```common-lisp
slow-snow kvdb based on package cl-store

;light-snow-solar-terms(2021-11-22)

;lock+key+version+value
;file-path-string = lock-number-string + key-number-string + time-number-string
;file-content     = the-value

;the_key    = "example_string"
;key_number = hash(the_key)
;locknumber = key_number % 6661
;timenumber = time.time()
```

## load-package
```common-lisp
(load "~/quicklisp/setup.lisp")

(ql:quickload :stone-store)

```

## start-store
```common-lisp
;start *store-lock* in memory
(stone-store:start-store)

;or use package main function
(sto:main)

```

## store-lock
```common-lisp
;stone-store:*store-lock* is an array with 6661 locks
;when multiple written keys belong to the same lock
;only the code block occupying the lock can be written to the directory

```

## store-add
```common-lisp
;
```

## store-set
```common-lisp
;
```

## store-get
```common-lisp
;
```

## store-see
```common-lisp
;
```

## store-del
```common-lisp
;
```

## store-end
```common-lisp
;
```

## usage
```common-lisp
;store-add key-string value-form
;
```

## more
```common-lisp
;
```
