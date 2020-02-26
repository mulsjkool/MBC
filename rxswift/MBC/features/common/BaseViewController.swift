//
//  BaseViewController.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/3/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MBProgressHUD
import SafariServices
import Reachability

class BaseViewController: UIViewController, ErrorDecorator {

    var disposeBag = DisposeBag()
    var navigator: Navigator?
    var onDisappearDisposables = [Disposable]()
    var isShowing = false
    var isShowLoading = false
    var progressHUB: MBProgressHUD?
    let didBackFromVideoContentPage = PublishSubject<Video?>()
    
    static let notificationName = "com.apple.system.config.network_change"
    let closeActivityVC = PublishSubject<Void>()
    
    @IBOutlet weak private var constraintTopScrollView: NSLayoutConstraint!
    
    private var startTime: TimeInterval = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.repeatCall(times: 2, withDelay: 0.1) {
            Constants.Singleton.isAInlineVideoPlaying = false
        }

        isShowing = true
        let className = "\(type(of: self))"
        NSLog("VIEW : \(self.title ?? self.navigationController?.title ?? className)")
        startTime = Date().timeIntervalSince1970
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isShowing = false
        
        Common.repeatCall(times: 2, withDelay: 0.1) {
            Constants.Singleton.isAInlineVideoPlaying = false
        }
        
    }
    
    var isUnderBundleContent: Bool {
        return parent is BundleContentViewController
    }

    func showError(message: String, completed: (() -> Void)?) {
        if isShowLoading {
            progressHUB?.hide(animated: true)
            if !message.isEmpty {
                alert(title: nil, message: message, completed: completed)
            }
        } else {
            if !message.isEmpty {
                alert(title: nil, message: message, completed: completed)
            }
        }
    }

    func showMessage(message: String) {
        if isShowLoading {
            progressHUB?.hide(animated: true)
            alert(title: nil, message: message, completed: nil)
        } else {
            alert(title: nil, message: message, completed: nil)
        }
    }
    
    func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction) {
        let alert = UIAlertController(title: R.string.localizable.commonAlertTitleMessage(),
                                      message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: leftAction.title,
                                          style: .default, handler: { _ in leftAction.handler() }))

        alert.addAction(UIAlertAction(title: rightAction.title,
                                      style: .default, handler: { _ in rightAction.handler() }))

        self.present(alert, animated: true, completion: nil)
    }

    func showLoading(status: String, showInView: UIView?) {
        isShowLoading = true
        var viewContent: UIView = self.view
        
        if let view = showInView {
            viewContent = view
        }
        
        if status.isEmpty {
            let hub = MBProgressHUD.showAdded(to: viewContent, animated: true) as MBProgressHUD
            hub.mode = MBProgressHUDMode.indeterminate
            progressHUB = hub
        } else {
            let hub = MBProgressHUD.showAdded(to: viewContent, animated: true) as MBProgressHUD
            hub.mode = MBProgressHUDMode.text
            hub.label.text = status
            progressHUB = hub
        }
    }

    func hideLoading(showInView: UIView?) {
        isShowLoading = false
        var viewContent: UIView = self.view
        
        if let view = showInView {
            viewContent = view
        }
        
        MBProgressHUD.hide(for: viewContent, animated: true)
    }

    func alert(title: String?, message: String, action: AlertAction) {
        let alert = UIAlertController(title: title ?? R.string.localizable.commonAlertTitleMessage(),
                                      message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: action.title,
                                      style: .default, handler: { _ in action.handler() }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String?, message: String, actions: [AlertAction]) {
        let alert = UIAlertController(title: title ?? R.string.localizable.commonAlertTitleMessage(),
                                      message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title,
                                          style: .default, handler: { _ in action.handler() }))
        }

        self.present(alert, animated: true, completion: nil)
    }

    func alert(title: String?, message: String, completed: (() -> Void)?) {
        let okAction = AlertAction(title: R.string.localizable.commonButtonTextOk(),
                                   handler: { completed?() })

        alert(title: title, message: message, action: okAction)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Common.setStatusBarColor(Colors.dark.color())
//        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkChange),
//                                               name: Notification.Name.reachabilityChanged, object: nil)
        
        if #available(iOS 11.0, *) { } else {
            if let constraint = constraintTopScrollView {
                constraint.constant += Constants.DeviceMetric.statusBarHeight
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let duration = Date().timeIntervalSince1970 - startTime
        NSLog("DID APPEAR in : \(String(format: "%.3f", duration)) seconds")

        subscribeOnAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeOnDisappear()
    }

    func subscribeOnAppear() {

    }

    private func disposeOnDisappear() {
        onDisappearDisposables.forEach { disposable in
            disposable.dispose()
        }
    }

    func insertToClearOnDisappear(disposable: Disposable) {
        onDisappearDisposables.append(disposable)
        disposeBag.insert(disposable)
    }
    
    func showHideNavigationBar(shouldHide: Bool, animated: Bool = true) {
        if Constants.Singleton.isiPad { return }
        self.navigationController?.setNavigationBarHidden(shouldHide, animated: animated)
    }
	
    func showFullscreenImage(_ feed: Feed, accentColor: UIColor?, pageId: String = "", imageIndex: Int = 0,
                             imageId: String = "") {
		let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.modalPresentationStyle = .overCurrentContext
        fullScreenImagePost.bindData(feed, imageIndex: imageIndex, imageId: imageId, accentColor: accentColor)
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController?.present(fullScreenImagePost, animated: true)
        }
	}
	
	func showFullscreenImage(_ medias: ItemList, accentColor: UIColor?, imageIndex: Int = 0) {
		let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.modalPresentationStyle = .overCurrentContext
        fullScreenImagePost.bindData(medias, imageIndex: imageIndex, accentColor: accentColor)
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController?.present(fullScreenImagePost, animated: true)
        }
	}
    
    func showPopupComment(pageId: String?, contentId: String?, contentType: String) {
        let commentVC = CommentViewController()
        commentVC.bindData(pageId: pageId, contentId: contentId, contentType: contentType)
        self.present(commentVC, animated: true, completion: nil)
    }
	
	func showPopupRadioChannel(pageDetail: PageDetail) {
		let radioChannelVC = RadioChannelViewController()
		radioChannelVC.bindData(pageDetail: pageDetail)
		let navigationController = MainNavigationController(rootViewController: radioChannelVC)
		radioChannelVC.navigator = Navigator(navigationController: navigationController)
		self.present(navigationController, animated: true, completion: nil)
	}
	
	// open full screen image from default album
    func showFullscreenImageDefaultAlbum(defaultAlbum: PhotoDefaultAlbum) {
		let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.modalPresentationStyle = .overCurrentContext
        fullScreenImagePost.bindDefaultAlbumData(defaultAlbum: defaultAlbum)
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController?.present(fullScreenImagePost, animated: true)
        }
	}
	
	// open full screen image from custom album
    func showFullScreenImageFromCustomAlbum(customAlbum: PhotoCustomAlbum) {
		let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.modalPresentationStyle = .overCurrentContext
        fullScreenImagePost.bindCustomAlbumData(customAlbum: customAlbum)
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController?.present(fullScreenImagePost, animated: true)
        }
	}
    
    // open full screen image from cover or poster image
    func showFullScreenImageFrom(imageUrl: String, pageId: String, accentColor: UIColor?, author: Author) {
        let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.modalPresentationStyle = .overCurrentContext
        fullScreenImagePost.bindDataFrom(imageUrl: imageUrl, pageId: pageId, accentColor: accentColor, author: author)
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController?.present(fullScreenImagePost, animated: true)
        }
        fullScreenImagePost.removeLikeAndCommentButton()
    }
    // open specific channel
    func showSpecificChannelSchedule(schedulerOnChannel: SchedulerOnChannel, daySelectedIndex: Int) {
        let specificChannelSchedule: SpecificChannelScheduleViewController = SpecificChannelScheduleViewController()
        specificChannelSchedule.bindData(schedulerOnChannel: schedulerOnChannel, daySelectedIndex: daySelectedIndex)
        self.present(specificChannelSchedule, animated: true)
    }
    
    // Use in Login VC, Sign up VC, Forgot password VC
    func setErrorTextAndErrorStatus(errorLabel: UILabel, textField: UITextField, text: String) {
        errorLabel.text = text
        let color = text.isEmpty ? Colors.unselectedTabbarItem.color().cgColor
            : Colors.defaultAccentColor.color().cgColor
        textField.layer.borderColor = color
    }
    
    // TO BE REMOVED
    func createDummyCellWith(title: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = Colors.defaultBg.color(alpha: 0.5)
        cell.textLabel?.text = title
        return cell
    }

    func addBackButton() {
        let rtl = Constants.DefaultValue.shouldRightToLeft
        let backButton = UIBarButtonItem(image: R.image.iconNavigationArrowBack(), style: .plain, target: self,
                                         action: #selector(self.backButtonPressed))
        if !rtl { navigationItem.leftBarButtonItem = backButton } else {
            navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.rightBarButtonItem = backButton
        }
    }
    
    func addMenuBackButton() {
        let rtl = Constants.DefaultValue.shouldRightToLeft
        let backImage = rtl ? R.image.iconNavigationArrowBackRotated() : R.image.iconNavigationArrowBack()
        let backButton = UIBarButtonItem(image: backImage, style: .plain,
                                         target: self, action: #selector(self.dismissSideMenu))
        rtl ? (navigationItem.rightBarButtonItem = backButton) : (navigationItem.leftBarButtonItem = backButton)
    }
    
    func addMenuBackButtonForiPhone() {
        let rtl = Constants.DefaultValue.shouldRightToLeft
        let backButton = UIBarButtonItem(image: R.image.iconNavigationArrowBack(), style: .plain, target: self,
                                         action: #selector(self.backMenuButtonPressed))
        if !rtl { navigationItem.leftBarButtonItem = backButton } else {
            navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.rightBarButtonItem = backButton
        }
    }
    
    @objc
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func backMenuButtonPressed() {
        defaultNotification.post(name: Keys.Notification.openPreviousTab, object: nil)
    }
    
    @objc
    func dismissSideMenu(_ programmatically: Bool = false) {
        guard Constants.Singleton.isiPad, self is MenuViewController else { return }
        if programmatically { Common.setCustomSideMenuAnimation(toReset: false) }
        dismiss(animated: true) {
            Common.setCustomSideMenuAnimation()
        }
    }
    
    func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                viewPortHeight: CGFloat,
                                isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        // swiftlint:disable fatal_error
        fatalError("Please override me")
    }
    
    // MARK: Close button
    
    func addCloseButton() {
        let rtl = Constants.DefaultValue.shouldRightToLeft
        let backButton = UIBarButtonItem(image: R.image.iconHomestreamClose(), style: .plain, target: self,
                                         action: #selector(self.closeButtonPressed))
        if !rtl { navigationItem.leftBarButtonItem = backButton } else {
            navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.rightBarButtonItem = backButton
        }
    }
    
    func addLargeCloseButton() {
        let rtl = Constants.DefaultValue.shouldRightToLeft
        let backButton = UIBarButtonItem(image: R.image.iconBundleCloseLarger(), style: .plain, target: self,
                                         action: #selector(self.closeButtonPressed))
        if !rtl { navigationItem.leftBarButtonItem = backButton } else {
            navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.rightBarButtonItem = backButton
        }
    }
    
    @objc
    func closeButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Open action sheet
    
    func openActionSheet() {
        // Create An UIAlertController with Action Sheet
        let optionMenuController = UIAlertController(title: nil,
                                                     message: R.string.localizable.commonPhotoAndCameraTitle(),
                                                     preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        let cameraAction = UIAlertAction(title: R.string.localizable.commonPhotoAndCameraCamera(),
                                      style: .default, handler: { _ in
            self.openImagePickerController(sourceType: .camera, allowsEditing: true)
        })
        let albumAction = UIAlertAction(title: R.string.localizable.commonPhotoAndCameraPhotoAlbum(),
                                       style: .default, handler: { _ in
            self.openImagePickerController(sourceType: .photoLibrary, allowsEditing: true)
        })
        let cancelAction = UIAlertAction(title: R.string.localizable.commonButtonTextCancel(),
                                         style: .cancel, handler: nil)
        
        // Add UIAlertAction in UIAlertController
        optionMenuController.addAction(cameraAction)
        optionMenuController.addAction(albumAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        self.present(optionMenuController, animated: true, completion: nil)
    }
    
    private func openImagePickerController(sourceType: UIImagePickerControllerSourceType, allowsEditing: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = sourceType
            vc.allowsEditing = allowsEditing
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePicker(didSelect image: UIImage) {
        
    }
    
    // MARK: Open In App Browser
    
    func openInAppBrowser(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        Common.setStatusBarColor(Colors.lightGrayStatusbar.color())
    }
    
    func openInAppBrowserWithShahidEmbedded(url: URL, appStore: String?) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        Common.setStatusBarColor(Colors.lightGrayStatusbar.color())
    }
    
    // MARK: Universal link
    
    private func getTitleFrom(obj: Post) -> (title: String?, media: Media?, video: Video?) {
        guard let type = obj.postSubType else { return (nil, nil, nil) }
        
        switch type {
        case .text, .embed, .episode:
            return (nil, nil, nil)
        case .video:
            guard let array = obj.medias, !array.isEmpty, let data = array[0] as? Video else { return (nil, nil, nil) }
            return (obj.title, nil, data)
        case .image:
            guard let array = obj.medias, !array.isEmpty else { return (nil, nil, nil) }
            //Image - single
            if array.count == 1 { return (nil, array[0], nil) }
            //Image - multi with/without title
            let media = array.first(where: { $0.id == obj.defaultImageId })
            return (obj.title, media, nil)
        }
    }
    
    func getURLFromObjAndShare(obj: Likable) {
        var strPath: String?
        var strTitle: String?
        var photo: Media?
        var video: Video?
        var strDescription: String?
        
        if let data = obj as? Post {
            strPath = data.universalUrl
            let result = self.getTitleFrom(obj: data)
            strTitle = result.title
            photo = result.media
            video = result.video
            strDescription = data.description
        } else if let data = obj as? Article {
            strPath = data.universalUrl
            strTitle = data.title
            strDescription = data.description
            photo = data.photo
        } else if let data = obj as? App {
            strPath = data.whitePageUrl
            strTitle = data.title
            strDescription = data.description
            photo = data.photo
        } else if let data = obj as? Video {
            strPath = data.universalUrl
            strTitle = data.title
            strDescription = data.description
            photo = data
        }
        
        guard let strPathTemp = strPath else { return }
        var description = ""
        if let strDescription = strDescription, let attributedString = strDescription.htmlToAttributedString() {
            description = attributedString.string
        } else {
            description = strDescription ?? ""
        }
        self.shareURL(strPath: strPathTemp, strTitle: strTitle, strDescription: description, photo: photo, video: video)
    }
    
    func shareURL(strPath: String?, strTitle: String?, strDescription: String?, photo: Media?, video: Video?) {
        let stringItem = SharingStringItemSource(strPath: strPath, strTitle: strTitle, strDescription: strDescription)
        let imageItem = SharingImageItemSource(photo: photo, video: video)
        guard let path = strPath else {
            self.openActivityViewController(shareAll: [stringItem, imageItem])
            return
        }
        
        let sharingURLString = Components.instance.configurations.websiteBaseURL + path
        Components.externalApi.shortenURLFrom(longURL: sharingURLString) { shortLink, _ in
            let urlItem = SharingURLItemSource(shortLink: shortLink)
            self.openActivityViewController(shareAll: [stringItem, imageItem, urlItem])
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func openActivityViewController(shareAll: [Any]) {
        let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // This lines is for the popover you need to show in iPad
        //activityVC.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        //activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        //activityVC.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityVC.excludedActivityTypes = [
            UIActivityType.message,
            UIActivityType.airDrop,
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
                switch activity {
                case UIActivityType.mail?:
                    if success { self.showMessage(message: R.string.localizable.errorSentEmailOK()) } else {
                        print("Email sent unsuccessful")
                    }
                case UIActivityType.postToFacebook?:
                    if success { print("Facebook sent successful") } else {
                        print("Facebook sent unsuccessful")
                    }
                case UIActivityType.postToTwitter?:
                    if success { print("Twitter sent successful") } else {
                        print("Twitter sent unsuccessful")
                    }
                case UIActivityType.copyToPasteboard?:
                    if success { print("copyToPasteboard sent successful") } else {
                        print("copyToPasteboard sent unsuccessful")
                    }
                default:
                    if let str = activity?.rawValue {
                        if str == Constants.ConfigurationSharingExtension.googlePlus {
                            if success { print("GooglePlus sent successful") } else {
                                print("GooglePlus sent unsuccessful")
                            }
                        } else if str == Constants.ConfigurationSharingExtension.whatsApp {
                            if success { print("WhatsApp sent successful") } else {
                                print("WhatsApp sent unsuccessful")
                            }
                        } else {
                            print(str)
                        }
                    }
                }
            }
            self.closeActivityVC.onNext(())
        }
        self.present(activityVC, animated: true, completion: nil)
    }
	
    // MARK: Other methods
    
	func listenToggleScroll(toggleSubject: BehaviorSubject<(Bool, Bool)>) {
	}
    
    @objc
    func onNetworkChange(name: String) {
        if name == BaseViewController.notificationName {
            // Do your stuff
            print("Network was changed")
            if let reach = Reachability() {
                if reach.connection == .none {
                    NSLog("no connecttion")
                } else if reach.connection == .wifi {
                    NSLog("wifi")
                } else {
                    NSLog("cellular")
                }
            }
        }
    }
}

extension BaseViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        Common.setStatusBarColor(Colors.dark.color())
    }
}

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imagePicker(didSelect: image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePicker(didSelect: image)
        } else {
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
