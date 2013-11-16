(import [revelation [revelation :as r]])
(import [revelation [slides :as s]])

(setv *author* "Some Author")
(setv *title* "Test Presentation")

(defn test-slide-revelation []
  (let [[object-presentation (s.Presentation *author* *title*)]
        [fun-presentation (r.index *author* *title* [])]]
    (assert (= (repr object-presentation) fun-presentation))))
