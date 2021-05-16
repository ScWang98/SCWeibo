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
        ApiConfigService.getApiConfig { _, st, _ in
            self.st = st
        }
    }
}

// MARK: - Send Status

extension WriteStatusService {
    func sendStatus(content: String, photos: [UIImage], visible: Int? = nil, completion: ((_ success: Bool) -> Void)? = nil) {
        if photos.count > 0 {
            uploadPhotos(photos: photos) { picIds in
                self.postStatus(content: content, photos: picIds, visible: visible, completion: completion)
            }
        } else {
            postStatus(content: content, visible: visible, completion: completion)
        }
    }

    func postStatus(content: String, photos: [String]? = nil, visible: Int? = nil, completion: ((_ success: Bool) -> Void)? = nil) {
        let URLString = URLSettings.sendStatus

        var parameters = [String: Any]()
        parameters["content"] = content
        parameters["st"] = st
        parameters["visible"] = visible
        if let photos = photos {
            parameters["picId"] = photos.joined(separator: ",")
        }

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

    func uploadPhotos(photos: [UIImage], completion: @escaping ((_ picIds: [String]) -> Void)) {
        let URLString = URLSettings.addPicture
        let group = DispatchGroup()
        var picIds = [String]()
        var headers = HTTPHeaders()
        headers.add(name: "origin", value: "https://m.weibo.cn")
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/mblog"))
        for photo in photos {
            group.enter()
            AF.upload(multipartFormData: { formData in
                if let jsonData = "json".data(using: .utf8),
                   let photoData = photo.jpegData(compressionQuality: 1) {
                    formData.append(jsonData, withName: "type")
                    formData.append(photoData, withName: "pic", fileName: "assert", mimeType: "image/jpg")
                }

            }, to: URLString, method: .post, headers: headers).responseJSON { response in
                var jsonDict: [String: Any]?

                switch response.result {
                case let .success(json):
                    jsonDict = json as? [String: Any]
                case .failure:
                    jsonDict = nil
                }

                if let picId = jsonDict?.sc.string(for: "pic_id") {
                    picIds.append(picId)
                }

                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(picIds)
        }
    }
}

// MARK: - Repost Status

extension WriteStatusService {
    func repostStatus(content: String, statusId: Int, visible: Int? = nil, completion: ((_ success: Bool) -> Void)? = nil) {
        let URLString = URLSettings.repostStatus

        var parameters = [String: Any]()
        parameters["content"] = content
        parameters["dualPost"] = 0
        parameters["id"] = statusId
        parameters["mid"] = statusId
        parameters["pwa"] = 1
        parameters["st"] = st
        parameters["visible"] = visible

        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/compose/repost?pwa=1&id=" + String(statusId)))

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

// MARK: - Create Comment

extension WriteStatusService {
    func createComment(content: String, statusId: Int, completion: ((_ success: Bool) -> Void)? = nil) {
        let URLString = URLSettings.createComment

        var parameters = [String: Any]()
        parameters["content"] = content
        parameters["dualPost"] = 0
        parameters["id"] = statusId
        parameters["mid"] = statusId
        parameters["st"] = st

        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/compose/comment?pwa=1&id=" + String(statusId)))

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

// MARK: - Reply Comment

extension WriteStatusService {
    func replyComment(content: String, statusId: Int, commentId: String, completion: ((_ success: Bool) -> Void)? = nil) {
        let URLString = URLSettings.replyComment

        var parameters = [String: Any]()
        parameters["cid"] = commentId
        parameters["content"] = content
        parameters["dualPost"] = 0
        parameters["id"] = statusId
        parameters["mid"] = statusId
        parameters["reply"] = commentId
        parameters["st"] = st

        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/compose/reply?pwa=1&id=" + String(statusId)))

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
