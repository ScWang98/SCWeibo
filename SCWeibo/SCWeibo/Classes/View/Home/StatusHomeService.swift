//
//  StatusHomeService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/3/30.
//

import Alamofire
import UIKit

class StatusHomeService {
    var userId: String?
    var gid: String? {
        didSet {
            print(String(describing: gid))
        }
    }

    func fetchFeedGroup(completion: @escaping ([GroupModel]?) -> Void) {
        let URLString = URLSettings.feedGroupURL
        AF.request(URLString).responseJSON { response in
            var jsonResult: Any?

            switch response.result {
            case let .success(json):
                jsonResult = json
            case .failure:
                jsonResult = nil
            }

            guard let jsonDict = jsonResult as? [String: Any],
                  let dataDict: [AnyHashable: Any] = jsonDict.sc.dictionary(for: "data"),
                  let groupsArray: [[AnyHashable: Any]] = dataDict.sc.array(for: "groups") else {
                completion(nil)
                return
            }

            var results = [GroupModel]()
            for groupDict in groupsArray {
                guard let gid = groupDict.sc.string(for: "gid"),
                      let name = groupDict.sc.string(for: "name") else {
                    continue
                }
                results.append(GroupModel(gid: gid, name: name))
            }

            completion(results)
        }
    }
}

extension StatusHomeService: StatusListService {
    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let URLString = gid == nil ? URLSettings.homeH5StatusURL : URLSettings.homeH5GroupStatusURL

        var parameters = [String: Any]()
        parameters["gid"] = gid
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

    // 此实现为 微博开放平台接口
//    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
//        let URLString = URLSettings.homeStatusesURL
//        var parameters = [String: Any]()
//        if let max_id = max_id {
//            parameters["max_id"] = max_id - 1
//        }
//        parameters["access_token"] = AccountManager.shared.accessToken
//
//        AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
//            var jsonResult: Any?
//
//            switch response.result {
//            case let .success(json):
//                jsonResult = json
//            case .failure:
//                jsonResult = nil
//            }
//
//            guard let jsonDict = jsonResult as? [String: Any],
//                  let statusDictArray = jsonDict["statuses"] as? [[String: AnyObject]],
//                  let results: Array<StatusResponse> = StatusResponse.decode(statusDictArray) else {
//                completion(false, nil)
//                return
//            }
//
//            completion(true, results)
//        }
//    }
}
