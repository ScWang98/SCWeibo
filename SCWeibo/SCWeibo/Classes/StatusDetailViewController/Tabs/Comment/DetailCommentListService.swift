//
//  DetailCommentListService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Alamofire
import Foundation

class DetailCommentListService {
    var statusId: String?
    var maxId: Int = 0
    var maxIdType: Int = 0

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ list: [CommentModel]) -> Void) {
        guard let statusId = statusId else {
            return
        }
        
        let URLString = URLSettings.commentsHotflow

        var params = [String: Any]()
        params["id"] = statusId
        params["max_id"] = loadMore ? maxId : 0
        params["max_id_type"] = loadMore ? maxIdType : 0
        params["mid"] = statusId

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
                self.maxId = dataDict.sc.int(for: "max_id", defaultValue: 0)
                self.maxIdType = dataDict.sc.int(for: "max_id_type", defaultValue: 0)
                for commentItem in dataArray {
                    results.append(CommentModel(dict: commentItem))
                }
            }
            completion(isSuccess, results)
        }
    }
}
