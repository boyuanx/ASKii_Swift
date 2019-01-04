//
//  OHelperTableViewCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/4/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import UIKit
import SnapKit

class OHelperTableViewCell: UITableViewCell {
    
    var OH_ID: String!
    var instructorName: String!
    var className: String!
    var start: Date!
    var end: Date!
    var numInQueue: Int!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let OHIDLabel = UILabel()
    let instructorNameLabel = UILabel()
    let classNameLabel = UILabel()
    let startLabel = UILabel()
    let endLabel = UILabel()
    let numInQueueLabel = UILabel()
    let middleSeparator = UIView()
    
}

extension OHelperTableViewCell {
    
    func initCell(OHQ: OfficeHourQueue) {
        OH_ID = OHQ.OH_ID
        instructorName = OHQ.instructorName
        className = OHQ.className
        start = OHQ.start
        end = OHQ.end
        numInQueue = OHQ.getPlaceInQueue(for: CoreInformation.shared.getUserID())
    }
    
    func initUI() {
        // MARK: Populating label contents
        OHIDLabel.attributedText = OH_ID.set(style: StringStyles.OHIDLabel.rawValue)
        instructorNameLabel.attributedText = instructorName.set(style: StringStyles.OHInstructorName.rawValue)
        classNameLabel.attributedText = className.set(style: StringStyles.OHClassName.rawValue)
        startLabel.attributedText = ("Starts: " + start.HHmm).set(style: StringStyles.OHTime.rawValue)
        endLabel.attributedText = ("Ends: " + end.HHmm).set(style: StringStyles.OHTime.rawValue)
        numInQueueLabel.attributedText = "Position in queue: \(numInQueue!)".set(style: StringStyles.OHTime.rawValue)
        // MARK: Autolayout
        addSubview(middleSeparator)
        middleSeparator.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        addSubview(instructorNameLabel)
        instructorNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(middleSeparator.snp.top).offset(2)
            make.left.equalToSuperview().offset(15)
        }
        addSubview(classNameLabel)
        classNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleSeparator.snp.bottom).offset(2)
            make.left.equalTo(instructorNameLabel.snp.left)
        }
        addSubview(OHIDLabel)
        OHIDLabel.snp.makeConstraints { (make) in
            make.left.equalTo(classNameLabel.snp.right).offset(5)
            make.bottom.equalTo(classNameLabel.snp.bottom)
        }
        addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleSeparator.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        }
        addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(endLabel.snp.top)
            make.right.equalTo(endLabel)
        }
        addSubview(numInQueueLabel)
        numInQueueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(endLabel.snp.bottom)
            make.right.equalTo(endLabel.snp.right)
        }
    }
}
