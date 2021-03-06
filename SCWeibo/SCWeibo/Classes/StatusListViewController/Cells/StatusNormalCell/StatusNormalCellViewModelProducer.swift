//
//  StatusNormalCellViewModelProducer.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusNormalCellViewModelProducer: StatusCellViewModelProducerProtocol {
    var cellClass: UITableViewCell.Type {
        return StatusNormalCell.self
    }

    func canHandle(model: StatusResponse) -> Bool {
        return model.retweetedStatus == nil
    }

    func viewModel(for model: StatusResponse) -> StatusCellViewModel {
        StatusNormalCellViewModel(with: model)
    }
}
