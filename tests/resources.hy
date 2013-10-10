(import hashlib)
;; sha1 for zipped version of reveal, v. 2.5.0
(setv *sha1-v-2-5-0-zip* "42b798418aceb7e8f047483e31c9c1938693748e")

(defn sha1-file [file-path]
  "get a file sha1 hash"
  (let [[sha1 (hashlib.sha1)]]
    (with [f (open file-path "r")]
          (.update sha1 (.read f)))
    (.hexdigest sha1)))

;; def hashfile(filepath):
;;     sha1 = hashlib.sha1()
;;     f = open(filepath, 'rb')
;;     try:
;;         sha1.update(f.read())
;;     finally:
;;         f.close()
;;     return sha1.hexdigest()
