;; Author: Guillermo Vayá Pérez 
;; Mail: <guivaya@gmail.com>
;; @Willyfrog_
;; Sumary: A partially object oriented version. It still makes use of revelation

(import [revelation [horizontal-slide -section index]])

(defclass Reveal-Common []
  [[attribute-list {}]
   [add-attribute (fn [self name value] (assoc (getattr self "attribute_list") name value))]])

(defclass Slide [Reveal-Common]
  [[content-list []]
   [add-content (fn [self content] (.append (getattr self "content_list") content))]
   [--repr-- (fn [self] (-section self.content-list self.attribute-list))]])

(defclass Chapter [Reveal-Common]
  [[slide-list []]
   [add-slide (fn [self slide] (.append (getattr self "slide_list") slide))]
   [--repr-- (fn [self] (horizontal-slide self.slide-list self.attribute-list))]])

(defclass Presentation [Reveal-Common]
  [[chapter-list []]
   [--init-- (fn [self author title]
               (setv self.author author)
               (setv self.title title)
               None)]
   [add-chapter (fn [self chapter] 
                  (if (isinstance chapter Chapter) 
                    (.append (.getattr self "chapter-list") chapter)
                    (raise (TypeError "Inserting a something that is not a  chapter into a presentation"))))]
   [--unicode-- (fn [self] (index self.author self.title self.chapter-list self.attribute-list))]])
