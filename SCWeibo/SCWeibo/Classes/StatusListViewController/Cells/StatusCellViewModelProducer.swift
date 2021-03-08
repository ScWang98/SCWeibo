//
//  StatusCellViewModelProducer.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusCellViewModelProducer {
    private var producers = [StatusCellViewModelProducerProtocol]()

    init() {
        registerAllProducer()
    }

    func generateCellViewModel(with model: StatusResponse) -> StatusCellViewModel? {
        for producer in producers {
            if producer.canHandle(model: model) {
                return producer.viewModel(for: model)
            }
        }
        return nil
    }

    func registerCells(with tableView: UITableView) {
        for producer in producers {
            let clazz = producer.cellClass
            tableView.register(clazz, forCellReuseIdentifier: String(describing: clazz))
        }
    }
}

private extension StatusCellViewModelProducer {
    func register(producer: StatusCellViewModelProducerProtocol) {
        producers.append(producer)
    }

    func registerAllProducer() {
        register(producer: StatusRepostCellViewModelProducer())
        register(producer: StatusNormalCellViewModelProducer())
    }
}
