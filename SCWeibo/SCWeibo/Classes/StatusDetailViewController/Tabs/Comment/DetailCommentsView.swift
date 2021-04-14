//
//  DetailCommentsView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import UIKit

class DetailCommentsView: UIView {
    var labelModels: [ContentLabelTextModel]?
    var totalNumber = 0

    var contentLabels = [ContentLabel]()
    let totalLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Public Methods

extension DetailCommentsView {
    func reload(labelModels: [ContentLabelTextModel], totalNumber: Int) {
        self.labelModels = labelModels
        self.totalNumber = totalNumber

        if contentLabels.count > labelModels.count {
            for i in labelModels.count ..< contentLabels.count {
                contentLabels[i].removeFromSuperview()
            }
        }
        while contentLabels.count < labelModels.count {
            contentLabels.append(ContentLabel())
        }
        for (index, model) in labelModels.enumerated() {
            let label = contentLabels[index]
            label.textModel = model
            addSubview(label)
        }
        if totalNumber > labelModels.count {
            addSubview(totalLabel)
            totalLabel.attributedText = DetailCommentsView.totalAttributedString(totalNumber: totalNumber)
        } else {
            totalLabel.removeFromSuperview()
        }

        setNeedsLayout()
    }

    class func height(for labelModels: [ContentLabelTextModel], totalNumber: Int, commentsWidth: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0

        totalHeight += 10 // 上边距

        for model in labelModels {
            let labelHeight = height(string: model.text, commentsWidth: commentsWidth)
            totalHeight += (labelHeight + 10)
        }

        if totalNumber > labelModels.count {
            let totalString = totalAttributedString(totalNumber: totalNumber)
            let labelHeight = height(string: totalString, commentsWidth: commentsWidth)
            totalHeight += (labelHeight + 10)
        }

        return totalHeight
    }
}

// MARK: - Private Methods

private extension DetailCommentsView {
    func setupSubviews() {
        backgroundColor = UIColor.sc.color(RGBA: 0xEFEFF4FF)
        layer.cornerRadius = 5

        totalLabel.textAlignment = .left
        totalLabel.font = UIFont.systemFont(ofSize: 16)
        totalLabel.textColor = UIColor.sc.color(RGBA: 0x0099FFFF)
    }

    func setupLayout() {
        guard let labelModels = labelModels,
              labelModels.count <= contentLabels.count else {
            return
        }

        var lastBottom: CGFloat = 0.0

        for (index, model) in labelModels.enumerated() {
            let labelHeight = DetailCommentsView.height(string: model.text, commentsWidth: width)
            let label = contentLabels[index]
            label.frame = CGRect(x: 10, y: lastBottom + 10, width: width - 20, height: labelHeight)
            lastBottom = label.bottom
        }

        if totalNumber > labelModels.count {
            let totalString = DetailCommentsView.totalAttributedString(totalNumber: totalNumber)
            let labelHeight = DetailCommentsView.height(string: totalString, commentsWidth: width)
            totalLabel.frame = CGRect(x: 10, y: lastBottom + 10, width: width - 20, height: labelHeight)
            lastBottom = totalLabel.bottom
        }
    }

    class func height(string: NSAttributedString, commentsWidth: CGFloat) -> CGFloat {
        return string.sc.height(labelWidth: commentsWidth - 20)
    }

    class func totalAttributedString(totalNumber: Int) -> NSAttributedString {
        let totalString = String(format: "共 %d 条回复 >", totalNumber)
        return NSAttributedString(string: totalString)
    }
}
