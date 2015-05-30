(defsystem pandocl
  :author "Fernando Borretti <eudoxiahp@gmail.com>"
  :maintainer "Fernando Borretti <eudoxiahp@gmail.com>"
  :license "MIT"
  :version "0.1"
  :homepage ""
  :bug-tracker ""
  :source-control (:git "")
  :depends-on (:common-doc
               :common-doc-contrib
               :vertex
               :scriba
               :parenml
               :thorn
               :common-html)
  :components ((:module "src"
                :serial t
                :components
                ((:file "pandocl"))))
  :description "A universal document converter."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op pandocl-test))))
