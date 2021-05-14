//
//  URLSettings.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class URLSettings {
    private class var baseURL: String {
        return "https://api.weibo.com"
    }

    private class var h5BaseURL: String {
        return "https://m.weibo.cn"
    }

    class var userInfoURL: String {
        return baseURL + "/2/users/show.json"
    }

    class var getIndexURL: String {
        return h5BaseURL + "/api/container/getIndex"
    }

    class var ApiConfig: String {
        return h5BaseURL + "/api/config"
    }

    class var sendStatus: String {
        return h5BaseURL + "/api/statuses/update"
    }
}

// MARK: - Home Tab

extension URLSettings {
    class var feedGroupURL: String {
        return h5BaseURL + "/api/config/list"
    }

    class var homeStatusURL: String {
        return baseURL + "/2/statuses/home_timeline.json"
    }

    class var homeH5StatusURL: String {
        return h5BaseURL + "/feed/friends"
    }

    class var homeH5GroupStatusURL: String {
        return h5BaseURL + "/feed/group"
    }
}

// MARK: - Message Tab

extension URLSettings {
    class var messageMentions: String {
        return h5BaseURL + "/message/mentionsAt"
    }

    class var messageComments: String {
        return h5BaseURL + "/message/cmt"
    }

    class var messageMentionsComments: String {
        return h5BaseURL + "/message/mentionsCmt"
    }

    class var messageMyComments: String {
        return h5BaseURL + "/message/myCmt"
    }

    class var messageAttitudes: String {
        return h5BaseURL + "/message/attitude"
    }
}

// MARK: - Detail

extension URLSettings {
    class var repostTimeline: String {
        return h5BaseURL + "/api/statuses/repostTimeline"
    }

    class var attitudesShow: String {
        return h5BaseURL + "/api/attitudes/show"
    }

    class var commentsHotflow: String {
        return h5BaseURL + "/comments/hotflow"
    }
}
