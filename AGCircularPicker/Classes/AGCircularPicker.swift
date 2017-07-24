//
//  AGCircularPicker.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/15/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

public typealias AGColorValue = (value: Int, color: UIColor)

public protocol AGCircularPickerDelegate {
    
    func didChangeValues(_ values: Array<AGColorValue>, selectedIndex: Int)
    
}

open class AGCircularPicker: UIView {
    
    public var options: Array<AGCircularPickerOption> = [] {
        didSet {
            currentValues = []
            for option in options {
                currentValues.append((option.valueOption.initialValue, UIColor.white))
            }
            collectionView.reloadData()
        }
    }
    public var delegate: AGCircularPickerDelegate?
    public var values: Array<AGColorValue> {
        return currentValues
    }
    
    fileprivate let defaultItemSize: CGFloat = 240.0
    fileprivate var currentValues: Array<AGColorValue> = []
    fileprivate var selectedIndex: Int = 0 {
        didSet {
            collectionLayout.selectedIndex = selectedIndex
            collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            delegate?.didChangeValues(currentValues, selectedIndex: selectedIndex)
        }
    }
    
    fileprivate var didUpdateLayout = false
    fileprivate lazy var collectionLayout: AGCenteredFlowLayout = {
        let layout = AGCenteredFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        return layout
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectionLayout)
        cView.backgroundColor = UIColor.clear
        cView.showsHorizontalScrollIndicator = false
        cView.decelerationRate = UIScrollViewDecelerationRateFast
        cView.register(AGCircularPickerCell.self, forCellWithReuseIdentifier: "cell")
        cView.delegate = self
        cView.dataSource = self
        return cView
    }()
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addAndPin(view: collectionView)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !didUpdateLayout {
            let itemSize = min(defaultItemSize, self.frame.size.height)
            collectionLayout.itemSize = CGSize(width: itemSize, height: itemSize)
            collectionLayout.minimumInteritemSpacing = 10
            collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: (self.bounds.size.width - itemSize - 10) / 2, bottom: 0, right: (bounds.size.width - 10 - itemSize) / 2)
            didUpdateLayout = true
        }
    }
    
}

extension AGCircularPicker: UICollectionViewDelegate {
 
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
    
}

extension AGCircularPicker: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AGCircularPickerCell
        let currentValue = currentValues[indexPath.item]
        cell.setupView(delegate: self, option: options[indexPath.item], index: indexPath.item, value: currentValue.value)
        return cell
    }
    
}

extension AGCircularPicker: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = collectionLayout.selectedIndex
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            selectedIndex = collectionLayout.selectedIndex
        }
    }
    
}

extension AGCircularPicker: AGCircularPickerViewDelegate {
    
    public func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int) {
        currentValues[index] = (value, color)
        delegate?.didChangeValues(currentValues, selectedIndex: selectedIndex)
    }
    
    public func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int) {
        currentValues[index] = (value, color)
        delegate?.didChangeValues(currentValues, selectedIndex: selectedIndex)
    }
    
    public func didBeginTracking(timePickerView: AGCircularPickerView) {
        collectionView.isScrollEnabled = false
    }
    
    public func didEndTracking(timePickerView: AGCircularPickerView) {
        collectionView.isScrollEnabled = true
    }
    
}
