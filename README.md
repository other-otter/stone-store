# stone-store
```common-lisp
slow-snow kvdb based on package cl-store
;light-snow-solar-terms(2021-11-22)

;stone-store      = lock+key+version+value
;file-path-string = lock-number-string + key-number-string + time-number-string
;file-content     = the-value

;key_string = "example_string"
;key_number = hash(key_string)
;locknumber = key_number % 6661
;timenumber = time.time()
;theversion = str(timenumber)
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
## store-path
```common-lisp
;set directory path
;stored in "~/stone-store" by default
(stone-store:set-the-path "~/sto")

```

## store-lock
```common-lisp
;stone-store:*store-lock* is an array with 6661 locks
;when multiple written keys belong to the same lock
;only the code block occupying the lock can be written to the directory
```

## store-add
```common-lisp
;use the current time number as the version
(stone-store:store-add "abc" "0")

(stone-store:store-add "abc" 1)

(stone-store:store-add "abc" (list 2))

```

## store-set
```common-lisp
;function store-set change the value of the corresponding exist-version
;when need to set new key or key-version use function store-add
(stone-store:store-set "abc" 0 (cons 3 nil))

;version-string "the-time-number-string"
;version-number 0 is the first version, -1 is the last version, and so on
```

## store-get
```common-lisp
;get the value of key's version
;default is to get the last version
(stone-store:store-get "abc")

(stone-store:store-get "abc" 0)

(stone-store:store-get "abc" 1)

(stone-store:store-get "abc" -1)

```

## store-see
```common-lisp
;see all versions of the key
(stone-store:store-see "abc")

```

## store-del
```common-lisp
;delete the version of the key
(stone-store:store-del "abc" -1)

```

## store-end
```common-lisp
;merged version, only keep one version, 
;default is the last version of the existing version, also can specify the version
(stone-store:store-end "abc")

```

## update
```common-lisp
;use kv for table, reference content:
;https://docs.pingcap.com/tidb/v4.0/tidb-computing

;key-string ~~ value-from

;key-string-simple-example: "abc"
;key-string-format-example: "table-abc_index-123_row-456"

;;;;;;
;;tableID-1,indexID-2
;;;;;;
;0,abc,def,ghi
;1,t,nil,nil
;2,nil,t,nil
;3,nil,nil,t
;;;;;;

(sto:store-add (format nil "table-~A_index-~A_row-~A" 1 2 0) (list "abc" "def" "ghi"))
(sto:store-add (format nil "table-~A_index-~A_row-~A" 1 2 1) (list t nil nil))
(sto:store-add (format nil "table-~A_index-~A_row-~A" 1 2 2) (list nil t nil))
(sto:store-add (format nil "table-~A_index-~A_row-~A" 1 2 3) (list nil nil t))

(sto:store-get "table-1_index-2_row-1")  ;;(T NIL NIL)

(setf string-template "table-~A_index-~A_row-~A")
(sto:store-get (format nil string-template 1 2 2)) ;;(NIL T NIL)

(defun boolean-string (the-boolean)
  (if the-boolean
      "true"
      "null"))

(mapcar (lambda (a b) (cons a (boolean-string b)))  
  (sto:store-get (format nil "table-~A_index-~A_row-~A" 1 2 0))
  (sto:store-get (format nil "table-~A_index-~A_row-~A" 1 2 3)))  ;;(("abc" . "null") ("def" . "null") ("ghi" . "true"))
  
```

## usage
```common-lisp
;;nicknames 
;sto
;;parameter
;stone-store::*store-path*
;stone-store::*store-lock*
;;functions
;stone-store::start-store
;stone-store::main
;stone-store::get-the-time
;stone-store::set-the-path path-string
;stone-store::store-add key-string value-form
;stone-store::store-set key-string the-version value-form
;stone-store::store-get key-string the-version
;stone-store::store-see key-string
;stone-store::store-del key-string the-version
;stone-store::store-end key-string the-version
```

## more
```common-lisp
;https://github.com/skypher/cl-store
;https://privet-kitty.github.io/etc/uiop.html
;https://lispcookbook.github.io/cl-cookbook/files.html
;https://github.com/sionescu/bordeaux-threads/blob/master/apiv2/api-locks.lisp
;https://github.com/dlowe-net/local-time/blob/a177eb911c0e8116e2bfceb79049265a884b701b/src/local-time.lisp#L1122
```
