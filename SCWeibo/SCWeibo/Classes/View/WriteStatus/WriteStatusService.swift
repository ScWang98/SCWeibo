//
//  WriteStatusService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

import Alamofire
import Foundation

class WriteStatusService {
    var st: String?

    func fetchST() {
        ApiConfigService.getApiConfig { login, st, uid in
            self.st = st
            print("login:\(login) st:\(st) uid:\(String(describing: uid))")
        }
    }

    func sendStatus(content: String, visible: Int? = nil, completion: ((_ success: Bool) -> Void)? = nil) {
        let URLString = URLSettings.sendStatus

        var parameters = [String: Any]()
        parameters["content"] = content
        parameters["st"] = st
        parameters["visible"] = visible

        // 淦，这俩header必加，浪费了我半个小时debug
        var headers = HTTPHeaders()
        headers.add(name: "origin", value: "https://m.weibo.cn")
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/compose"))

        AF.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            var jsonDict: [String: Any]?

            switch response.result {
            case let .success(json):
                jsonDict = json as? [String: Any]
            case .failure:
                jsonDict = nil
            }

            guard let jsonData: [AnyHashable: Any] = jsonDict?.sc.dictionary(for: "data"),
                  jsonData["text"] != nil else {
                completion?(false)
                return
            }

            completion?(true)
        }
    }
}
