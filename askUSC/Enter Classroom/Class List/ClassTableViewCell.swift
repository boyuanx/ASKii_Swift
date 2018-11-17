//
//  ClassTableViewCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/23/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {
    
    var name: String!
    var descript: String!
    var instructor: String!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Class name (e.g. CSCI201)
    let nameLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    // MARK: Class description (e.g. Principles of Software Development
    let descriptionLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    // MARK: Class instructor (e.g. Jeffrey Miller)
    let instructorLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
}

extension ClassTableViewCell {
    
    func initUI() {
        // MARK: Populating label contents
        nameLabel.attributedText = name.set(style: StringStyles.enterClassName.rawValue)
        descriptionLabel.attributedText = descript.set(style: StringStyles.enterClassDescription.rawValue)
        instructorLabel.attributedText = instructor.set(style: StringStyles.enterClassInstructor.rawValue)
        // MARK: Autolayout
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.centerY)
            make.left.equalToSuperview().offset(20)
            //make.top.equalToSuperview()
        }
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.centerY)
            make.left.equalToSuperview().offset(20)
            //make.bottom.equalToSuperview()
        }
        addSubview(instructorLabel)
        instructorLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
    }
    
}
