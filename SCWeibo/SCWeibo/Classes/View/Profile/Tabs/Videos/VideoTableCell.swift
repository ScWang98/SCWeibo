//
//  VideoTableCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit
import AVKit

class VideoTableCell: UITableViewCell {
    var viewModel: VideoCellViewModel?

    let playIcon = UIImageView()
    let coverView = UIImageView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let bottomSeperator = UIView()

    var playerObservation: NSKeyValueObservation?
    
    deinit {
        playerObservation?.invalidate()
    }

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
        self.viewModel = viewModel

        if let urlString = viewModel.coverUrl {
            let coverURL = URL(string: urlString)
            coverView.kf.setImage(with: coverURL)
        } else {
            coverView.image = nil
        }

        titleLabel.text = viewModel.text
        timeLabel.text = viewModel.createdAt

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension VideoTableCell {
    func setupSubviews() {
//        playIcon.image = UIImage(named: "")

        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        coverView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidClicked(tab:)))
        coverView.addGestureRecognizer(tap)
        coverView.addSubview(playIcon)

        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        bottomSeperator.backgroundColor = UIColor.sc.color(RGBA: 0xF2F2F2FF)

        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(bottomSeperator)
    }

    func setupLayout() {
        let width = self.width - 12.0 * 2
        let coverHeight = self.width * 9.0 / 16.0
        coverView.anchorToEdge(.top, padding: 12.0, width: width, height: coverHeight)
        titleLabel.align(.underCentered, relativeTo: coverView, padding: 2, width: width, height: 23.0)
        timeLabel.align(.underCentered, relativeTo: titleLabel, padding: 0, width: width, height: 23.0)
        bottomSeperator.anchorToEdge(.bottom, padding: 0.0, width: self.width, height: 8.0)
    }
}

@objc private extension VideoTableCell {
    func coverViewDidClicked(tab: UITapGestureRecognizer) {
        guard let urlString = viewModel?.videoUrl,
              let url = URL(string: urlString) else {
            return
        }
        
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        playerVC.allowsPictureInPicturePlayback = true
        
        self.sc.viewController?.present(playerVC, animated: true, completion: {
            if playerVC.isReadyForDisplay {
                playerVC.player?.play()
            }
        })
        
        self.playerObservation = playerVC.observe(\.isReadyForDisplay) { (obj, change) in
            if change.newValue == true {
                playerVC.player?.play()
            }
        }
    }
}
