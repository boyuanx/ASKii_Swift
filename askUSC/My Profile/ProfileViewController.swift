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

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        runOnce()
        initUI()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        fetchData()
    }
    
    // MARK: Title of navigation bar here:
    var navigationTitle = "Profile"
    
    // MARK: Profile image
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
        var t = "- askee Team".set(style: StringStyles.profileAuthor.rawValue)!
        l.attributedText = t
        l.isSkeletonable = false
        return l
    }()
    
    // MARK: Quote upvote number
    let quoteUpvoteLabel: UILabel = {
        let l = UILabel()
        //var t = "🔺37".set(style: StringStyles.profileUpvote.rawValue)!
        var t = "This product is still in early alpha.".set(style: StringStyles.profileUpvote.rawValue)!
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
        var t = "Next class: CSCI270 - Introduction to Algorithms and Theory of Computing".set(style: StringStyles.profileClassName.rawValue)
        l.attributedText = t
        l.numberOfLines = 2
        l.isSkeletonable = true
        return l
    }()
    let nextClassTimeLabel: UILabel = {
        let l = UILabel()
        var t = "12:30PM - 1:50PM".set(style: StringStyles.profileClassName.rawValue)
        l.attributedText = t
        l.isSkeletonable = true
        return l
    }()
}

extension ProfileViewController {
    
    func fetchData() {
        view.showAnimatedSkeleton()
        GlobalLinearProgressBar.shared.start()
        SharedInfo.fetchClassListFromServer { [weak self] in
            self?.view.hideSkeleton()
            let nextClass = SharedInfo.getNextClass()
            self?.nextClassNameLabel.attributedText = ("Next class: " + nextClass.className + " - " + nextClass.classDescription).set(style: StringStyles.profileClassName.rawValue)
            self?.nextClassTimeLabel.attributedText = (nextClass.getDateStringWithFormat(format: "E", isStartDate: true) + ": " + nextClass.getDateStringWithFormat(format: "h:mm a", isStartDate: true) + " - " + nextClass.getDateStringWithFormat(format: "h:mm a", isStartDate: false)).set(style: StringStyles.profileClassName.rawValue)
            GlobalLinearProgressBar.shared.stop()
        }
    }
    
    func runOnce() {
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    func initUI() {
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        // MARK: Autolayout
        // Profile Image
        view.addSubview(profileImgView)
        profileImgView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(view.snp.width).dividedBy(2)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(40)
        }
        profileImgView.layoutIfNeeded()
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        // Name label
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImgView.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).dividedBy(2)
        }
        // Separator
        view.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.height.equalTo(1)
        }
        // Quote of the day
        view.addSubview(quoteTextLabel)
        quoteTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-60)
        }
        quoteTextLabel.layoutIfNeeded()
        // Quote author
        view.addSubview(quoteAuthorLabel)
        quoteAuthorLabel.snp.makeConstraints { (make) in
            make.right.equalTo(quoteTextLabel.snp.right)
            make.top.equalTo(quoteTextLabel.snp.bottom)
            make.width.equalTo(quoteTextLabel.snp.width)
        }
        quoteAuthorLabel.layoutIfNeeded()
        // Upvote count
        view.addSubview(quoteUpvoteLabel)
        quoteUpvoteLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteAuthorLabel.snp.bottom).offset(20)
        }
        // Upvote button
        view.addSubview(quoteUpvoteButton)
        quoteUpvoteButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteUpvoteLabel.snp.bottom).offset(5)
            make.width.equalTo(view.snp.width).dividedBy(4)
            make.height.lessThanOrEqualTo(view.snp.width).dividedBy(8)
        }
        quoteUpvoteButton.layoutIfNeeded()
        quoteUpvoteButton.layer.cornerRadius = quoteUpvoteButton.frame.height / 2
        // Separator 2
        view.addSubview(separator2)
        separator2.snp.makeConstraints { (make) in
            make.centerX.equalTo(separator.snp.centerX)
            make.top.equalTo(quoteUpvoteButton.snp.bottom).offset(20)
            make.width.equalTo(separator.snp.width)
            make.height.equalTo(separator.snp.height)
        }
        // Next class
        view.addSubview(nextClassNameLabel)
        nextClassNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator2.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
        }
        nextClassNameLabel.layoutIfNeeded()
        view.addSubview(nextClassTimeLabel)
        nextClassTimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextClassNameLabel.snp.bottom).offset(10)
        }
    }
    
}
