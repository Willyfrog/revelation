;; Author: Guillermo Vayá Pérez 
;; Mail: <guivaya@gmail.com>
;; @Driadan

(import [initial [initial-content]])

(defn string [x] (if-python2 (unicode x) (str x)))

(defn -unpack-attributes [attributes]
  (+ " " (.join " "
                (list-comp (+ key "=\"" (string (.get attributes key)) "\"") 
                           (key attributes)))))

(defn html-tags [name &optional value attrs]
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
        {"name" name 
         "value" values 
         "attributes" attributes})))

(defn section [content  &optional attrs]
  "Do a new slide. Nest it if you want to do a vertical slide"
  (html-tags "section" content attrs))

(defn title [content &optional attrs]
  "Write the title of the slide"
  (html-tags "h1" content attrs))

(defn title-2 [content &optional attrs]
  "Write some title in the slide"
  (html-tags "h2" content attrs))

(defn title-3 [content &optional attrs]
  "Write a title in the slide"
  (html-tags "h3" content attrs))

(defn paragraph [content &optional attrs]
  (html-tags "p" content attrs))

(defn tiny [content &optional attrs]
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

(defn generate-index [author title content &optional [language "en"] 
                      [charset "utf-8"] [description ""] [theme "default"]]
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
