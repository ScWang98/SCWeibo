//
//  VideoTableCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit

class VideoTableCell: UITableViewCell {
    var viewModel: VideoCellViewModel?
    
    var coverView = UIImageView()
    var titleLabel = UILabel()
    var timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Public Methods

extension VideoTableCell {
    func reload(with viewModel: VideoCellViewModel) {
        

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension VideoTableCell {
    func setupSubviews() {
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        timeLabel.textColor = UIColor(rgb: 0xAAAAAA)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(coverView)
        addSubview(titleLabel)
        addSubview(timeLabel)
    }

    func setupLayout() {
        
    }
}
