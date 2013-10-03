(import [revelation [revelation :as r]])

(defn test-attributes []
  "Test tags' attribute creation"
  (assert (= (r.-unpack-attributes {}) " "))
  (assert (= (r.-unpack-attributes {"one" "attribute"}) 
             " one=\"attribute\""))
  (assert (in "one=\"attribute\""
           (r.-unpack-attributes {"one" "attribute" "another" "attr"}))))

(defn test-html-tags []
  "Test tag creation"
  (assert (= (r.html-tags "1" None) "<1 />"))
  (assert (= (r.html-tags "1" "2") "<1>2</1>"))
  (assert (= (r.html-tags "1" None {"attr" 3}) "<1 attr=\"3\" />"))
  (assert (= (r.html-tags "1" "2" {"attr" 3}) "<1 attr=\"3\">2</1>")))

(defn test-composition []
  "Test tag composition"
  (assert (= (r.html-tags "2" (r.html-tags "1" None)) "<2><1 /></2>"))
  (assert (= (r.html-tags "3" (r.html-tags "1" "2")) "<3><1>2</1></3>"))
  (assert (= (r.html-tags "2" (r.html-tags "1" None {"attr" 3}) {"other" 4}) "<2 other=\"4\"><1 attr=\"3\" /></2>"))
  (assert (= (r.html-tags "4" (r.html-tags "1" "2" {"attr" 3})) "<4><1 attr=\"3\">2</1></4>")))

(defn test-multi-composition []
  (let [[tag (r.html-tags "1" "2" {"attr" 3})]]
    (assert (= (r.html-tags "4" [tag tag]) "<4><1 attr=\"3\">2</1>\n<1 attr=\"3\">2</1></4>"))))

(defn test-tags []
  (assert (= (r.meta-data None) "<meta />"))
  (assert (= (r.meta-data {"some" "value"}) "<meta some=\"value\" />")))
