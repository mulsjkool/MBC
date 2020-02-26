//
//  AvatarFullScreenView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/22/17.
//  Copyright © 2017 MBC. All rights reserved.
//
import Kingfisher
import UIKit
import RxSwift
import MisterFusion

class AvatarFullScreenView: BaseView {

	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var timestampAndContentTypeView: TimestampAndContentTypeView!
    @IBOutlet weak private var followerView: UIView!

    @IBOutlet weak private var followButtonView: UIView!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    
    // iPAD
    @IBOutlet weak private var avatarImageViewLeadConstrain: NSLayoutConstraint!
    ///

    private var defaultMarginOfName: CGFloat = 95.0
	private var authorNameColor = Colors.dark.color()
	private var contentTypColor = Colors.defaultText.color()

    var timestampTapped: PublishSubject<Void> {
        return timestampAndContentTypeView.timestampTapped
    }
    let authorAvatarTapped = PublishSubject<Void>()
    let authorNameTapped = PublishSubject<Void>()
    
    private var defaultAvatarImage: UIImage?
    
    // MARK: Override
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
		
	func bindData(_ author: Author?, publishedDate: Date?, contentType: String?, subType: String? = nil,
                  isFullScreen: Bool = false, shouldUseFollower: Bool = false, defaultAvatarImage: UIImage? = nil) {
        self.defaultAvatarImage = defaultAvatarImage
        disposeBag = DisposeBag()
		if isFullScreen == true {
			authorNameColor = UIColor.white
			contentTypColor = UIColor.white
		}
        followerView.isHidden = !shouldUseFollower
		bindAuthor(author: author)
		bindTimestampAndContentType(publishedDate: publishedDate, contentType: contentType, subType: subType)
        setupEvents()
	}
    
    func setColorForButtonFollower(color: UIColor) {
        followButtonView.backgroundColor = color
    }
    
    func setAllTextColor(color: UIColor) {
        authorNameColor = color
        contentTypColor = color
        nameLabel.textColor = color
        timestampAndContentTypeView.applyColor(color: color)
        countLabel.textColor = color
    }
    
    func setTextColor(authorNameColor: UIColor, contentTypeColor: UIColor) {
        self.authorNameColor = authorNameColor
        nameLabel.textColor = authorNameColor
        timestampAndContentTypeView.applyColor(color: contentTypeColor)
        countLabel.textColor = contentTypeColor
    }
    
    func bindContentTypeForAppCard(contentType: String?, subType: String?) {
        timestampAndContentTypeView.bindContentTypeForAppCard(type: contentType, subType: subType)
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.avatarFullScreenView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
	private func bindTimestampAndContentType(publishedDate: Date?, contentType: String?, subType: String?) {
        //timestampAndContentTypeView.applyColor(color: UIColor.white)
        
        timestampAndContentTypeView.bindContentType(type: contentType, subType: subType)
        timestampAndContentTypeView.bindTimestamp(date: publishedDate)
        timestampAndContentTypeView.applyColor(color: contentTypColor)
	}
	
    private func bindAuthor(author: Author?) {
        if Constants.Singleton.isiPad {
            avatarImageViewLeadConstrain.constant = 0
        }
		if let author = author {
            nameLabel.textColor = authorNameColor
			nameLabel.text = author.name
            avatarImageView.setSquareImage(imageUrl: author.avatarUrl, placeholderImage: defaultAvatarImage)
        } else {
            nameLabel.text = ""
            avatarImageView.setSquareImage(imageUrl: nil, placeholderImage: defaultAvatarImage)
        }
	}
	
    private func setupEvents() {
        avatarImageView.isUserInteractionEnabled = true
        let authorAvatarTapGesture = UITapGestureRecognizer()
        avatarImageView.addGestureRecognizer(authorAvatarTapGesture)
        
        authorAvatarTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.authorAvatarTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        nameLabel.isUserInteractionEnabled = true
        let authorNameTapGesture = UITapGestureRecognizer()
        nameLabel.addGestureRecognizer(authorNameTapGesture)
        
        authorNameTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
