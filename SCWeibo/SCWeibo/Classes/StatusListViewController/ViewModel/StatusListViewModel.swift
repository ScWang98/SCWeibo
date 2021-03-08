//
//  StatusListViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import SDWebImage
import UIKit

class StatusListViewModel {
    lazy var statusList = [StatusCellViewModel]()
    var cellProducer = StatusCellViewModelProducer()

    private var pullupErrorTimes = 0
    /// 处理微博首页数据
    /// - Parameters:
    ///   - pullup: 是否下拉刷新
    ///   - completion: 完成请求,needRefresh = 是否需要刷新表格

    init() {
    }

    func registerCells(with tableView: UITableView) {
        cellProducer.registerCells(with: tableView)
    }

    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        if pullup && pullupErrorTimes >= 5 {
            completion(true, false)
            return
        }

        // 取出当前最新的数据 -> 越上面越新
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        // 上拉加载更多 -> 取最旧的一条(last)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)

        StatusListService.loadStatus(since_id: since_id, max_id: max_id) { isSuccess, list in
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

            // data handle
            if pullup {
                // 上拉加载更多，拼接在数组最后
                self.statusList += array
            } else {
                // 下拉刷新，拼接在数组最前面
                self.statusList = array + self.statusList
            }

            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
//                self.cacheSingleImage(list: array) {
                    completion(isSuccess,true)
//                }
            }
        }
    }

    // 本次下载的单张图片 - 换成
    private func cacheSingleImage(list: [MNStatusViewModel],
                                  finish: @escaping () -> Void) {
        let group = DispatchGroup()
        var length = 0

        // 单张图像 - 特殊处理
        for viewModel in list {
            if viewModel.picUrls?.count != 1 {
                continue
            }

            // get picture url
            guard let picture = viewModel.picUrls?[0].thumbnailPic,
                let url = URL(string: picture) else {
                continue
            }

            // SD下载图像
            // 图像下载完成，会自动p保存到沙盒, 路径 ==> url 的 md5
            // 如果该url的图像已经缓存 - 之后调用sd_xxx 不会在走下载.
            // 1.调度组入组
            group.enter()
            SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, _, _, _, _, _ in

                // 图像转换成二进制数据
                if let image = image,
                    let imageData = image.jpegData(compressionQuality: 1.0) {
                    length += imageData.count

                    viewModel.updateSingleImageSize(image: image)
                }
                // 2.出组
                group.leave()
            }
        }

        // 3. 调度组完成
        group.notify(queue: DispatchQueue.main) {
            print("down load finish ...")

            // FIXME: Debug gcd.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                finish()
            }
        }
    }
}
