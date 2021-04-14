//
//  DetailCommentListService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Alamofire
import Foundation

class DetailCommentListService {
    class func loadStatus(since_id: Int?, completion: @escaping (_ isSuccess: Bool, _ list: [CommentModel]) -> Void) {
        let URLString = URLSettings.commentsHotflow

        var params = [String: Any]()
        params["id"] = "4625445730125533"
        params["max_id"] = 0
        params["max_id_type"] = 0
        params["mid"] = 4625445730125533

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

            var results = [CommentModel]()
            if let dataDict: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data"),
               let dataArray: [Dictionary<AnyHashable, Any>] = dataDict.sc.array(for: "data") {
                for commentItem in dataArray {
                    results.append(CommentModel(dict: commentItem))
                }
            }
            completion(isSuccess, results)
        }
    }
}
