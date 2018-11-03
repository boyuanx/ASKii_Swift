//
//  ClassroomChatSectionHeaderView.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/2/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class ClassroomChatSectionHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var date: String!
    
    let dateLabel: UILabel = {
        let l = UILabel()
        return l
    }()
}

extension ClassroomChatSectionHeaderView {
    
    func initUI(date: String) {
        self.date = date
        dateLabel.attributedText = date.set(style: StringStyles.classroomChatSectionHeader.rawValue)
        backgroundColor = UIColor.lightGray
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
