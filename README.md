# Pandocl

A document converter built on [CommonDoc][cdoc].

# Usage

## Converting

The `convert` function takes two required arguments: The pathname of the input
and the pathname of the output. Two optional keyword arguments, `:input-format`
and `:output-format`, can be used to specify the format when the pathname is not
enough to guess. It returns the parsed document.

```lisp
CL-USER> (pandocl:convert #p"input.tex" #p"output.html")
#<COMMON-DOC:DOCUMENT "My Document">

CL-USER> (pandocl:emit #p"input.tex" #p"output.html"
                       :input-format :vertex
                       :output-format :html)
#<COMMON-DOC:DOCUMENT "My Document">
```

## Parsing

The `parse` function takes a pathname and optionally an input format (Otherwise
it guesses it from the pathname) and returns a CommonDoc document.

```lisp
CL-USER> (pandocl:parse #p"path/to/doc.tex")
#<COMMON-DOC:DOCUMENT "My Document">

CL-USER> (pandocl:parse #p"path/to/doc.tex" :format :vertex)
#<COMMON-DOC:DOCUMENT "My Document">
```

## Emitting

The `emit` function takes a document, a pathname to write it to, and optionally
a format for the output (Otherwise it tries to guess from the pathname). It
takes an extra two keyword arguments, `:if-exists` and `:if-does-not-exist`,
which control behaviour when opening the file (See [with-open-file][w-o-f]). The
function returns the document.

```lisp
CL-USER> (pandocl:emit doc #p"path/to/output.html")
#<COMMON-DOC:DOCUMENT "My Document">

CL-USER> (pandocl:emit doc #p"path/to/output.html" :format :html)
#<COMMON-DOC:DOCUMENT "My Document">
```

# Formats

## Supported

Supported input formats:

* [`:vertex`](https://github.com/CommonDoc/vertex)
* [`:scriba`](https://github.com/CommonDoc/scriba)

Supported output formats:

* [`:html`](https://github.com/CommonDoc/common-html)

## File extensions

When Pandocl tries to guess which format to use from a pathname type, it uses
the following rules:

* `.tex`: VerTeX
* `.scr`: Scriba
* `.html`: HTML

[cdoc]: https://github.com/CommonDoc/common-doc
[w-o-f]: http://www.lispworks.com/documentation/HyperSpec/Body/m_w_open.htm#with-open-file

# License

Copyright (c) 2015 Fernando Borretti

Licensed under the MIT License.
