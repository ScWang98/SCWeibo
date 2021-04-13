//
//  DetailAttitudeListService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

import Alamofire

class DetailAttitudeListService {
    class func loadStatus(since_id: Int?, completion: @escaping (_ isSuccess: Bool, _ list: [AttitudeModel]) -> Void) {
        let URLString = URLSettings.attitudesShow

        var params = [String: Any]()
        params["id"] = "4624863745281204"
        params["mid"] = "4624863745281204"
        params["page"] = 1

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
            
            var results = [AttitudeModel]()
            if let dataDict: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data"),
               let dataArray: [Dictionary<AnyHashable, Any>] = dataDict.sc.array(for: "data") {
                for attitudeItem in dataArray {
                    results.append(AttitudeModel.init(dict: attitudeItem))
                }
            }
            completion(isSuccess, results)
        }
    }
}
