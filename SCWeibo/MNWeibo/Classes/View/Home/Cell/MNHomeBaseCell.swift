//
//  MNHomeBaseCell.swift
//  MNWeibo
//
//  Created by miniLV on 2020/3/29.
//  Copyright © 2020 miniLV. All rights reserved.
//

import UIKit

@objc protocol MNHomeCellDelegate {
    @objc optional func homeCellDidClickUrlString(cell: MNHomeBaseCell, urlStr: String)
}

class MNHomeBaseCell: UITableViewCell {

    var viewModel: MNStatusViewModel?{
            didSet{
                contentLabel.attributedText = viewModel?.statusAttrText
    
                bottomView.viewModel = viewModel
                contentPictureView.viewModel = viewModel
                
                topActionBar.reload(viewModel: viewModel)
            }
        }
    
    var topActionBar = HomeCellTopActionBar()
    var contentLabel = MNLabel()
    var repostLabel = MNLabel()
    //toolButton
    var bottomView:MNStatusToolView = MNStatusToolView(parentView: nil)
    
    var contentPictureView = MNStatusPictureView(parentView: nil, topView: nil, bottomView: nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        // 异步绘制
        self.layer.drawsAsynchronously = true
        //栅格化 - 绘制之后生产独立的图像, 停止滚动可以交互
        self.layer.shouldRasterize = true
        //指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        contentLabel.delegate = self
        repostLabel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate:MNHomeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubviews(){
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        addSubview(topLineView)
        topLineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(MNLayout.Layout(MNStatusPictureOutterMargin))
        }
        
        addSubview(topActionBar)
        topActionBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(topLineView.snp.bottom)
            make.height.equalTo(50)
        }
        
        bottomView = MNStatusToolView(parentView: self)
        
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(15))
        contentLabel.textColor = UIColor.darkGray
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(topActionBar.snp.bottom).offset(MNLayout.Layout(MNStatusPictureOutterMargin))
        }
    }
}

extension MNHomeBaseCell : MNLabelDelegate{
    
    func labelDidSelectedLinkText(label: MNLabel, text: String) {
        if !text.hasPrefix("http"){
            return
        }
        delegate?.homeCellDidClickUrlString?(cell: self, urlStr: text)
    }
}
