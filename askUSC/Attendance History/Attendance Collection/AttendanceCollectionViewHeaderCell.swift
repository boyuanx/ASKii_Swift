//
//  AttentionCollectionViewHeaderCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/18/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class AttendanceCollectionViewHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        backgroundColor = UIColor.clear
        let bottomBorder: UIView = {
            let v = UIView()
            v.backgroundColor = SharedInfo.USC_redColor
            return v
        }()
        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
    
    func setLabels() {
        let dateLabel: UILabel = {
            let l = UILabel()
            l.attributedText = "Date".set(style: StringStyles.attendanceHistoryHeader.rawValue)
            return l
        }()
        let attendanceLabel: UILabel = {
            let l = UILabel()
            l.attributedText = "Attendance".set(style: StringStyles.attendanceHistoryHeader.rawValue)
            return l
        }()
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        addSubview(attendanceLabel)
        attendanceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(snp.centerX).offset(10)
        }
    }
    
}
