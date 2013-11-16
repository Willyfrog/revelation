(import [tests.resources [*sha1-v-2-5-0-zip* sha1-file]])
(import [revelation.utils [-get-zipped-reveal-js]])

(defn test-sha1-download []
  "check that download works properly"
  (assert (= (sha1-file (-get-zipped-reveal-js)) *sha1-v-2-5-0-zip*)))
