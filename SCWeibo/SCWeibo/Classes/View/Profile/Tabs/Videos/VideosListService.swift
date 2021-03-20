//
//  VideosListService.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import Alamofire
import Foundation

class VideosListService {
    class func loadStatus(since_id: Int?, completion: @escaping (_ isSuccess: Bool, _ list: Dictionary<AnyHashable, Any>?) -> Void) {
        let containerIdPre = "231567"
        let userId = "5236464641"

        let URLString = "https://m.weibo.cn/api/container/getIndex"

        var params = [String: Any]()
        params["containerid"] = containerIdPre + userId
        params["type"] = "uid"
        params["value"] = userId
        AF.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            var isSuccess = false
            var jsonResult: Dictionary<AnyHashable, Any>?
            switch response.result {
            case let .success(json):
                if let dict = json as? Dictionary<AnyHashable, Any> {
                    jsonResult = dict
                    isSuccess = true
                }
            case .failure:
                jsonResult = nil
                isSuccess = false
            }
            
            if let data: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data") {
                jsonResult = data
            }
            completion(isSuccess, jsonResult)
        }
    }
}
