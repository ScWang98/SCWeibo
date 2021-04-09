//
//  StatusHomeListService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/3/30.
//

import Alamofire
import UIKit

class StatusHomeListService: StatusListService {
    var userId: String?
    
    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let URLString = URLSettings.homeStatusesURL
        var parameters = [String: Any]()
        parameters["max_id"] = max_id
        parameters["access_token"] = AccountManager.shared.accessToken

        AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            var jsonResult: Any?

            switch response.result {
            case let .success(json):
                jsonResult = json
            case .failure:
                jsonResult = nil
            }

            guard let jsonDict = jsonResult as? [String: Any],
                  let statusDictArray = jsonDict["statuses"] as? [[String: AnyObject]],
                  let results: Array<StatusResponse> = StatusResponse.decode(statusDictArray) else {
                completion(false, nil)
                return
            }

            completion(true, results)
        }
    }
}
