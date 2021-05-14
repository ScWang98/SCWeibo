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
    var statusId: Int = 0
    var screenName: String?
    var avatarUrl: String?
    var timeAttrString: NSAttributedString?
    var statusLabelModel: ContentLabelTextModel?
    var picUrls: [StatusPicturesModel]?
    var liked: Bool {
        get { status?.liked ?? false }
        set { status?.liked = newValue }
    }

    var favorited: Bool {
        get { status?.favorited ?? false }
        set { status?.favorited = newValue }
    }

    var repostLabelModel: ContentLabelTextModel?

    let repostTabViewModel = StatusDetailRepostTabViewModel()
    let commentTabViewModel = StatusDetailCommentTabViewModel()
    let attitudeTabViewModel = StatusDetailAttitudeTabViewModel()

    var service = StatusDetailService()

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

    init() {
    }

    func config(with routeParams: Dictionary<AnyHashable, Any>?) {
        if let routeParams = routeParams,
           let userInfo: [AnyHashable: Any] = routeParams.sc.dictionary(for: RouterParameterUserInfo),
           let status = userInfo["status"] as? StatusResponse {
            parseStatusResponse(status: status)
        }

        var statusId: String?
        if let id = status?.id {
            statusId = String(id)
        }
        repostTabViewModel.viewController.config(statusId: statusId)
        commentTabViewModel.viewController.config(statusId: statusId)
        attitudeTabViewModel.viewController.config(statusId: statusId)
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

// MARK: - Public Methods

extension StatusDetailViewModel {
    func sendRepostAction() {
        print("sendRepostAction")
    }

    func sendCommentAction() {
        print("sendCommentAction")
    }

    func sendFavoriteAction(favorited: Bool) {
        service.sendFavoriteAction(favorited: favorited, statusId: statusId) { _ in
        }
    }

    func sendLikeAction(liked: Bool) {
        service.sendLikeAction(liked: liked, statusId: statusId) { _ in
        }
    }
}

private extension StatusDetailViewModel {
    func parseStatusResponse(status: StatusResponse) {
        self.status = status
        statusId = status.id
        statusLabelModel = ContentHTMLParser.parseContentText(string: status.text ?? "", font: UIFont.systemFont(ofSize: 16))
        picUrls = StatusPicturesModel.generateModels(with: status.picUrls)
        screenName = status.user?.screenName
        avatarUrl = status.user?.avatar

        if let time = status.createdAt?.semanticDateDescription {
            var string = time
            if let source = status.source?.mn_href(), source.count > 0 {
                string = string + " · 来自 " + source
            }
            timeAttrString = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                             .foregroundColor: UIColor.lightGray])
        }
        if status.retweetedStatus != nil {
            let repostStr = "<a href=xx>@\(status.retweetedStatus?.user?.screenName ?? "")</a>:\(status.retweetedStatus?.text ?? "")"
            repostLabelModel = ContentHTMLParser.parseContentText(string: repostStr, font: UIFont.systemFont(ofSize: 14))
            picUrls = StatusPicturesModel.generateModels(with: status.retweetedStatus?.picUrls)
        }

        repostTabViewModel.repostNumber = status.repostsCount
        commentTabViewModel.commentNumber = status.commentsCount
        attitudeTabViewModel.attitudeNumber = status.attitudesCount
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
