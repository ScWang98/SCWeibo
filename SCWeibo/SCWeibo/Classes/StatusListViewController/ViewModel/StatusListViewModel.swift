//
//  StatusListViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

protocol StatusListService {
    var userId: String? { get set }
    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (_ isSuccess: Bool, _ list: [StatusResponse]?) -> Void)
}

class StatusListViewModel {
    lazy var statusList = [StatusCellViewModel]()
    var listService: StatusListService?

    private var cellProducer = StatusCellViewModelProducer()
    private var pullupErrorTimes = 0
    private var currentPage: Int

    init() {
        currentPage = 1
    }

    func registerCells(with tableView: UITableView) {
        cellProducer.registerCells(with: tableView)
    }
    
    func config(withUserId userId: String?) {
        listService?.userId = userId
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        if !loadMore && pullupErrorTimes >= 5 {
            completion(true, false)
            return
        }

        // 上拉加载更多 -> 取最旧的一条(last)
        let max_id = loadMore ? statusList.last?.status.id : nil
        let page = loadMore ? currentPage + 1 : 1

        listService?.loadStatus(max_id: max_id, page: page, completion: { isSuccess, list in
            if !isSuccess {
                completion(false, false)
                return
            }

            var array = [StatusCellViewModel]()
            for model in list ?? [] {
                if let viewModel = self.cellProducer.generateCellViewModel(with: model) {
                    array.append(viewModel)
                }
            }

            if loadMore {
                // 上拉加载更多，拼接在数组最后
                self.statusList += array
                self.currentPage += 1
            } else {
                // 下拉刷新，拼接在数组最前面
                self.statusList = array
                self.currentPage = 1
            }

            if !loadMore && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }
        })
    }
}
