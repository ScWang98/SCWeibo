//
//  MessageAttitudesService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import Alamofire
import Foundation

class MessageAttitudesService {
    func loadStatus(page: Int, completion: @escaping (_ isSuccess: Bool, _ list: [MessageAttitudeModel]?) -> Void) {
        let URLString = URLSettings.messageMentions

        var params = [String: Any]()
        params["page"] = page

        AF.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in

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

            var results = [MessageAttitudeModel]()
            for commentItem in dataArray {
                results.append(MessageAttitudeModel(dict: commentItem))
            }

            completion(true, results)
        }
    }
}
