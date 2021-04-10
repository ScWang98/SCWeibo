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

protocol HorizontalCategoryCellDelegate: class {
    func cellDidClicked(_ cell: HorizontalCategoryCell)
}

class HorizontalCategoryCell: UIView {
    weak var delegate: HorizontalCategoryCellDelegate?
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

protocol HorizontalCategoryBarDelegate: class {
    func categoryBar(_ categoryBar: HorizontalCategoryBar, didSelectItemAt index: Int)
}

class HorizontalCategoryBar: UIView {
    weak var delegate: HorizontalCategoryBarDelegate?

    var indicator = UIView()

    var cells = [HorizontalCategoryCell]()

    var needDivider = false

    var lastSelectedCell: HorizontalCategoryCell?
    var currentSelectedIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellWidth = self.width / CGFloat(cells.count)
        for (index, cell) in cells.enumerated() {
            cell.frame = CGRect(x: cellWidth * CGFloat(index), y: 0, width: cellWidth, height: height)
        }
        if currentSelectedIndex < cells.count {
            self.indicator.frame = CGRect(x: self.cells[currentSelectedIndex].left + 10, y: self.height - 4, width: cellWidth - 20, height: 4)
        }
    }

    private func setupSubviews() {
        indicator.backgroundColor = UIColor.blue
        indicator.frame = CGRect(x: 0, y: height - 4, width: 100, height: 4)
        addSubview(indicator)
    }

    func reload(names: [String]) {
        var items = [HorizontalCategoryBarItem]()
        for name in names {
            let item = HorizontalCategoryBarItem()
            item.name = name
            items.append(item)
        }
        
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

        for (index, cell) in cells.enumerated() {
            let item = items[index]
            cell.reload(item: item)
            cell.delegate = self
            addSubview(cell)
        }
        setNeedsLayout()
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
                self.indicator.centerX = self.cells[index].center.x
            }
        } else {
            self.indicator.centerX = self.cells[index].center.x
        }
    }

    func scrollSelected(fromIndex: Int, toIndex: Int, percent: Double) {
        guard 0 <= fromIndex && fromIndex < cells.count,
            0 <= toIndex && toIndex < cells.count else {
            return
        }

        let startX = cells[fromIndex].center.x
        let endX = cells[toIndex].center.x
        indicator.centerX = startX + (endX - startX) * CGFloat(percent)
    }
}

extension HorizontalCategoryBar: HorizontalCategoryCellDelegate {
    func cellDidClicked(_ cell: HorizontalCategoryCell) {
        guard let index = cell.item?.index, 0 <= index, index < cells.count else { return }
        selectItem(at: index, animated: true)
        delegate?.categoryBar(self, didSelectItemAt: index)
    }
}
