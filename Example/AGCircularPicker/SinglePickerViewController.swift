//
//  SinglePickerViewController.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/23/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AGCircularPicker

class SinglePickerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: AGCircularPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let valueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 100, initialValue: 50)
        let titleOption = AGCircularPickerTitleOption(title: "volume")
        let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption)
        pickerView.setupPicker(delegate: self, option: option)
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension SinglePickerViewController {
    
    func updateLabel(value: Int, color: UIColor) {
        titleLabel.text = String(format: "%02d", value)
        titleLabel.textColor = color
    }
    
}

extension SinglePickerViewController: AGCircularPickerViewDelegate {
    
    func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int) {
        updateLabel(value: value, color: color)
    }
    
    func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int) {
        updateLabel(value: value, color: color)
    }
    
    func didBeginTracking(timePickerView: AGCircularPickerView) {
        
    }
    
    func didEndTracking(timePickerView: AGCircularPickerView) {
        
    }

}
