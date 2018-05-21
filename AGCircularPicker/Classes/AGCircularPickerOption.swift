//
//  AGCircularPickerOption.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/20/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

public struct AGCircularPickerOption {
    
    var titleOption: AGCircularPickerTitleOption? = nil
    var valueOption: AGCircularPickerValueOption!
    var colorOption: AGCircularPickerColorOption = AGCircularPickerColorOption()
    
    public init(valueOption: AGCircularPickerValueOption) {
        self.valueOption = valueOption
    }
    
    public init(valueOption: AGCircularPickerValueOption, titleOption: AGCircularPickerTitleOption) {
        self.valueOption = valueOption
        self.titleOption = titleOption
    }

    public init(valueOption: AGCircularPickerValueOption, colorOption: AGCircularPickerColorOption) {
        self.valueOption = valueOption
        self.colorOption = colorOption
    }

    public init(valueOption: AGCircularPickerValueOption, titleOption: AGCircularPickerTitleOption, colorOption: AGCircularPickerColorOption) {
        self.valueOption = valueOption
        self.titleOption = titleOption
        self.colorOption = colorOption
    }

}

extension AGCircularPickerOption {
    
    public var minValue: Int {
        return valueOption.minValue
    }

    public var maxValue: Int {
        return valueOption.maxValue
    }

    public var rounds: Int {
        return valueOption.rounds
    }

    public var title: String? {
        return titleOption?.title
    }

    public var titleColor: UIColor {
        return titleOption?.titleColor ?? AGCircularPickerTitleOption.defaultColor
    }

    public var titleFont: UIFont {
        return titleOption?.titleFont ?? AGCircularPickerTitleOption.defaultFont
    }
    
    public var gradientColors: [UIColor] {
        return colorOption.gradientColors
    }
    
    public var gradientLocations: [CGFloat] {
        return colorOption.gradientLocations
    }
    
    public var gradientAngle: Int {
        return colorOption.gradientAngle
    }

}

public struct AGCircularPickerValueOption {
    
    static let defaultRounds = 1
    
    var minValue: Int = 0
    var maxValue: Int = 100
    var rounds: Int = 1
    
    public init(minValue: Int, maxValue: Int) {
        self.init(minValue: minValue, maxValue: maxValue, rounds: AGCircularPickerValueOption.defaultRounds)
    }
    
    public init(minValue: Int, maxValue: Int, rounds: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.rounds = rounds
    }

}

public struct AGCircularPickerColorOption {

    static let defaultAngle = 0
    static var defaultColors: Array<UIColor> {
        let color1 = UIColor.rgb_color(r: 0, g: 237, b: 233)
        let color2 = UIColor.rgb_color(r: 0, g: 135, b: 217)
        let color3 = UIColor.rgb_color(r: 138, g: 28, b: 195)
        return [color1, color2, color3]
    }

    var gradientColors: [UIColor] = []
    var gradientLocations: [CGFloat] = []
    var gradientAngle: Int = 0
    
    public init() {
        self.init(gradientColors: AGCircularPickerColorOption.defaultColors)
    }
    
    public init(gradientColors: [UIColor]) {
        var gradientLocations: [CGFloat] = []
        var index = 0
        while index < gradientColors.count {
            gradientLocations.append(0 + CGFloat(index) * (1.0 / CGFloat(gradientColors.count - 1)))
            index = index + 1
        }
        self.init(gradientColors: gradientColors, gradientLocations: gradientLocations)
    }

    public init(gradientColors: [UIColor], gradientAngle: Int) {
        self.init(gradientColors: gradientColors)
        self.gradientAngle = gradientAngle
    }
    
    public init(gradientColors: [UIColor], gradientLocations: [CGFloat]) {
        if gradientColors.count != gradientLocations.count {
            fatalError("Colors count should be equal to locations count")
        }
        self.init(gradientColors: gradientColors, gradientLocations: gradientLocations, gradientAngle: AGCircularPickerColorOption.defaultAngle)
    }
    
    public init(gradientColors: [UIColor], gradientLocations: [CGFloat], gradientAngle: Int) {
        self.gradientColors = gradientColors
        self.gradientLocations = gradientLocations
        self.gradientAngle = gradientAngle
    }

}

public struct AGCircularPickerTitleOption {
    
    static let defaultColor = UIColor.white
    static let defaultFont = UIFont.systemFont(ofSize: 25, weight: .heavy)
    
    var title: String? = nil
    var titleColor: UIColor? = nil
    var titleFont: UIFont? = nil
    
    public init(title: String) {
        self.init(title: title, titleFont: AGCircularPickerTitleOption.defaultFont, titleColor: AGCircularPickerTitleOption.defaultColor)
    }

    public init(title: String, titleFont: UIFont) {
        self.init(title: title, titleFont: titleFont, titleColor: AGCircularPickerTitleOption.defaultColor)
    }
    
    public init(title: String, titleColor: UIColor) {
        self.init(title: title, titleFont: AGCircularPickerTitleOption.defaultFont, titleColor: titleColor)
    }
    
    public init(title: String, titleFont: UIFont, titleColor: UIColor) {
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
    }
    
}
