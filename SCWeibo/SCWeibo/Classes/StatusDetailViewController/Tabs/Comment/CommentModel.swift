//
//  CommentModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

/// 因此model使用了H5版的接口，参数层级较复杂，因此手动解析数据
class CommentModel: Codable {
    var id: String?
    var text: String?
    var createdAt: String?
    var likeCount = 0
    var user: UserResponse?
    var comments: [CommentModel]?
    var totalNumber = 0

    init(dict: [AnyHashable: Any]) {
        id = dict.sc.string(for: "id")
        text = dict.sc.string(for: "text")
        createdAt = dict.sc.string(for: "created_at")
        likeCount = dict.sc.int(for: "like_count")
        totalNumber = dict.sc.int(for: "total_number")
        if let userDict: [AnyHashable: Any] = dict.sc.dictionary(for: "user") {
            user = UserResponse(withH5dict: userDict)
        }
        if let commentsDictArray: [[AnyHashable: Any]] = dict.sc.array(for: "comments") {
            var comments = [CommentModel]()
            for commentDict in commentsDictArray {
                comments.append(CommentModel(dict: commentDict))
            }
            self.comments = comments
        }
    }
}
