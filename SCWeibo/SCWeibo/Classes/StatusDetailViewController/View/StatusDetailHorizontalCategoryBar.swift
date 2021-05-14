//
//  StatusDetailHorizontalCategoryBar.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/17.
//

import UIKit

class StatusDetailHorizontalCategoryBarItem {
    var name: String?
    var index: Int?
}

protocol StatusDetailHorizontalCategoryCellDelegate: class {
    func cellDidClicked(_ cell: StatusDetailHorizontalCategoryCell)
}

class StatusDetailHorizontalCategoryCell: UIView {
    weak var delegate: StatusDetailHorizontalCategoryCellDelegate?
    var item: StatusDetailHorizontalCategoryBarItem?
    var selected = false {
        willSet {
            titleLabel.textColor = newValue ? UIColor.sc.color(RGBA: 0x0099FFFF) : UIColor.sc.color(RGBA: 0x91CAFAFF)
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }

    func reload(item: StatusDetailHorizontalCategoryBarItem) {
        self.item = item
        titleLabel.text = item.name
    }

    private func setupSubviews() {
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedAction(_:))))
        addSubview(titleLabel)
    }
    
    class func cellWidth(text: String?) -> CGFloat {
        guard let text = text else {
            return 0
        }
        let rect = (text as NSString).boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin], attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil)
        return ceil(rect.width) + 20
    }

    @objc private func clickedAction(_ sender: Any) {
        delegate?.cellDidClicked(self)
    }
}

protocol StatusDetailHorizontalCategoryBarDelegate: class {
    func categoryBar(_ categoryBar: StatusDetailHorizontalCategoryBar, didSelectItemAt index: Int)
}

class StatusDetailHorizontalCategoryBar: UIView {
    weak var delegate: StatusDetailHorizontalCategoryBarDelegate?

    var indicator = UIView()
    var bottomLine = UIView()

    var cells = [StatusDetailHorizontalCategoryCell]()

    var needDivider = false

    var lastSelectedCell: StatusDetailHorizontalCategoryCell?
    var currentSelectedIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var lastRight: CGFloat = 10
        for index in 0 ..< cells.count - 1 {
            let cell = cells[index]
            let width = StatusDetailHorizontalCategoryCell.cellWidth(text: cell.item?.name)
            cell.frame = CGRect(x: lastRight, y: 0, width: width, height: self.height)
            lastRight = cell.right
        }
        
        if let cell = cells.last {
            let width = StatusDetailHorizontalCategoryCell.cellWidth(text: cell.item?.name)
            cell.frame = CGRect(x: self.width - 10 - width, y: 0, width: width, height: self.height)
        }
        
        let lineHeight = 1 / UIScreen.main.scale
        self.bottomLine.anchorToEdge(.bottom, padding: 0, width: self.width, height: lineHeight)
        
        if let cell = self.lastSelectedCell {
            self.indicator.frame = CGRect(x: cell.left + 10, y: self.height - 3 - lineHeight, width: cell.width - 20, height: 3)
        }
    }

    private func setupSubviews() {
        indicator.backgroundColor = UIColor.sc.color(RGBA: 0x0099FFFF)
        bottomLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)
        addSubview(indicator)
        addSubview(bottomLine)
    }

    func reload(names: [String]) {
        var items = [StatusDetailHorizontalCategoryBarItem]()
        for name in names {
            let item = StatusDetailHorizontalCategoryBarItem()
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
            cells.append(StatusDetailHorizontalCategoryCell())
        }
        for (index, item) in items.enumerated() {
            item.index = index
        }

        for (index, cell) in cells.enumerated() {
            let item = items[index]
            cell.reload(item: item)
            cell.selected = false
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
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            self.setNeedsLayout()
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

extension StatusDetailHorizontalCategoryBar: StatusDetailHorizontalCategoryCellDelegate {
    func cellDidClicked(_ cell: StatusDetailHorizontalCategoryCell) {
        guard let index = cell.item?.index, 0 <= index, index < cells.count else { return }
        selectItem(at: index, animated: true)
        delegate?.categoryBar(self, didSelectItemAt: index)
    }
}
