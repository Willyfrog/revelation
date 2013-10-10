;; Author: Guillermo Vayá Pérez 
;; Mail: <guivaya@gmail.com>
;; @Driadan

(import [initial [initial-content]])
(import [datetime [date]])
(import urllib)
(import os)


;; Only useful while there is no string method in hy
(defn string [x] (if-python2 (unicode x) (str x)))

(setv *indentation* "  ") ;; set indentation to 2 spaces

(defn -unpack-attributes [attributes]
  "From a dictionary get a list of tag attributes"
  (+ " " (.join " "
                (list-comp (+ key "=\"" (string (.get attributes key)) "\"") 
                           (key attributes)))))

(defn html-tags [name &optional value attrs]
  "Create an html tag with name, value and a dictionary of attributes"
  (let [[attributes (if (none? attrs) ""
                        (-unpack-attributes attrs))]
        [values (cond
                 ((none? value) None)
                 ((string? value) value)
                 (True (.join "\n" value)))]

        [base-string (if (none? value)
                       "<{name}{attributes} />"
                       "<{name}{attributes}>{value}</{name}>")]]
    (kwapply 
     (.format base-string)
     {"name" name "value" values "attributes" attributes})))

(defn -section [content  &optional attrs]
  "Do a new slide. Nest it if you want to do a vertical slide"
  (html-tags "section" content attrs))

;; (defmacro -check-slide [slide-content]
;;   (while (or  (not  (empty? slide-content)) (string? slide-content))
;;     (when (= "horizontal-slide" (car slide-content))
;;       (raise (ValueError "There can't be an slide inside an slide")))
;;     (setv slide-content (car (cdr slide-content)))))

(defn horizontal-slide [content &optional attrs vertical-slides]
  (let [[subsections (if (none? vertical-slides) []
                         (list-comp (-section slide) [slide vertical-slides]))]]
    (.insert subsections 0 content)
    (-section subsections attrs)))

(defn title-I [content &optional attrs]
  "Write the title of the slide"
  (html-tags "h1" content attrs))

(defn title-II [content &optional attrs]
  "Write some second level title in the slide"
  (html-tags "h2" content attrs))

(defn title-III [content &optional attrs]
  "Write a third level title in the slide"
  (html-tags "h3" content attrs))

(defn text [content &optional attrs]
  (html-tags "p" content attrs))

(defn tiny-text [content &optional attrs]
  "Write some tiny text"
  (paragraph (html-tags "small" content attrs)))

(defn link [url content &optional attrs]
  (let [[attributes {"href" url}]]
    (when (not (none? attrs))
      (.update attributes attrs))
    (html-tags "a" content attributes)))

(defn author-note [content &optional attrs]
  (let [[attributes {}]
        [class (if (or (none? attrs) (= (.get attrs "class" false) false)) 
                 "notes"
                 (+ (.get attrs "class") " notes"))]]
    (unless (none? attrs)
      (.update attributes attrs))
    (assoc attributes "class" class)
    (html-tags "aside" content attributes)))

(defn meta-data [attrs]
  (html-tags "meta" None attrs))

(defn meta-charset [character-set]
  (meta-data {"charset" character-set}))

(defn index [author title content &optional [language "en"] 
                      [charset "utf-8"] [description ""] [theme "default"]]
  "Private to build the index"
  (kwapply (.format (initial-content))
           {
            "lang" language
            "author" author
            "title" title
            "description" description
            "theme" theme
            "charset" charset
            "content" content
            }))

(defn -get-zipped-reveal-js [&optional [version "2.5.0"] [extension "zip"] [path "/tmp"]]
  (let [[filename (kwapply (.format "{date}-reveal-{version}.{extension}") 
                            {"extension" extension 
                                         "date" (string (.today date))
                                         "version" version})]
        [file-path (os.path.join path filename)]
        [url (kwapply (.format "https://github.com/hakimel/reveal.js/archive/{version}.{extension}") 
                      {"version" version "extension" extension})]]
    (with [f (open file-path "w")]
          (.write f (.read (.urlopen urllib url))))
    file-path))

(defn build-presentation [author title content &optional [language "en"] 
                      [charset "utf-8"] [description ""] [theme "default"] [reveal-version "2.5.0"]]
  "download stuff, decompress it, substitute index"
  false)

(defn serve-presentation [&optional [port 8000]]
  "launch a minimal flask app serving the presentation"
  false)
