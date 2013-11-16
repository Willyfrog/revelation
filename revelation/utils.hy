;; Author: Guillermo Vayá Pérez 
;; Mail: <guivaya@gmail.com>
;; @Willyfrog_
;; Sumary: Utilities to ease the presentation

(import [datetime [date]])
(import urllib)
(import os)

;; Only useful while there is no string method in hy
(defn string [x] (if-python2 (unicode x) (str x)))

(defn -get-zipped-reveal-js [&optional [version "2.5.0"] [extension "zip"] [path "/tmp"]]
  "Donwload a reveal.js zip file"
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
