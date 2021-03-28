(ns telegram-bot.core
  (:require [nl.epij.gcp.gcf.middleware :refer [wrap-json-data]]
            [nl.epij.gcp.gcf.event :as event]
            [nl.epij.gcp.gcf.message :as message]
            [nl.epij.gcp.gcf.log :as log]
            [hato.client :as hato]
            [clojure.pprint :as pprint]))

(def telegram-token
  (System/getenv "TELEGRAM_TOKEN"))

(def telegram-chat-id
  (System/getenv "TELEGRAM_CHAT_ID"))

(defn telegram-request
  ([method] (telegram-request method nil {}))
  ([method event-id params]
   (let [method' (get {::send-message "sendMessage"
                       ::get-updates  "getUpdates"
                       ::get-me       "getMe"}
                      method)]
     (log/info (format "Calling Telegram API method '%s'" method')
               {:event-id   event-id
                :api-params params})
     (hato/post (format "https://api.telegram.org/bot%s/%s" telegram-token method')
                {:form-params params
                 :as          :json}))))

(def ignored-status
  #{"QUEUED"
    "WORKING"})

(defn handler
  [{::event/keys [id message _timestamp _resource _attributes _event-type]}]
  (let [{::message/keys [_type _attributes data]} message
        {status  "status"
         log-url "logUrl"} data
        data' (dissoc data
                      "buildTriggerId"
                      "createTime"
                      "finishTime"
                      "id"
                      "logUrl"
                      "logsBucket"
                      "name"
                      "options"
                      "queueTtl"
                      "results"
                      "source"
                      "sourceProvenance"
                      "startTime"
                      "steps"
                      "tags"
                      "timeout"
                      "timing")]
    (if (contains? ignored-status status)
      (log/info (format "Build status '%s' received, ignoring..." status)
                {:event-id id})
      (telegram-request ::send-message
                        id
                        {"chat_id"    telegram-chat-id
                         "text"       (format "*Event ID: `%s`*\n\n```clojure\n%s```\n[Go to Cloud Console page](%s)"
                                              id
                                              (with-out-str (pprint/pprint data'))
                                              log-url)
                         "parse_mode" "MarkdownV2"}))))

(def app
  (wrap-json-data handler))

(comment

 (telegram-request ::get-updates)

 )
