//
//  HomeViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu
import SnapKit
import SkeletonView
import AttributedLabel
import Gallery

class ProfileViewController: BaseViewController {
    
    var isDebug = false

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuGestureSetup()
        initUI()
        if isDebug {
            view.hideSkeleton()
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isDebug {
            return
        }
        fetchData()
    }
    
    // MARK: Title of navigation bar here:
    var navigationTitle = "Profile"
    
    // MARK: Scroll View
    let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.bounces = true
        s.isScrollEnabled = true
        s.alwaysBounceVertical = true
        s.contentInsetAdjustmentBehavior = .never
        s.isSkeletonable = false
        return s
    }()
    
    // MARK: Profile image
    let gallery = GalleryController()
    
    let profileImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "USC_Placeholder1"))
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.layer.borderWidth = 0.5
        i.layer.borderColor = UIColor.lightGray.cgColor
        i.isSkeletonable = true
        return i
    }()
    
    // MARK: User full name
    let nameLabel: UILabel = {
        let l = UILabel()
        var t = NSAttributedString()
        t = CoreInformation.shared.getFullName().set(style: StringStyles.profileName.rawValue)!
        l.attributedText = t
        l.textAlignment = .center
        l.isSkeletonable = false
        return l
    }()
    
    // MARK: Separator line
    let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    let separator2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    // MARK: Quote of the day
    let quoteTextLabel: UILabel = {
        let l = UILabel()
        var t = "Thank you for your support! Fight on!".set(style: StringStyles.profileQuote.rawValue)!
        l.attributedText = t
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 2
        l.isSkeletonable = false
        return l
    }()
    
    // MARK: Quote author
    let quoteAuthorLabel: UILabel = {
        let l = UILabel()
        var t = "- ASKii Team".set(style: StringStyles.profileAuthor.rawValue)!
        l.attributedText = t
        l.isSkeletonable = false
        return l
    }()
    
    // MARK: Quote upvote number
    let quoteUpvoteLabel: UILabel = {
        let l = UILabel()
        //var t = "🔺37".set(style: StringStyles.profileUpvote.rawValue)!
        var t = "This product is still in early alpha. \nSome incomplete features are currently disabled.".set(style: StringStyles.profileUpvote.rawValue)!
        l.numberOfLines = 0
        l.textAlignment = .center
        l.attributedText = t
        l.isSkeletonable = false
        return l
    }()
    
    // MARK: Quote upvote button
    let quoteUpvoteButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = SharedInfo.USC_redColor
        b.setAttributedTitle("Upvote!".set(style: StringStyles.profileUpvoteButton.rawValue), for: .normal)
        b.isHidden = true
        return b
    }()
    
    // MARK: Next class label
    let nextClassNameLabel: UILabel = {
        let l = UILabel()
        var t = "Next class: Unavailable".set(style: StringStyles.profileClassName.rawValue)
        l.attributedText = t
        l.numberOfLines = 2
        l.isSkeletonable = true
        return l
    }()
    let nextClassTimeLabel: UILabel = {
        let l = UILabel()
        var t = "\(Date().date.toFormat("h:mm a")) - \(Date().date.toFormat("h:mm a"))".set(style: StringStyles.profileClassName.rawValue)
        l.attributedText = t
        l.isSkeletonable = true
        return l
    }()
}

extension ProfileViewController {
    
    func fetchData() {
        // MARK: Deprecated Heroku data source
        /*
        view.showAnimatedSkeleton()
        GlobalLinearProgressBar.shared.start()
        SharedInfo.fetchClassListFromServer { [weak self] in
            self?.view.hideSkeleton()
            let nextClass = SharedInfo.getNextClass()
            self?.nextClassNameLabel.attributedText = ("Next class: " + nextClass.className + " - " + nextClass.classDescription).set(style: StringStyles.profileClassName.rawValue)
            self?.nextClassTimeLabel.attributedText = (nextClass.getDateStringWithFormat(format: "E", isStartDate: true) + ": " + nextClass.getDateStringWithFormat(format: "h:mm a", isStartDate: true) + " - " + nextClass.getDateStringWithFormat(format: "h:mm a", isStartDate: false)).set(style: StringStyles.profileClassName.rawValue)
            GlobalLinearProgressBar.shared.stop()
        }
         */
    }
    
    func initUI() {
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        // MARK: Autolayout
        // Scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        // Profile Image
        scrollView.addSubview(profileImgView)
        profileImgView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(view.snp.width).dividedBy(2)
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.topMargin).offset(30)
        }
        profileImgView.layoutIfNeeded()
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        // Name label
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImgView.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).dividedBy(2)
        }
        // Separator
        scrollView.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.height.equalTo(1)
        }
        // Quote of the day
        scrollView.addSubview(quoteTextLabel)
        quoteTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-60)
        }
        quoteTextLabel.layoutIfNeeded()
        // Quote author
        scrollView.addSubview(quoteAuthorLabel)
        quoteAuthorLabel.snp.makeConstraints { (make) in
            make.right.equalTo(quoteTextLabel.snp.right)
            make.top.equalTo(quoteTextLabel.snp.bottom)
            make.width.equalTo(quoteTextLabel.snp.width)
        }
        quoteAuthorLabel.layoutIfNeeded()
        // Upvote count
        scrollView.addSubview(quoteUpvoteLabel)
        quoteUpvoteLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteAuthorLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
        }
        // Upvote button
        scrollView.addSubview(quoteUpvoteButton)
        quoteUpvoteButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteUpvoteLabel.snp.bottom).offset(5)
            make.width.equalTo(view.snp.width).dividedBy(4)
            make.height.lessThanOrEqualTo(view.snp.width).dividedBy(8)
        }
        quoteUpvoteButton.layoutIfNeeded()
        quoteUpvoteButton.layer.cornerRadius = quoteUpvoteButton.frame.height / 2
        // Separator 2
        scrollView.addSubview(separator2)
        separator2.snp.makeConstraints { (make) in
            make.centerX.equalTo(separator.snp.centerX)
            make.top.equalTo(quoteUpvoteButton.snp.bottom).offset(20)
            make.width.equalTo(separator.snp.width)
            make.height.equalTo(separator.snp.height)
        }
        // Next class
        scrollView.addSubview(nextClassNameLabel)
        nextClassNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator2.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
        }
        nextClassNameLabel.layoutIfNeeded()
        scrollView.addSubview(nextClassTimeLabel)
        nextClassTimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextClassNameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        if (CoreInformation.shared.getName(getFirst: true) != "Guest") {
            let tap = UITapGestureRecognizer(target: self, action: #selector(profileImgTap(sender:)))
            profileImgView.isUserInteractionEnabled = true
            profileImgView.addGestureRecognizer(tap)
            
            if let image = DiskManager.shared.fetchImageFromDisk(name: "profilePhoto_\(CoreInformation.shared.getUserID())") {
                profileImgView.image = image
            }
            gallery.delegate = self
            Config.tabsToShow = [.cameraTab, .imageTab]
            Config.Camera.imageLimit = 1
        }
    }
    
}

extension ProfileViewController {
    @objc func profileImgTap(sender: UITapGestureRecognizer) {
        present(gallery, animated: true, completion: nil)
    }
}

extension ProfileViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if (images.count > 0) {
            images[0].resolve { [weak self] (image) in
                self?.profileImgView.image = image
                DiskManager.shared.saveImageToDisk(name: "profilePhoto_\(CoreInformation.shared.getUserID())", image: image ?? UIImage(named: "USC_Placeholder1")!)
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
