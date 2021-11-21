(asdf:defsystem :stone-store
     :description "slow kvdb based on pakcage cl-store"
     :version "0.0.1"
     :author "@other-otter"
     :depends-on (:cl-store
                  :bordeaux-threads)
     :components ((:file "package")
                  (:module code
                   :serial t
                   :components ((:file "stone-store")))))
