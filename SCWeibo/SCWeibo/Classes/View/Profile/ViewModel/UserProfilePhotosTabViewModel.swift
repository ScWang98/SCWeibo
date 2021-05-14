//
//  UserProfilePhotosTabViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import UIKit

class UserProfilePhotosTabViewModel {
    let viewController = PhotosListViewController()
}

extension UserProfilePhotosTabViewModel: UserProfileTabViewModel {
    var tabName: String {
        return "相册"
    }

    var tabViewController: UIViewController? {
        return viewController
    }

    var tabView: UIView {
        return viewController.view
    }

    var tabScrollView: UIScrollView {
        return viewController.collectionView
    }

    func tabRefresh(with completion: (() -> Void)?) {
        viewController.refreshData(with: false)
    }
}
