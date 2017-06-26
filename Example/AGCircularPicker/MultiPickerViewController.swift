//
//  MultiPickerViewController.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/23/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AGCircularPicker

class MultiPickerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circularPicker: AGCircularPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hourColor1 = UIColor.rgb_color(r: 0, g: 237, b: 233)
        let hourColor2 = UIColor.rgb_color(r: 0, g: 135, b: 217)
        let hourColor3 = UIColor.rgb_color(r: 138, g: 28, b: 195)
        let hourTitleOption = AGCircularPickerTitleOption(title: "hours")
        let hourValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 23, rounds: 2)
        let hourColorOption = AGCircularPickerColorOption(gradientColors: [hourColor1, hourColor2, hourColor3], gradientAngle: 20)
        let hourOption = AGCircularPickerOption(valueOption: hourValueOption, titleOption: hourTitleOption, colorOption: hourColorOption)        
        
        let minuteColor1 = UIColor.rgb_color(r: 255, g: 141, b: 0)
        let minuteColor2 = UIColor.rgb_color(r: 255, g: 0, b: 88)
        let minuteColor3 = UIColor.rgb_color(r: 146, g: 0, b: 132)
        let minuteColorOption = AGCircularPickerColorOption(gradientColors: [minuteColor1, minuteColor2, minuteColor3], gradientAngle: -20)
        let minuteTitleOption = AGCircularPickerTitleOption(title: "minutes")
        let minuteValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 59)
        let minuteOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: minuteTitleOption, colorOption: minuteColorOption)
        
        let secondTitleOption = AGCircularPickerTitleOption(title: "seconds")
        let secondColorOption = AGCircularPickerColorOption(gradientColors: [hourColor3, hourColor2, hourColor1])
        let secondOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: secondTitleOption, colorOption: secondColorOption)
        
        circularPicker.options = [hourOption, minuteOption, secondOption]
        circularPicker.delegate = self
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MultiPickerViewController: AGCircularPickerDelegate {
    
    func didChangeValues(_ values: Array<AGColorValue>, selectedIndex: Int) {
        let valueComponents = values.map { return String(format: "%02d", $0.value) }
        let fullString = valueComponents.joined(separator: ":")
        let attributedString = NSMutableAttributedString(string:fullString)
        let fullRange = (fullString as NSString).range(of: fullString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(0.5), range: fullRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold), range: fullRange)
        
        let range = NSMakeRange(selectedIndex * 2 + selectedIndex, 2)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: values[selectedIndex].color, range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 35, weight: UIFontWeightBlack), range: range)
        
        titleLabel.attributedText = attributedString
    }
    
}
