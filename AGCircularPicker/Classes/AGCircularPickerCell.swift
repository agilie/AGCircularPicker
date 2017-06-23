//
//  AGCircularPickerCell.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/15/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

open class AGCircularPickerCell: UICollectionViewCell {
    
    lazy var pickerView: AGCircularPickerView = {
        let picker = AGCircularPickerView(frame: self.bounds)
        return picker
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBlack)
        label.textColor = UIColor.white
        return label
    }()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        pickerView.isEnabled = (layoutAttributes.zIndex >= 9)
    }
    
    func setupView(delegate: AGCircularPickerViewDelegate?, option: AGCircularPickerOption, index: Int, value: Int = 0) {
        pickerView.setupPicker(delegate: delegate, option: option, index: index, value: value)
        if pickerView.superview == nil {
            contentView.addAndPin(view: pickerView)
            contentView.addToCenter(view: titleLabel)
        }
    }
    
}
