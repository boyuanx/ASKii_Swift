//
//  AttendanceClassTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/18/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class AttendanceClassTableViewController: ClassTableViewController {

    override func initUI() {
        // MARK: Navigation setup
        let navTitle = "Attendance History".set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let layout = UICollectionViewFlowLayout()
        let collectionView = AttendanceCollectionViewController(collectionViewLayout: layout)
        collectionView.lectureID = classList[indexPath.row].classID
        collectionView.navigationTitle = classList[indexPath.row].className + " Attendance"
        collectionView.initNavTitle()
        navigationController?.pushViewController(collectionView, animated: true)
    }
    
}
