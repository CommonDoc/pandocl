(in-package :cl-user)
(defpackage pandocl
  (:use :cl)
  (:export ;; Interface
           :parse
           :emit
           :convert
           ;; Errors
           :pandocl-error
           :unsupported-format
           :unknown-file-extension))
(in-package :pandocl)

;;; Constants

(defparameter +supported-input-formats+
  (list :vertex :scriba)
  "A list of supported input formats.")

(defparameter +supported-output-formats+
  (list :html)
  "A list of supported output formats.")

(defparameter +format-class-map+
  (list :vertex 'vertex:vertex
        :scriba 'scriba:scriba
        :html 'common-html:html)
  "A plist of format names to classes.")

(defparameter +format-extension-map+
  (list (cons "tex" :vertex)
        (cons "scr" :scriba)
        (cons "html" :html))
  "A list of file extensions to format names.")

;;; Errors

(define-condition pandocl-error ()
  ()
  (:documentation "The base class of Pandocl-related errors."))

(define-condition unsupported-format (pandocl-error)
  ((format-name :reader format-name
                :initarg :format-name
                :type keyword
                :documentation "The name of the format."))
  (:report
   (lambda (condition stream)
     (format stream "Unsupported format: ~A." (format-name condition))))
  (:documentation "Signalled when a user-specified format is not known."))

(define-condition unknown-file-extension (pandocl-error)
  ((extension :reader extension
              :initarg :extension
              :type string
              :documentation "The file extension."))
  (:report
   (lambda (condition stream)
     (format stream "Unknown file extension: ~A." (extension condition))))
  (:documentation "Signalled when Pandocl tries to guess a file format from a
  file extension and fails."))

;;; Utilities

(defun guess-format (pathname)
  "Try to guess the CommonDoc format from a pathname, or signal
unknown-file-extension."
  (let ((extension (pathname-type pathname)))
    (or (assoc extension
               +format-extension-map+
               :test #'equalp)
        (error 'unknown-file-extension :extension extension))))

(defun check-supported-format (format-name list)
  (or (member format-name list)
      (error 'unsupported-format :format-name format-name)))

(defun check-supported-input-format (format-name)
  "If the input format is not supported, raise unsupported-format."
  (check-supported-format format-name +supported-input-formats+))

(defun check-supported-output-format (format-name)
  "If the output format is not supported, raise unsupported-format."
  (check-supported-format format-name +supported-output-formats+))

(defun find-format (format-name)
  "Find the class corresponding to a format name."
  (getf +format-class-map+ format-name))

;;; Interface

(defun parse (pathname &key format)
  "Parse a document from a file, optionally specifying an input format."
  (let ((format (or format (guess-format pathname))))
    (check-supported-input-format format)
    (let ((format-class (find-format format)))
      (common-doc.format:parse-document (make-instance format-class)
                                        pathname))))

(defun emit (document pathname &key format (if-exists :supersede)
                                 (if-does-not-exist :create))
  "Dump a document to a file, optionally specifying an output format."
  (let ((format (or format (guess-format pathname))))
    (check-supported-input-format format)
    (let ((format-class (find-format format)))
      (with-open-file (output-stream pathname
                                     :direction :output
                                     :if-exists if-exists
                                     :if-does-not-exist if-does-not-exist)
        (common-doc.format:emit-document (make-instance format-class)
                                         document
                                         output-stream))))
  document)

(defun convert (input-pathname output-pathname &key input-format
                output-format (if-exists :supersede) (if-does-not-exist :create))
  "Convert a file to another format."
  (emit (parse input-pathname :format input-format)
        output-pathname
        :format output-format
        :if-exists if-exists
        :if-does-not-exist if-does-not-exist))
