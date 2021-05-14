//
//  MessageAttitudesViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import Foundation

class MessageAttitudesViewModel {
    lazy var attitudeList = [MessageAttitudeCellViewModel]()
    lazy var listService = MessageAttitudesService()

    private var currentPage: Int

    init() {
        currentPage = 1
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {

        
        let page = loadMore ? currentPage + 1 : 1
        listService.loadStatus(page: page) { isSuccess, attitudeModels in
            guard let attitudeModels = attitudeModels,
                  isSuccess else {
                completion(false, false)
                return
            }

            var cellViewModels = [MessageAttitudeCellViewModel]()
            for attitudeModel in attitudeModels {
                let viewModel = MessageAttitudeCellViewModel(with: attitudeModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.attitudeList += cellViewModels
                self.currentPage += 1
            } else {
                self.attitudeList = cellViewModels
                self.currentPage = 1
            }

            completion(isSuccess, true)
        }
    }
}
