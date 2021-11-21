(in-package :cl-user)

(defpackage #:stone-store
    (:use :cl)
    (:nicknames :sto)
    (:export    *store-path*
                *store-lock*
                start-store
                main
                get-the-time
                set-the-path
                store-add
                store-set
                store-get
                store-see
                store-del ))
