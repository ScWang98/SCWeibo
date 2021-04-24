//
//  EmojiManager.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/12.
//

import UIKit

class EmojiManager {
    static let shared = EmojiManager()

    lazy var packages = [EmojiPackageModel]()

    let pageCells = 20

    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoji.bundle", ofType: nil)
        return Bundle(path: path ?? "") ?? Bundle()
    }()

    private init() {
        loadPackageDatas()
    }

    // 添加最近使用的表情
    func recentEmoji(model: EmojiModel) {
        // 1.表情使用次数+1
        model.times += 1

        // 2.添加表情
        if !packages[0].emotions.contains(model) {
            packages[0].emotions.append(model)
        }

        // 3.排序(降序)
        packages[0].emotions.sort { $0.times > $1.times }

        // 4.表情数组长度处理
        if packages[0].emotions.count > pageCells {
            let subRange = pageCells ..< packages[0].emotions.count
            packages[0].emotions.removeSubrange(subRange)
        }
    }

    /// 根据传入的字符串[abc]，查找对应的表情模型
    /// - Parameter string : 查询字符串
    func findEmoji(string: String) -> EmojiModel? {
        for pModel in packages {
            // 传入的参数和model对比，过滤出一致字符串对应的模型.
            let result = pModel.emotions.filter { $0.chs == string }
            if result.count > 0 {
                return result.first
            }
        }
        return nil
    }
}

private extension EmojiManager {
    func loadPackageDatas() {
        guard let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
              let models = NSArray.yy_modelArray(with: EmojiPackageModel.self, json: array) as? [EmojiPackageModel]
        else {
            print("loadPackageDatas failure.")
            return
        }
        packages += models
    }
}

// MARK: - 表情符号处理
