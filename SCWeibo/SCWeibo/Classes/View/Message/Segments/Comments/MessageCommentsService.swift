//
//  MessageCommentsService.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import Alamofire
import Foundation

class MessageCommentsService {
    var requestURL: String?

    init(type: MessageCommentsListType) {
        switch type {
        case .received:
            requestURL = URLSettings.messageComments
        case .mentioned:
            requestURL = URLSettings.messageMentionsComments
        case .sended:
            requestURL = URLSettings.messageMyComments
        }
    }

    func loadStatus(page: Int, completion: @escaping (_ isSuccess: Bool, _ list: [MessageCommentModel]?) -> Void) {
        guard let requestURL = requestURL else {
            return
        }

        var params = [String: Any]()
        params["page"] = page

        AF.request(requestURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in

            var jsonDict: Dictionary<AnyHashable, Any>?

            switch response.result {
            case let .success(json):
                jsonDict = json as? Dictionary<AnyHashable, Any>
            case .failure:
                jsonDict = nil
            }

            guard let dataArray: [Dictionary<AnyHashable, Any>] = jsonDict?.sc.array(for: "data") else {
                completion(false, nil)
                return
            }

            var results = [MessageCommentModel]()
            for commentItem in dataArray {
                results.append(MessageCommentModel(dict: commentItem))
            }

            completion(true, results)
        }
    }
}
