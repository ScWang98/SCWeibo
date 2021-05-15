//
//  FavoriteListService.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/15.
//

import Alamofire
import Foundation

class FavoriteListService {
    var userId: String?
}

extension FavoriteListService: StatusListService {
    
    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let URLString = URLSettings.homeH5StatusURL

        var parameters = [String: Any]()
        if let max_id = max_id {
            parameters["max_id"] = max_id - 1
        }

        AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            var jsonResult: Any?

            switch response.result {
            case let .success(json):
                jsonResult = json
            case .failure:
                jsonResult = nil
            }

            guard let jsonDict = jsonResult as? [String: Any],
                  let jsonData: [AnyHashable: Any] = jsonDict.sc.dictionary(for: "data"),
                  let statusDictArray: [[String: AnyObject]] = jsonData.sc.array(for: "statuses") else {
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
