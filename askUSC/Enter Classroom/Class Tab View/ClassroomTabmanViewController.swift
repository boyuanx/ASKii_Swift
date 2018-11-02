//
//  ClassroomTabmanViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/2/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ClassroomTabmanViewController: TabmanViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
    }
    
    // MARK: Must set thisClass from parent class before initAll()
    var thisClass: Class!
    var viewControllers = [UIViewController]()
    
    func initAll() {
        tabInit()
        navInit()
    }

}

extension ClassroomTabmanViewController {
    
    func tabInit() {
        dataSource = self
        bar.items = [
            Item(title: "Q&A"),
            Item(title: "Attendance")
        ]
        bar.style = .buttonBar
        bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = SharedInfo.USC_redColor
            appearance.text.font = .systemFont(ofSize: 15)
            appearance.indicator.isProgressive = true
            appearance.layout.itemDistribution = .centered
            appearance.indicator.color = SharedInfo.USC_redColor
            appearance.indicator.bounces = true
        })
    }
    
    func navInit() {
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(newPost(sender:)))
        rightButton.tintColor = UIColor.white
        navigationItem.setRightBarButton(rightButton, animated: false)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let navTitle = thisClass.className.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
    
    @objc func newPost(sender: UIBarButtonItem) {
        
    }
    
}

extension ClassroomTabmanViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
