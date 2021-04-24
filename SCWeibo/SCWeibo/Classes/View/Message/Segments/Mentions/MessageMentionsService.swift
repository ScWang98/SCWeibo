//
//  MessageMentionsService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import Alamofire
import Foundation

class MessageMentionsService: StatusListService {
    var userId: String?

    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let URLString = URLSettings.messageMentions

        var parameters = [String: Any]()
        parameters["page"] = page

        AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            var jsonDict: [String: Any]?

            switch response.result {
            case let .success(json):
                jsonDict = json as? [String: Any]
            case .failure:
                jsonDict = nil
            }

            guard let statusDictArray: [[String: AnyObject]] = jsonDict?.sc.array(for: "data") else {
                completion(false, nil)
                return
            }

            var results = [StatusResponse]()
            for statusDict in statusDictArray {
                results.append(StatusResponse(withH5dict: statusDict))
            }

            completion(true, results)
        }
    }
}
