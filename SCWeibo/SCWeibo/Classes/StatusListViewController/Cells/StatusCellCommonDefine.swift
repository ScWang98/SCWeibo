//
//  StatusCellCommonDefine.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

protocol StatusCellViewModelProducerProtocol {
    var cellClass: UITableViewCell.Type { get }

    func canHandle(model: StatusResponse) -> Bool
    func viewModel(for model: StatusResponse) -> StatusCellViewModel
}

protocol StatusCellViewModel {
    var cellHeight: CGFloat { get }
    var cellIdentifier: String { get }

    var status: StatusResponse { get set }
    var screenName: String? { get set }
    var avatarUrl: String? { get set }
    var source: String? { get set }
    var createdAt: String? { get set }

    var repostTitle: String? { get set }
    var commentTitle: String? { get set }
    var likeTitle: String? { get set }
}

protocol StatusCell {
    func reload(with viewModel: StatusCellViewModel)
}
