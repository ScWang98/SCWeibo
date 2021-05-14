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
    private var currentPage: Int

    init() {
        currentPage = 1
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        let page = loadMore ? currentPage + 1 : 1
        listService.loadStatus(page: page) { (isSuccess, attitudeModels) in
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
                self.currentPage += 1
            } else {
                self.attitudeList = cellViewModels
                self.currentPage = 1
            }

            completion(isSuccess, true)
        }
    }
    
    func config(statusId: String?) {
        listService.statusId = statusId
    }
}
