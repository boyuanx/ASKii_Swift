//
//  ClassroomTableCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/30/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class ClassroomTableCell: UITableViewCell {
    
    var messageID: String!
    var classID: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    let senderNameLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let voteCountLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    let voteButton: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "UpArrow")?.withRenderingMode(.alwaysTemplate)
        b.setImage(i, for: .normal)
        b.tintColor = SharedInfo.USC_redColor
        return b
    }()
}

extension ClassroomTableCell {
    
    func initUI(message: Message) {
        
        if (message.type == "NewMessage") {
            messageLabel.attributedText = (message.data)?.set(style: StringStyles.classroomChatBody.rawValue)
            messageID = message.messageID
            classID = message.classID
        }
        senderNameLabel.attributedText = censorUID(UID: message.sender).set(style: StringStyles.classroomChatSender.rawValue)
        voteCountLabel.attributedText = String(message.getVotes()).set(style: StringStyles.classroomChatVote.rawValue)
        
        addSubview(voteCountLabel)
        voteCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        addSubview(voteButton)
        voteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(voteCountLabel).offset(-5)
            make.width.lessThanOrEqualTo(50)
            make.height.lessThanOrEqualTo(50)
        }
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(voteCountLabel.snp.left).offset(-10)
        }
        addSubview(senderNameLabel)
        senderNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
        }
        
        voteButton.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        
        if (CoreInformation.shared.getName(getFirst: true) == "Guest") {
            voteButton.isUserInteractionEnabled = false
            voteButton.isHidden = true
        }
    }
    
    private func censorUID(UID: String) -> String {
        return "Anonymous \(UID[(UID.count-6)...] ?? "Hackerman")"
    }
    
    @objc func vote(sender: UIButton) {
        print("Vote! \(String(describing: messageID))")
        let voteMessage = Message(sender: CoreInformation.shared.getUserID(), messageID: messageID, classID: classID)
        NetworkingUtility.shared.writeMessageToChatSocket(message: voteMessage)
    }
    
}
