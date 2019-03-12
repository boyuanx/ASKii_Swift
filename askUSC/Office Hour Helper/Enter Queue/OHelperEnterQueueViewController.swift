//
//  OHelperEnterQueueViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/4/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Eureka

class OHelperEnterQueueViewController: FormViewController {
    
    let navigationTitle = "Enter a Queue"
    var OHSection: SelectableSection<ListCheckRow<String>>! = nil
    var OHTextRow: TextRow! = nil
    var purposeTextRow: TextRow! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initForm()
    }
    
    @objc func queueAction(sender: Any) {
        let validationErrors = OHSection.form?.validate()
        if validationErrors != nil && !(validationErrors?.isEmpty ?? false) {
            OHTextRow.cell.textField.resignFirstResponder()
            purposeTextRow.cell.textField.resignFirstResponder()
            generalFailureAlert(message: "Your queue entry form is invalid.") { () -> Void in
                return
            }
            return
        }
        print(OHTextRow.value ?? "Function: \(#function), line: \(#line)")
        print(purposeTextRow.value ?? "Function: \(#function), line: \(#line)")
    }

}

extension OHelperEnterQueueViewController {
    
    func initUI() {
        view.backgroundColor = .white
        
        // MARK: Navigation setup
        navigationController?.navigationBar.tintColor = .white
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(queueAction(sender:)))
        navigationItem.rightBarButtonItem = submitBtn
    }
    
    func initForm() {
        let recommendedOptions = ["CSCI-201: CP Jack Xu": "JX201",
                                  "CSCI-201: CP Emily Jin": "EJ201"]
        OHSection = SelectableSection<ListCheckRow<String>>("Recommended", selectionType: .singleSelection(enableDeselection: true))
        
        OHTextRow = TextRow("other", { (row) in
            row.title = "Enter an OH code"
            row.placeholder = "XXXXX"
            row.add(rule: RuleRequired())
            row.onChange({ [unowned self] (row) in
                let selectedRow = self.OHSection.selectedRow()
                selectedRow?.deselect()
                selectedRow?.value = nil // Necessary to clear selection
                selectedRow?.updateCell()
            })
        })
        form +++ OHSection
        
        for option in recommendedOptions {
            OHSection <<< ListCheckRow<String>(option.value) { row in
                row.title = option.key
                row.selectableValue = option.value
                row.value = nil
                row.onChange({ [unowned self] (row) in
                    if let selectedRow = self.OHSection.selectedRow() {
                        self.OHTextRow.value = selectedRow.selectableValue
                        row.value = self.OHTextRow.value
                    }
                    self.OHTextRow.updateCell()
                })
            }
        }
        OHSection <<< OHTextRow
        
        purposeTextRow = TextRow("purpose", { (row) in
            row.title = "What do you need help with?"
            row.placeholder = "Syntax"
            row.add(rule: RuleRequired())
        })
        form +++ Section("Purpose")
        <<< purposeTextRow
    }
    
}
