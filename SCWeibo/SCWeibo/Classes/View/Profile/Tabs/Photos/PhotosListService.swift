//
//  PhotosListService.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/22.
//

import Alamofire
import Foundation

class PhotosListService {
    var userId: String?

    func loadStatus(page: Int?, completion: @escaping (_ isSuccess: Bool, _ list: Dictionary<AnyHashable, Any>?) -> Void) {
        guard let userId = userId else {
            completion(false, nil)
            return
        }

        let URLString = "https://m.weibo.cn/api/container/getSecond"

        var params = [String: Any]()
        params["containerid"] = "107803" + userId + "_-_photoall"
        params["count"] = 24
        params["page"] = page
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
