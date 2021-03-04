//
//  HorizontalCategoryBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/2.
//  Copyright © 2021 scwang. All rights reserved.
//

import UIKit

class HorizontalCategoryBarItem {
    var name: String?
    var index: Int?
}

protocol HorizontalCategoryCellDelegate {
    func cellDidClicked(_ cell: HorizontalCategoryCell)
}

class HorizontalCategoryCell: UIView {
    var delegate: HorizontalCategoryCellDelegate?
    var item: HorizontalCategoryBarItem?
    var selected = false {
        willSet {
            if self.selected == newValue {
                return
            }
            titleLabel.textColor = newValue ? UIColor.blue : UIColor.black
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }

    func reload(item: HorizontalCategoryBarItem) {
        self.item = item
        titleLabel.text = item.name
    }

    private func setupSubviews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedAction(_:))))
        addSubview(titleLabel)
    }

    @objc private func clickedAction(_ sender: Any) {
        delegate?.cellDidClicked(self)
    }
}

protocol HorizontalCategoryBarDelegate {
    func categoryBar(_ categoryBar: HorizontalCategoryBar, didSelectItemAt index: Int)
}

class HorizontalCategoryBar: UIView {
    var delegate: HorizontalCategoryBarDelegate?

    var indicator = UIView()

    var cells = [HorizontalCategoryCell]()

    var needDivider = false

    var lastSelectedCell: HorizontalCategoryCell?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupSubviews() {
        indicator.backgroundColor = UIColor.blue
        indicator.frame = CGRect(x: 0, y: height - 4, width: 100, height: 4)
        addSubview(indicator)
    }

    func reload(items: [HorizontalCategoryBarItem]) {
        for cell in cells {
            cell.removeFromSuperview()
        }
        while cells.count > items.count {
            cells.removeLast()
        }
        while cells.count < items.count {
            cells.append(HorizontalCategoryCell())
        }
        for (index, item) in items.enumerated() {
            item.index = index
        }

        let cellWidth = self.width / CGFloat(items.count)
        for (index, cell) in cells.enumerated() {
            let item = items[index]
            cell.reload(item: item)
            if let idx = item.index {
                cell.frame = CGRect(x: cellWidth * CGFloat(idx), y: 0, width: cellWidth, height: height)
            }
            cell.delegate = self
            addSubview(cell)
        }
        indicator.frame = CGRect(x: indicator.x, y: self.height - 4, width: cellWidth - 12, height: indicator.height)
    }

    func selectItem(at index: Int, animated: Bool = false) {
        guard 0 <= index && index < cells.count else {
            return
        }

        lastSelectedCell?.selected = false
        lastSelectedCell = cells[index]
        lastSelectedCell?.selected = true

        if animated {
            UIView.animate(withDuration: 0.15) {
                self.indicator.center = CGPoint(x: self.cells[index].center.x, y: self.indicator.center.y)
            }
        } else {
            self.indicator.center = CGPoint(x: self.cells[index].center.x, y: self.indicator.center.y)
        }
    }

    func scrollSelected(fromIndex: Int, toIndex: Int, percent: Double) {
        guard 0 <= fromIndex && fromIndex < cells.count,
              0 <= toIndex && toIndex < cells.count else {
            return
        }

        let startX = cells[fromIndex].center.x
        let endX = cells[toIndex].center.x
        let indicatorCenterX = startX + (endX - startX) * CGFloat(percent)
        indicator.center = CGPoint(x: indicatorCenterX, y: indicator.center.y)
    }
}

extension HorizontalCategoryBar: HorizontalCategoryCellDelegate {
    func cellDidClicked(_ cell: HorizontalCategoryCell) {
        guard let index = cell.item?.index, 0 <= index, index < cells.count else { return }
        selectItem(at: index, animated: true)
        delegate?.categoryBar(self, didSelectItemAt: index)
    }
}
