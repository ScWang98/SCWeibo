//
//  StatusListService.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Alamofire
import Foundation

class StatusListService {
    /// 加载数据(从本地数据库 or 网络请求)
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上拉加载更多id
    ///   - ompletion: 完成回调
    class func loadStatus(since_id: Int = 0, max_id: Int = 0, completion: @escaping (_ isSuccess: Bool, _ list: [StatusResponse]?) -> Void) {
        let URLString = URLSettings.homeStatusesURL
        var parameters = [String: Any]()
        parameters["since_id"] = since_id
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
