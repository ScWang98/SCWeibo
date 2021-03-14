//
//  StatusPicturesView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import SKPhotoBrowser
import UIKit

class StatusPicturesView: UIView {
    var urls = [StatusPicturesModel]()
    var picViews = [UIImageView]()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func reload(with picUrls: [StatusPicturesModel]) {
        self.urls = picUrls
        setupPictures()

        for (index, url) in urls.enumerated() {
            let imageView = picViews[index]
            let imageURL = URL(string: url.thumbnailPic)
            imageView.kf.setImage(with: imageURL)

            // 处理gif图片
            guard let gifImageView = imageView.subviews.first else {
                return
            }
            let isGif = imageURL?.pathExtension == "gif"

            gifImageView.isHidden = !isGif
        }

        setNeedsLayout()
    }

    static func height(for picUrls: [StatusPicturesModel]) -> CGFloat {
        var picHeight: CGFloat = 0
        let contentWidth = UIScreen.sc.screenWidth - 12 * 2
        if picUrls.count <= 0 {
            picHeight = 0
        } else if picUrls.count <= 6 {
            picHeight = contentWidth * 2 / 3
        } else {
            picHeight = contentWidth
        }
        return picHeight
    }
}

private extension StatusPicturesView {
    func setupLayout() {
        if picViews.count <= 0 {
        } else if picViews.count <= 1 {
            picViews.first?.frame = self.bounds
        } else if picViews.count <= 2 {
            picViews.first?.frame = CGRect(x: 0, y: 0, width: self.width / 2 - 2, height: self.height)
            picViews.last?.frame = CGRect(x: self.width / 2 + 2, y: 0, width: self.width / 2 - 2, height: self.height)
        } else if picViews.count <= 3 {
            var view = picViews[0]
            view.frame = CGRect(x: 0, y: 0, width: self.width / 2 - 2, height: self.height)
            view = picViews[1]
            view.frame = CGRect(x: 0, y: 0, width: self.width / 2 - 2, height: self.height / 2 - 2)
            view = picViews[2]
            view.frame = CGRect(x: self.width / 2 + 2, y: self.height / 2 + 2, width: self.width / 2 - 2, height: self.height / 2 - 2)
        } else if picViews.count <= 4 {
            let width = self.width / 2 - 2
            let height = self.height / 2 - 2
            var view = picViews[0]
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view = picViews[1]
            view.frame = CGRect(x: width + 4, y: 0, width: width, height: height)
            view = picViews[2]
            view.frame = CGRect(x: 0, y: height + 4, width: width, height: height)
            view = picViews[3]
            view.frame = CGRect(x: width + 4, y: height + 4, width: width, height: height)
        } else {
            let length = (self.width - 4 * 2) / 3
            for (index, view) in picViews.enumerated() {
                let row = CGFloat(index / 3)
                let col = CGFloat(index % 3)
                view.frame = CGRect(x: col * (length + 4), y: row * (length + 4), width: length, height: length)
            }
        }
    }

    // TODO: 此处频繁添加删除view，待改进
    func setupPictures() {
        while picViews.count > urls.count {
            picViews.popLast()?.removeFromSuperview()
        }
        while picViews.count < urls.count && picViews.count < 9 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "timeline_icon_ip")
            imageView.isUserInteractionEnabled = true
            imageView.tag = picViews.count
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap(tap:)))
            imageView.addGestureRecognizer(tap)
            imageViewAddGif(parentView: imageView)
            addSubview(imageView)
            picViews.append(imageView)
        }
    }

    private func imageViewAddGif(parentView: UIImageView) {
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        gifImageView.isHidden = true
        parentView.addSubview(gifImageView)
        gifImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }

    @objc func imageViewDidTap(tap: UITapGestureRecognizer) {
        guard let index = tap.view?.tag, index < self.urls.count else {
            return
        }

        var images = [SKPhoto]()
        for url in self.urls {
            let photo = SKPhoto.photoWithImageURL(url.originalPic)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        }

        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(index)
        let vc = ResponderHelper.topViewController(for: self)
        vc.present(browser, animated: true, completion: nil)
    }
}
