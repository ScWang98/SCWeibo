//
//  StatusDetailViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import Foundation

protocol StatusDetailTabViewModel {
    var tabName: String { get }
    var tabViewController: UIViewController? { get }
    var tabView: UIView { get }
    var tabScrollView: UIScrollView { get }

    func tabRefresh(with completion: (() -> Void)?)
}

class StatusDetailViewModel {
    var status: StatusResponse?
    var screenName: String?
    var avatarUrl: String?
    var source: String?
    var createdAt: String?
    var statusLabelModel: ContentLabelTextModel?
    var picUrls: [StatusPicturesModel]?
    var repostTitle: String?
    var commentTitle: String?
    var likeTitle: String?
    var repostLabelModel: ContentLabelTextModel?

    let repostTabViewModel = StatusDetailRepostTabViewModel()
    let commentTabViewModel = StatusDetailCommentTabViewModel()
    let attitudeTabViewModel = StatusDetailAttitudeTabViewModel()

    lazy var tabViewModels: [StatusDetailTabViewModel] = {
        var models = [StatusDetailTabViewModel]()
        models.append(self.repostTabViewModel)
        models.append(self.commentTabViewModel)
        models.append(self.attitudeTabViewModel)
        return models
    }()

    lazy var tabNames: [String] = {
        tabViewModels.map { tabViewModel -> String in
            tabViewModel.tabName
        }
    }()

//    var profileService = UserProfileService()

    init() {
    }

    func config(with routeParams: Dictionary<AnyHashable, Any>?) {
        if let routeParams = routeParams,
           let userInfo: [AnyHashable: Any] = routeParams.sc.dictionary(for: RouterParameterUserInfo),
           let status = userInfo["statusResponse"] as? StatusResponse {
            parseStatusResponse(status: status)
        }
    }

    func fetchUserInfo(completion: @escaping () -> Void) {
//        guard let userId = id else {
//            return
//        }
//        profileService.fetchUserInfo(with: userId) { user in
//            guard let user = user else {
//                completion()
//                return
//            }
//
//            self.parseUserResponse(user: user)
//            completion()
//        }
    }

    func reloadAllTabsContent() {
        for viewModel in tabViewModels {
            viewModel.tabRefresh(with: nil)
        }
    }
}

private extension StatusDetailViewModel {
    func parseStatusResponse(status: StatusResponse) {
        statusLabelModel = MNEmojiManager.shared.parseTextWithHTML(string: status.text ?? "", font: UIFont.systemFont(ofSize: MNLayout.Layout(15)))
        picUrls = StatusPicturesModel.generateModels(with: status.picUrls ?? [])
        screenName = status.user?.screenName
        avatarUrl = status.user?.avatar
        source = "来自" + (status.source?.mn_href() ?? "")
        createdAt = Date.mn_sinaDate(string: status.createdAt)?.mn_dateDescription
        repostTitle = countSting(count: status.repostsCount, defaultStr: " 转发")
        commentTitle = countSting(count: status.commentsCount, defaultStr: " 评论")
        likeTitle = countSting(count: status.attitudesCount, defaultStr: " 点赞")
        let repostStr = "@\(status.retweetedStatus?.user?.screenName ?? ""):\(status.retweetedStatus?.text ?? "")"
        let repostFontSize = UIFont.systemFont(ofSize: 14)
        if status.retweetedStatus != nil {
            repostLabelModel = MNEmojiManager.shared.parseTextWithHTML(string: repostStr, font: repostFontSize)
            picUrls = StatusPicturesModel.generateModels(with: status.retweetedStatus?.picUrls ?? [])
        }
    }
    
    private func countSting(count: Int, defaultStr: String) -> String {
        if count <= 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f万", Double(count) / 10000)
    }
}
