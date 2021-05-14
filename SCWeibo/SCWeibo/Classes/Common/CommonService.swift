//
//  CommonService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

import Alamofire
import Foundation

class ApiConfigService {
    class func getApiConfig(completion: ((_ login: Bool, _ st: String, _ uid: String?) -> Void)? = nil) {
        let URLString = URLSettings.ApiConfig

        AF.request(URLString).responseJSON { response in
            var jsonResult: Any?

            switch response.result {
            case let .success(json):
                jsonResult = json
            case .failure:
                jsonResult = nil
            }

            guard let jsonDict = jsonResult as? [String: Any],
                  let jsonData: [AnyHashable: Any] = jsonDict.sc.dictionary(for: "data"),
                  let st = jsonData.sc.string(for: "st") else {
                completion?(false, "", nil)
                return
            }

            let login = jsonData.sc.bool(for: "login")
            let uid = jsonData.sc.string(for: "uid")

            completion?(login, st, uid)
        }
    }
}
