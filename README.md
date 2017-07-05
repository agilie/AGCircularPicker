<p align="center">

<img src="https://user-images.githubusercontent.com/4165054/27869128-a00026e2-61a7-11e7-978f-451bcd304a2b.png" alt="AGCircularPicker" title="AGCircularPicker" width="557"/>
</p>

[![CI Status](http://img.shields.io/travis/savilov/AGCircularPicker.svg?style=flat)](https://travis-ci.org/savilov/AGCircularPicker)
[![Version](https://img.shields.io/cocoapods/v/AGCircularPicker.svg?style=flat)](http://cocoapods.org/pods/AGCircularPicker)
[![License](https://img.shields.io/cocoapods/l/AGCircularPicker.svg?style=flat)](http://cocoapods.org/pods/AGCircularPicker)
[![Platform](https://img.shields.io/cocoapods/p/AGCircularPicker.svg?style=flat)](http://cocoapods.org/pods/AGCircularPicker)
[!]https://img.shields.io/badge/Made%20by%20Agilie-*****-green.svg?style=flat)(https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGCircularPicker)

We are pleased to offer you our new free lightweight plugin named AGCircularPicker.

AGCircularPicker is helpful for creating a controller aimed to manage any calculated parameter. For example, it can be used as a countdown timer or for keeping the score in the game interface.

AGCircularPicker can be customized to meet your individual requirements. The developer can set the number of the controllers and their design by selecting a color, gradient and other similar parameters. In addition, it’s possible to specify the transition type for showing controllers on the screen.

## Installation

AGCircularPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AGCircularPicker"
```

## Demo

<img src="https://j.gifs.com/1jJy8m.gif" alt="Volume Picker Demo" width="240"> <img src="https://j.gifs.com/58NDNK.gif" alt="Time Picker Demo" width="240">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```swift
import AGCircularPicker
```

AGCircularPickerView could be used either from Interface Builder by linking outlet or from the code.

The main requirement to let it work is to setup AGCircularPickerOption. Once it is set picker will automatically setup all required data.

```swift
public struct AGCircularPickerOption {

    var titleOption: AGCircularPickerTitleOption? = nil
    var valueOption: AGCircularPickerValueOption!
    var colorOption: AGCircularPickerColorOption = AGCircularPickerColorOption()

}
```

It consists of three option groups: AGCircularPickerTitleOption (defines title, it's color and font), AGCircularPickerValueOption (defines min and max values and number of rounds) and AGCircularPickerColorOption (defines gradient colors, gradient locations and angle)

AGCircularPickerValueOption is required whereas two others are optionals.

If AGCircularPickerTitleOption is empty control will have no title.

If AGCircularPickerColorOption is not set control will use default colors.

AGCircularPickerView has a delegate to notify about any changes 

```swift
public protocol AGCircularPickerViewDelegate {

    func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int)
    func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int)
    func didBeginTracking(timePickerView: AGCircularPickerView)
    func didEndTracking(timePickerView: AGCircularPickerView)

}
```

Let's see how we can use it in practice. First we should link it in the Interface Builder

```swift
@IBOutlet weak var circularPickerView: AGCircularPickerView!
```

Then we should define required options and setup control with it and delegate if needed

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let valueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 100)
    let titleOption = AGCircularPickerTitleOption(title: "volume")
    let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption)
    pickerView.setupPicker(delegate: self, option: option)
}
```

For more details prease see our example

## Troubleshooting
Problems? Check the [Issues](https://github.com/agilie/AGCircularPicker/issues) block
to find the solution or create an new issue that we will fix asap. Feel free to contribute.


## Author
This iOS visual component is open-sourced by [Agilie Team](https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGCircularPicker) <info@agilie.com>


## Contributors
- [Sergii Avilov](https://github.com/savilov)


## Contact us
<ios@agilie.com>

## License

AGCircularPicker is available under
The [MIT](LICENSE.md) License (MIT) Copyright © 2017 [Agilie Team](https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGCircularPicker)
