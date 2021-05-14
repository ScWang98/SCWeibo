//
//  DetailRepostListViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import Foundation

class DetailRepostListViewModel {
    lazy var repostList = [DetailRepostCellViewModel]()
    lazy var listService = DetailRepostListService()
    private var currentPage: Int

    init() {
        currentPage = 1
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        let page = loadMore ? currentPage + 1 : 1
        listService.loadStatus(page: page) { (isSuccess, repostModels) in
            if !isSuccess {
                completion(false, false)
                return
            }

            var cellViewModels = [DetailRepostCellViewModel]()
            for repostModel in repostModels {
                let viewModel = DetailRepostCellViewModel(with: repostModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.repostList += cellViewModels
                self.currentPage += 1
            } else {
                self.repostList = cellViewModels
                self.currentPage = 1
            }

            completion(isSuccess, true)
        }
    }
    
    func config(statusId: String?) {
        listService.statusId = statusId
    }
}
