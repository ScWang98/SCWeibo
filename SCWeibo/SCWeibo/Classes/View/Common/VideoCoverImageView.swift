//
//  VideoCoverImageView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/21.
//

import AVKit
import UIKit

class VideoCoverImageView: UIImageView {
    let playIcon = UIImageView()

    var model: StatusVideoModel?

    var playerObservation: NSKeyValueObservation?

    deinit {
        playerObservation?.invalidate()
    }

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func reload(model: StatusVideoModel?) {
        self.model = model

        if let urlString = model?.coverUrl {
            let coverURL = URL(string: urlString)
            kf.setImage(with: coverURL)
        } else {
            image = nil
        }
    }

    class func height(width: CGFloat) -> CGFloat {
        return width / 16.0 * 9.0
    }
}

private extension VideoCoverImageView {
    func commonInit() {
        playIcon.image = UIImage(named: "PlayVideo_Normal")
        addSubview(playIcon)

        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewDidClicked(tab:)))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

    func setupLayout() {
        playIcon.anchorInCenter(width: 44, height: 44)
    }

    @objc func coverViewDidClicked(tab: UITapGestureRecognizer) {
        guard let urlString = model?.videoUrl,
              let url = URL(string: urlString) else {
            return
        }

        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        playerVC.allowsPictureInPicturePlayback = true

        sc.viewController?.present(playerVC, animated: true, completion: {
            if playerVC.isReadyForDisplay {
                playerVC.player?.play()
            }
        })

        playerObservation?.invalidate()
        playerObservation = playerVC.observe(\.isReadyForDisplay) { _, change in
            if change.newValue == true {
                playerVC.player?.play()
            }
        }
    }
}
