//
//  WriteStatusController.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/8.
//

import PhotosUI
import SVProgressHUD
import UIKit

enum WriteType {
    case writeStatus
    case repostStatus
    case commentStatus
    case commentComment
}

class WriteStatusController: UIViewController, RouteAble {
    private lazy var titleView = WriteTitleButton()

    var textView = WriteStatusTextView()
    var toolBar = UIToolbar()

    var imageUploadView = ImageUploadView()
    var referenceView = WriteReferenceView()
    lazy var emojiView: EmojiInputView = {
        let emojiView = EmojiInputView()
        emojiView.delegate = self
        return emojiView
    }()

    var referenceModel: WriteReferenceModel?
    var writeType: WriteType = WriteType.writeStatus

    var service = WriteStatusService()
    var currentKeyBoardHeight: CGFloat = 0

    lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("发布", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)

        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        btn.addTarget(self, action: #selector(sendButtonDidClicked), for: .touchUpInside)
        return btn
    }()

    required convenience init(routeParams: Dictionary<AnyHashable, Any>) {
        self.init(nibName: nil, bundle: nil)
        if let userInfo: [AnyHashable: Any] = routeParams.sc.dictionary(for: RouterParameterUserInfo) {
            if let writeType = userInfo["writeType"] as? WriteType {
                self.writeType = writeType
            }
            referenceModel = userInfo["referenceModel"] as? WriteReferenceModel
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        // 键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.becomeFirstResponder()
        service.fetchST()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
}

private extension WriteStatusController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupSubviews()
    }

    func setupSubviews() {
        view.backgroundColor = UIColor.sc.color(red: 248, green: 248, blue: 248)

        setupToolBar()

        textView.keyboardDismissMode = .onDrag
        textView.bounces = true
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        imageUploadView.delegate = self

        if let referenceModel = referenceModel {
            imageUploadView.isHidden = true
            referenceView.isHidden = false
            referenceView.reload(model: referenceModel, type: writeType)
        } else {
            imageUploadView.isHidden = false
            referenceView.isHidden = true
        }
        
        imageUploadView.isHidden = true
        referenceView.isHidden = true
        
        view.addSubview(toolBar)
        view.addSubview(textView)
        textView.addSubview(imageUploadView)
        textView.addSubview(referenceView)

        refreshLayout()
    }

    func setupToolBar() {
        let images = [["imageName": "compose_toolbar_picture", "actionName": "addImageButtonDidClicked"],
                      ["imageName": "compose_mentionbutton_background"],
                      ["imageName": "compose_trendbutton_background"],
                      ["imageName": "compose_emoticonbutton_background", "actionName": "emojiKeyboardDidTap"]]

        var items = [UIBarButtonItem]()
        for obj in images {
            guard let imageName = obj["imageName"] else {
                continue
            }

            let normalImage = UIImage(named: imageName)
            let hightLightImage = UIImage(named: imageName + "_highlight")
            let btn = UIButton()
            btn.setImage(normalImage, for: .normal)
            btn.setImage(hightLightImage, for: .highlighted)
            btn.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            btn.sizeToFit()

            // add event
            if let actionName = obj["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }

            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            items.append(UIBarButtonItem(customView: btn))
        }

        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        toolBar.items = items
    }

    func refreshLayout() {
        let bottomPadding = currentKeyBoardHeight > 0 ? currentKeyBoardHeight : view.safeAreaInsets.bottom
        toolBar.anchorToEdge(.bottom, padding: bottomPadding, width: view.width, height: 44)

        let height = toolBar.top - view.safeAreaInsets.top
        textView.anchorToEdge(.top, padding: view.safeAreaInsets.top, width: view.width, height: height)

        let textHeight = textView.attributedText.sc.height(labelWidth: textView.contentSize.width)
        imageUploadView.anchorToEdge(.top, padding: 200 + textHeight, width: view.width, height: imageUploadView.height)
        referenceView.anchorToEdge(.top, padding: 200 + textHeight, width: view.width, height: referenceView.height)
    }

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
        titleView.userName = AccountManager.shared.user?.screenName
        titleView.reload(type: writeType)
        navigationItem.titleView = titleView
    }
}

// MARK: - Upload Photos

extension WriteStatusController {
    func selectPhotos() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.filter = PHPickerFilter.images
            config.selectionLimit = 9
            let pickerController = PHPickerViewController(configuration: config)
            pickerController.delegate = self

            self.present(pickerController, animated: true, completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.delegate = self

            present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension WriteStatusController: ImageUploadViewDelegate {
    func addImageDidClicked(uploadView: ImageUploadView) {
        selectPhotos()
    }
}

extension WriteStatusController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        for item in results {
            group.enter()
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage,
                   error == nil {
                    self.imageUploadView.photos.append(image)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.imageUploadView.refreshData()
        }
    }
}

extension WriteStatusController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageUploadView.photos.append(image)
            imageUploadView.refreshData()
        }
    }
}

// MARK: - EmojiInputViewDelegate

extension WriteStatusController: EmojiInputViewDelegate {
    func emojiInputView(view: EmojiInputView, didSelectEmoji emoji: Emoji) {
        self.textView.insertEmoji(model: emoji)
    }
}

// MARK: - UITextViewDelegate

extension WriteStatusController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
        refreshLayout()
    }
}

// MARK: - Actions

@objc private extension WriteStatusController {
    @objc func keyboardWillChangeFrame(noti: Notification) {
        guard let rect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = noti.userInfo?.sc.double(for: UIResponder.keyboardAnimationDurationUserInfoKey) else {
            return
        }

        currentKeyBoardHeight = view.height - rect.origin.y

        UIView.animate(withDuration: duration) {
            self.refreshLayout()
        }
    }

    @objc func sendButtonDidClicked() {
        let completion: (_ success: Bool) -> Void = { success in
            SVProgressHUD.dismiss()
            if success {
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                self.dismissViewController()
            } else {
                SVProgressHUD.showError(withStatus: "发送失败")
            }
        }
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.8, alpha: 0.5))
        SVProgressHUD.show(withStatus: "正在发送")

        let text = textView.emojiText

        switch writeType {
        case .writeStatus:
            service.sendStatus(content: text, photos: imageUploadView.photos, visible: 1, completion: completion)
        case .repostStatus:
            if let id = referenceModel?.status?.retweetedStatus?.id {
                service.repostStatus(content: text, statusId: id, visible: 1, completion: completion)
            } else if let id = referenceModel?.status?.id {
                service.repostStatus(content: text, statusId: id, visible: 1, completion: completion)
            }
        case .commentStatus:
            if let id = referenceModel?.status?.id {
                service.createComment(content: text, statusId: id, completion: completion)
            }
        case .commentComment:
            if let statusId = referenceModel?.status?.id,
               let commentId = referenceModel?.comment?.id {
                service.replyComment(content: text, statusId: statusId, commentId: commentId, completion: completion)
            }
        }
    }

    // 点击表情键盘
    @objc func emojiKeyboardDidTap() {
        // 系统键盘 => textView.inputView = nil，这里是系统键盘和自定义键盘的切换
        textView.inputView = textView.inputView == nil ? emojiView : nil
        textView.reloadInputViews()
        textView.becomeFirstResponder()
    }

    @objc func addImageButtonDidClicked() {
        selectPhotos()
    }
}
