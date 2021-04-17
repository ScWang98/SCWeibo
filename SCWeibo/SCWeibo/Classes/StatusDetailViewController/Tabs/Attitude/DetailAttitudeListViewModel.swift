//
//  DetailAttitudeListViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailAttitudeListViewModel {
    lazy var attitudeList = [DetailAttitudeCellViewModel]()
    lazy var listService = DetailAttitudeListService()

    var sinceId: String?

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        listService.loadStatus(since_id: nil) { (isSuccess, attitudeModels) in
            if !isSuccess {
                completion(false, false)
                return
            }

            var cellViewModels = [DetailAttitudeCellViewModel]()
            for attitudeModel in attitudeModels {
                let viewModel = DetailAttitudeCellViewModel(with: attitudeModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.attitudeList += cellViewModels
            } else {
                self.attitudeList = cellViewModels
            }

            completion(isSuccess, true)
        }
    }
    
    func config(statusId: String?) {
        listService.statusId = statusId
    }
}
