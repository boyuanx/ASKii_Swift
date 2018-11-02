//
//  ClassroomTableCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/30/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class ClassroomTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var senderName = "Ppokeder"
//    var message: Any?
//    var messageID = String()
//    var votes = 0
    
    let messageLabel: UILabel = {
        let l = UILabel()
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
        
        if (message.type == "text") {
            messageLabel.attributedText = (message.data as? String)?.set(style: StringStyles.classroomChatBody.rawValue)
        }
        senderNameLabel.attributedText = message.sender.set(style: StringStyles.classroomChatSender.rawValue)
        voteCountLabel.attributedText = String(message.getVotes()).set(style: StringStyles.classroomChatVote.rawValue)
        
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        addSubview(senderNameLabel)
        senderNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        addSubview(voteButton)
        voteButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        addSubview(voteCountLabel)
        voteCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(voteButton.snp.top)
        }
    }
    
}
