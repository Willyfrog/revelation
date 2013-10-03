;; Author: Guillermo Vayá Pérez 
;; Mail: <guivaya@gmail.com>
;; @Driadan

(from [initial [initial-content]])

(defn html-tags [name value &optional attrs]
  (let [[attributes (if (none? attrs) ""
                        (+ " " (.join " "
                                      (list-comp (+ key "=\"" (.get attrs key) "\"") 
                                                 (key attrs)))))]
        [values (if (string? value) value
                    (.join "\n" value))]
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
                      &optional [charset "utf-8"] &optional [description ""]
                      &optional [theme "default"]]
  (kwapply (.format (initial-content))
           {
            "lang" language
            "author" author
            "title" title
            "description" description
            "theme" theme
            "charset" charset
            }))
