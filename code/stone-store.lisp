(in-package :stone-store)

(defvar *store-path* "~/stone-store")
(defvar *store-lock* (make-array 6661))

(defun start-store ()
    (loop for i from 0 to 6660 do 
        (setf (aref *store-lock* i) (bt:make-lock))))

(defun main ()
    (start-store))

(defun get-the-time () ;second-second
    #+sbcl
    (multiple-value-bind (a b c) (sb-unix:unix-gettimeofday) 
        (format nil "~d~6,'0d" b c))
    #-sbcl
    (multiple-value-bind (the-second the-minute the-hour the-day the-month the-year) (get-decoded-time) 
        (format nil "~a-~2,'0d-~2,'0dT~2,'0d:~2,'0d:~2,'0dZ" the-year the-month the-day the-hour the-minute the-second)))

(defun set-the-path (path-string)
    (setf *menu-path* path-string))

(defun store-add (key-string the-value)
    (let* ( (key-number         (sxhash key-string))
            (key-number-string  (format nil "~20,'0d" key-number))
            (lock-number        (mod key-number 6661))
            (lock-string        (format nil "~4,'0d" lock-number))
            (time-string        (get-the-time))
            (file-menu          (format nil "~A/~A/~A/" *store-path* lock-string key-number-string))
            (file-path          (format nil "~A~A" file-menu time-string)))
        (progn
            (ensure-directories-exist file-menu)
            (bt:with-lock-held ((aref *store-lock* lock-number))
                (cl-store:store the-value file-path)))))

(defun store-set (key-string the-version the-value)
    (let* ( (key-number         (sxhash key-string))
            (key-number-string  (format nil "~20,'0d" key-number))
            (lock-number        (mod key-number 6661))
            (lock-string        (format nil "~4,'0d" lock-number))
            (file-menu          (format nil "~A/~A/~A/" *store-path* lock-string key-number-string)))
        (if (stringp the-version)
            (let ((file-path (format nil "~A~A" file-menu the-version)))
                (progn
                    (ensure-directories-exist file-menu)
                    (bt:with-lock-held ((aref *store-lock* lock-number))
                        (cl-store:store the-value file-path))))
            (if (numberp the-version)
                (let ((file-list (uiop:directory-files file-menu)))
                    (if (>= the-version 0)
                        (bt:with-lock-held ((aref *store-lock* lock-number))
                            (cl-store:store the-value (nth the-version file-list)))
                        (bt:with-lock-held ((aref *store-lock* lock-number))
                            (cl-store:store the-value (nth (1- (abs the-version)) (reverse file-list))))))
                nil))))

(defun store-get (key-string &optional (the-version -1))
    (let* ( (key-number         (sxhash key-string))
            (key-number-string  (format nil "~20,'0d" key-number))
            (lock-number        (mod key-number 6661))
            (lock-string        (format nil "~4,'0d" lock-number))
            (file-menu          (format nil "~A/~A/~A/" *store-path* lock-string key-number-string)))
        (if (uiop:directory-exists-p file-menu)
            (if (stringp the-version)
                (let ((file-path (format nil "~A~A" file-menu the-version)))
                    (cl-store:restore file-path))
                (if (numberp the-version)
                    (let ((file-list (uiop:directory-files file-menu)))
                        (if (>= the-version 0)
                            (cl-store:restore (nth the-version file-list))
                            (cl-store:restore (nth (1- (abs the-version)) (reverse file-list)))))
                    nil)) 
            nil)))

(defun store-see (key-string)
    (let* ( (key-number         (sxhash key-string))
            (key-number-string  (format nil "~20,'0d" key-number))
            (lock-number        (mod key-number 6661))
            (lock-string        (format nil "~4,'0d" lock-number))
            (file-menu          (format nil "~A/~A/~A/" *store-path* lock-string key-number-string)))
        (uiop:directory-files file-menu)))

(defun store-del (key-string the-boolean the-version)
    (let* ( (key-number         (sxhash key-string))
            (key-number-string  (format nil "~20,'0d" key-number))
            (lock-number        (mod key-number 6661))
            (lock-string        (format nil "~4,'0d" lock-number))
            (file-menu          (format nil "~A/~A/~A/" *store-path* lock-string key-number-string)))
        (if the-boolean
            (uiop:delete-directory-tree (uiop:physicalize-pathname file-menu) :validate t :if-does-not-exist :ignore)
            (if (stringp the-version)
                (let ((file-path (format nil "~A~A" file-menu the-version)))
                    (uiop:delete-file-if-exists file-path))
                (if (numberp the-version)
                    (let ((file-list (uiop:directory-files file-menu)))
                        (if (>= the-version 0)
                            (uiop:delete-file-if-exists (nth the-version file-list))
                            (uiop:delete-file-if-exists (nth (1- (abs the-version)) (reverse file-list)))))
                    nil))))) 
