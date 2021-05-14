//
//  StatusDetailToolbar.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/14.
//

import UIKit

class StatusDetailToolbar: UIView {
    var viewModel: StatusDetailViewModel?
    var toolBar = UIToolbar()
    
    private let repostButton = ToolbarButton()
    private let commentButton = ToolbarButton()
    private let favoriteButton = ToolbarButton()
    private let likeButton = ToolbarButton()

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
    
    func reload(with viewModel: StatusDetailViewModel) {
        self.viewModel = viewModel

        favoriteButton.isSelected = viewModel.favorited
        likeButton.isSelected = viewModel.liked

        setNeedsLayout()
    }

}

private extension StatusDetailToolbar {
    func setupSubviews() {
        let images = [["btn": repostButton,
                       "image": "RepostBarButton_Normal",
                       "type": ToolButtonType.repost],
                      ["btn": commentButton,
                       "image": "CommentBarButton_Normal",
                       "type": ToolButtonType.comments],
                      ["btn": favoriteButton,
                       "image": "FavoriteBarButton_Normal",
                       "type": ToolButtonType.favorite,
                       "imageSelected": "FavoriteBarButtonSelected_Normal"],
                      ["btn": likeButton,
                       "image": "LikeBarButton_Normal",
                       "type": ToolButtonType.like,
                       "imageSelected": "LikedBarButton_Normal"]]

        var items = [UIBarButtonItem]()
        for obj in images {
            guard let btn = obj["btn"] as? ToolbarButton else {
                continue
            }
            if let imageName = obj.sc.string(for: "image") {
                let normalImage = UIImage(named: imageName)
                btn.setImage(normalImage, for: .normal)
            }
            if let imageName = obj.sc.string(for: "imageSelected") {
                let selectedImage = UIImage(named: imageName)
                btn.setImage(selectedImage, for: .selected)
            }
            if let type = obj["type"] as? ToolButtonType {
                btn.toolButtonType = type
            }
            
            btn.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

            btn.addTarget(self, action: #selector(buttonDidClicked(button:)), for: .touchUpInside)

            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            items.append(UIBarButtonItem(customView: btn))
        }
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))

        toolBar.items = items
        addSubview(toolBar)
    }

    func setupLayout() {
        toolBar.anchorToEdge(.top, padding: 0, width: self.width, height: 44)
    }
    
    @objc private func buttonDidClicked(button: UIButton) {
        guard let toolBarButton = (button as? ToolbarButton),
              let type = toolBarButton.toolButtonType else {
            return
        }
        switch type {
        case .repost:
            viewModel?.sendRepostAction()
        case .comments:
            viewModel?.sendCommentAction()
        case .favorite:
            let favorited = !toolBarButton.isSelected
            toolBarButton.setIsSelected(favorited, animated: true)
            viewModel?.favorited = favorited
            viewModel?.sendFavoriteAction(favorited: favorited)
        case .like:
            let liked = !toolBarButton.isSelected
            toolBarButton.setIsSelected(liked, animated: true)
            viewModel?.liked = liked
            viewModel?.sendLikeAction(liked: liked)
        }
    }
}

private enum ToolButtonType {
    case repost
    case comments
    case favorite
    case like
}

private class ToolbarButton: UIButton {
    var toolButtonType: ToolButtonType?

//    override func layoutSubviews() {
//
//        if let imageView = imageView {
//            let transform = imageView.transform
//            imageView.transform =
//            imageView.anchorInCenter(width: imageView.width, height: imageView.height)
//        }
//    }
    
    func setIsSelected(_ isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        
        if !animated {
            return
        }
        
//        self.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//        UIView.animate(withDuration: 2) {
//            self.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
//        } completion: { (complete) in
//            self.isSelected = isSelected
//            if complete {
//                UIView.animate(withDuration: 2) {
//                    self.transform = CGAffineTransform.identity
//                }
//            }
//        }
    }
}
