//
//  AttendanceCollectionViewCell.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/18/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
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
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
        }
    }
    
    func setLabel(content: String) {
        let label: UILabel = {
            let l = UILabel()
            l.attributedText = content.set(style: StringStyles.attendanceHistoryCell.rawValue)
            return l
        }()
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
    }
    
}
