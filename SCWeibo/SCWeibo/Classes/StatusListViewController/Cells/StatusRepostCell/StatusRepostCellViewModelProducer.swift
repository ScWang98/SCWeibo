//
//  StatusRepostCellViewModelProducer.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusRepostCellViewModelProducer: StatusCellViewModelProducerProtocol {
    var cellClass: UITableViewCell.Type {
        return StatusRepostCell.self
    }

    func canHandle(model: StatusResponse) -> Bool {
        return model.retweetedStatus != nil
    }

    func viewModel(for model: StatusResponse) -> StatusCellViewModel {
        StatusRepostCellViewModel(with: model)
    }
}
