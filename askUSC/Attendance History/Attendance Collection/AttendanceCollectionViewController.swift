//
//  AttendanceCollectionViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/18/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerReuseID = "Header"

class AttendanceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var navigationTitle = String()
    var lectureID = String()
    var attendanceArray = [Attendance]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        initUI()
        initCollectionView()
    }
    
    func fetchData() {
        GlobalLinearProgressBar.shared.start()
        NetworkingUtility.shared.getAttendanceHistory(lectureID: lectureID) { [weak self] (attendanceArray) in
            self?.attendanceArray = attendanceArray
            self?.collectionView!.performBatchUpdates({
                self?.collectionView!.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (bool) in
                GlobalLinearProgressBar.shared.stop()
            })
        }
    }
    
    func initUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func initNavTitle() {
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
    
    func initCollectionView() {
        self.collectionView!.register(AttendanceCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(AttendanceCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseID)
        self.collectionView!.backgroundColor = UIColor.white
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendanceArray.count*2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AttendanceCollectionViewCell
        
        var cellContent = String()
        if (indexPath.row % 2 == 0) {
            cellContent = attendanceArray[indexPath.row/2].date
        } else {
            let attended = attendanceArray[indexPath.row/2].attended
            if (attended == "0") {
                cellContent = "❌"
            } else {
                cellContent = "✅"
            }
        }
        cell.setLabel(content: cellContent)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseID, for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width/2, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
