//
//  StatusHomeViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/14.
//

import Kingfisher
import UIKit

class StatusHomeViewController: StatusListViewController {
    let avatarView = AccountAvatarView()
    let titleButton = HomeTitleButton()
    
    let service = StatusHomeService()

    var groupModels: [GroupModel]? {
        didSet {
            groupModels?.insert(GroupModel(gid: nil, name: "主页"), at: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupNavigationButtons()
        service.fetchFeedGroup { groupModels in
            self.groupModels = groupModels
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI

private extension StatusHomeViewController {
    func setupSubviews() {
        listViewModel.listService = service
//        refreshData(with: true)
    }

    func setupNavigationButtons() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(sender:)))
        avatarView.addGestureRecognizer(tap)

        if let urlString = AccountManager.shared.user?.avatar,
           let url = URL(string: urlString) {
            // 如果直接把image给imageView，view会自动根据image大小而变化，原因未知，所以这里把image缩放为指定大小
            ImageDownloader.default.downloadImage(with: url) { result in
                switch result {
                case let .success(imageResult):
                    self.avatarView.image = imageResult.image.sc.compressImage(to: CGSize(width: 30, height: 30))
                default:
                    self.avatarView.image = nil
                }
            }
        } else {
            avatarView.image = nil
        }

        avatarView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let leftButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = leftButton

        let queryButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(queryButtonDidClicked(sender:)))
        let writeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItems = [writeButton, queryButton]

        navigationItem.title = "主页"
        titleButton.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
        titleButton.addTarget(self, action: #selector(titleButtonDidClicked(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}

// MARK: - Actions

@objc private extension StatusHomeViewController {
    func avatarDidClicked(sender: Any) {
        print("avatarDidClicked")
    }

    func queryButtonDidClicked(sender: Any) {
        print("queryButtonDidClicked")
    }

    func writeButtonDidClicked(sender: Any) {
        print("writeButtonDidClicked")
        let status = StatusResponse()
        status.id = 4627999674073543
        Router.open(url: "pillar://statusDetail", userInfo: ["status": status])
    }

    func titleButtonDidClicked(sender: Any) {
        guard let groupModels = groupModels,
              groupModels.count > 0 else {
            return
        }
        titleButton.isSelected = !titleButton.isSelected

        StatusFriendGroupController.showGroupController(groupList: groupModels) { [weak self] groupModel in
            self?.titleButton.isSelected = false
            self?.service.gid = groupModel?.gid
            self?.titleButton.title = groupModel?.name
        }
    }
}

class AccountAvatarView: UIImageView {
    lazy var defaultImage = UIImage(named: "avatar_default_big")?.sc.compressImage(to: CGSize(width: 30, height: 30))

    override var image: UIImage? {
        didSet {
            if image == nil {
                image = defaultImage
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.sc.color(RGBA: 0x7F7F7F4D).cgColor
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = width / 2
    }
}

class HomeTitleButton: UIButton {
    override var isSelected: Bool {
        didSet {
            let transform = isSelected ? CATransform3DRotate(CATransform3DIdentity, CGFloat.pi, 1, 0, 0) : CATransform3DIdentity
            UIView.animate(withDuration: 0.2) {
                self.imageView?.transform3D = transform
            }
        }
    }
    
    var title: String? {
        set (title) {
            let attrTitle = NSAttributedString(string: title ?? "", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
            setAttributedTitle(attrTitle, for: .normal)
        }
        get {
            return attributedTitle(for: .normal)?.string
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title = "主页"
        setImage(UIImage(named: "DownArrow_Normal"), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.center = center
        imageView?.center = CGPoint(x: (titleLabel?.right ?? 0) + (imageView?.width ?? 0) / 2, y: titleLabel?.centerY ?? 0)
    }
}
