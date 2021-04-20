//
//  DetailRepostListService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import Alamofire
import Foundation

class DetailRepostListService {
    var statusId: String?
    
    func loadStatus(page: Int, completion: @escaping (_ isSuccess: Bool, _ list: [RepostModel]) -> Void) {
        guard let statusId = statusId else {
            return
        }
        
        let URLString = URLSettings.repostTimeline

        var params = [String: Any]()
        params["id"] = statusId
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
            
            var results = [RepostModel]()
            if let dataDict: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data"),
               let dataArray: [Dictionary<AnyHashable, Any>] = dataDict.sc.array(for: "data") {
                for repostItem in dataArray {
                    results.append(RepostModel.init(dict: repostItem))
                }
            }
            completion(isSuccess, results)
        }
    }
}
