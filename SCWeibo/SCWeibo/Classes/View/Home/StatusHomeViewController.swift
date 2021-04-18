//
//  StatusHomeViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/14.
//

import UIKit

class StatusHomeViewController: StatusListViewController {
    let avatarView = AccountAvatarView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupNavigationButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI

private extension StatusHomeViewController {
    func setupSubviews() {
        listViewModel.listService = StatusHomeListService()
//        refreshData(with: true)
    }

    func setupNavigationButtons() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(sender:)))
        avatarView.addGestureRecognizer(tap)
        let leftButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = leftButton

        let queryButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(queryButtonDidClicked(sender:)))
        let writeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItems = [writeButton, queryButton]

        navigationItem.title = "主页"
        let titleButton = HomeTitleButton(frame: CGRect(x: 0, y: 0, width: 70, height: 21))
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
        Router.open(url: "pillar://statusDetail")
    }

    func titleButtonDidClicked(sender: Any) {
        print("writeButtonDidClicked")
        Router.open(url: "pillar://statusDetail")
    }
}

class AccountAvatarView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.sc.color(RGBA: 0x7F7F7F4D).cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = width / 2
    }
}

class HomeTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let title = NSAttributedString(string: "主页", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        setAttributedTitle(title, for: .normal)
        setImage(UIImage(named: "DownArrow_Normal"), for: .normal)
        addTarget(self, action: #selector(buttonDidClicked(sender:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.center = center
        imageView?.center = CGPoint(x: (titleLabel?.right ?? 0) + (imageView?.width ?? 0) / 2, y: titleLabel?.centerY ?? 0)
    }

    @objc func buttonDidClicked(sender: Any) {
        isSelected = !isSelected
        let transform = imageView?.transform3D ?? CATransform3DIdentity
        UIView.animate(withDuration: 0.2) {
            self.imageView?.transform3D = CATransform3DRotate(transform, CGFloat.pi, 1, 0, 0)
        }
    }
}
