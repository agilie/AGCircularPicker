//
//  AGTimePicker.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/8/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

public protocol AGCircularPickerViewDelegate {
    
    func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int)
    func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int)
    func didBeginTracking(timePickerView: AGCircularPickerView)
    func didEndTracking(timePickerView: AGCircularPickerView)
    
}

open class AGCircularPickerView: UIView {
    
    //MARK: Public Vars
    public var index: Int = 0
    public var isEnabled: Bool = true
    public var delegate: AGCircularPickerViewDelegate? {
        didSet {
            delegate?.circularPickerViewDidEndSetupWith(currentValue.round(), color: currentColor ?? UIColor.white, index: index)
        }
    }
    public var value: AGColorValue {
        return AGColorValue(value: currentValue.round(), color: currentColor ?? UIColor.white)
    }
    
    //MARK: Private vars
    fileprivate var option: AGCircularPickerOption? {
        didSet {
            if let opt = option {
                minValue = opt.minValue
                maxValue = opt.maxValue
                rounds = opt.rounds
                currentValue = CGFloat(opt.initialValue)
                gradientColors = opt.gradientColors
                gradientLocations = opt.gradientLocations
                gradientAngle = opt.gradientAngle
                titleLabel.font = opt.titleFont
                titleLabel.textColor = opt.titleColor
            }
        }
    }
    fileprivate var minValue: Int = 0
    fileprivate var maxValue: Int = 23
    fileprivate var rounds: Int = 2
    fileprivate var gradientColors: Array<UIColor> = []
    fileprivate var gradientLocations: Array<CGFloat> = []
    fileprivate var gradientAngle: Int = 0
    
    fileprivate let minOffset: CGFloat = 0
    fileprivate let maxOffset: CGFloat = 20
    fileprivate let knobSize: CGFloat = 9
    
    fileprivate var previousPoint: CGPoint?
    
    fileprivate var gradientLayer = CAGradientLayer()
    fileprivate var ellipseLayer = CAShapeLayer()
    fileprivate lazy var titleLabel: UILabel = {
        return UILabel()
    }()
    fileprivate var knobLayer = CAShapeLayer()
    fileprivate var currentColor: UIColor?
    fileprivate var gradient: UIImage = UIImage()
    
    fileprivate var gradientImageView = UIImageView()
    
    fileprivate var radius: CGFloat = 0
    fileprivate var offset: CGFloat = 0 {
        didSet {
            if offset != oldValue {
                setNeedsDisplay()
            }
        }
    }
    fileprivate var currentValue: CGFloat = 0 {
        didSet {
            angle = scaleToAngle(value: currentValue, inInterval: Interval(min: CGFloat(minValue), max: CGFloat(maxValue), rounds: rounds)) * 180 / .pi
        }
    }
    fileprivate var angle: CGFloat = 0 {
        didSet {
            if angle != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !isEnabled {
            return false
        }
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let rect = innerRect(for: bounds)
        let outerRadius = rect.size.width / 2 + maxOffset
        let innerRadius = rect.size.width / 2 - 2 * maxOffset
        let pointInsideOuterCircle = pow(center.x - point.x, 2) + pow(center.y - point.y, 2) <= pow(outerRadius, 2)
        let pointInsideInnerCircle = pow(center.x - point.x, 2) + pow(center.y - point.y, 2) <= pow(innerRadius, 2)
        return pointInsideOuterCircle && !pointInsideInnerCircle
    }

    public func setupPicker(delegate: AGCircularPickerViewDelegate?, option: AGCircularPickerOption, value: Int = 0) {
        setupPicker(delegate: delegate, option: option, index: 0, value: value)
    }

    public func setupPicker(delegate: AGCircularPickerViewDelegate?, option: AGCircularPickerOption, index: Int, value: Int = 0) {
        self.index = index
        self.option = option
        currentValue = CGFloat(value)
        self.delegate = delegate
        setupView()
        setNeedsDisplay()
    }

    func setupView() {
        if ellipseLayer.superlayer != nil {
            ellipseLayer.removeFromSuperlayer()
            ellipseLayer = CAShapeLayer()
        }
        ellipseLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(ellipseLayer)
        
        gradientImageView.frame = bounds
        gradientImageView.contentMode = .scaleAspectFill
        gradientImageView.image = UIImage.image(withColors: gradientColors, locations: gradientLocations, size: bounds.size, angle: CGFloat(gradientAngle))

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
        }
        gradientLayer.frame = bounds
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat(gradientAngle) / 180.0 * .pi, 0.0, 0.0, 1.0);
        gradientLayer.colors = gradientColors.map({
            return $0.cgColor
        })
        gradientLayer.locations = gradientLocations as [NSNumber]
        layer.addSublayer(gradientLayer)
        
        if knobLayer.superlayer != nil {
            knobLayer.removeFromSuperlayer()
            knobLayer = CAShapeLayer()
        }
        knobLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(knobLayer)
        
        if titleLabel.superview != nil {
            titleLabel.removeFromSuperview()
        }
        titleLabel.text = option?.title
        self.addToCenter(view: titleLabel)
        
        if currentColor == nil {
            let path = self.knobPath(rect: bounds)
            let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            path.rotate(centerPoint: centerPoint, angle: angle)
            currentColor = gradientImageView.layer.colorOfPoint(point: path.currentPoint)
            delegate?.circularPickerViewDidEndSetupWith(currentValue.round(), color: currentColor ?? UIColor.white, index: index)
        }
    }
    
    override open func draw(_ rect: CGRect) {

        let ellipsePath = self.ellipsePath(rect: rect)
        let knobPath = self.knobPath(rect: rect)
        
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        ellipsePath.rotate(centerPoint: centerPoint, angle: angle)
        knobPath.rotate(centerPoint: centerPoint, angle: angle)

        ellipseLayer.path = ellipsePath.cgPath

        let shapeMask = CAShapeLayer()
        shapeMask.path = ellipsePath.cgPath
        super.layer.mask = shapeMask

        knobLayer.path = knobPath.cgPath
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didBeginTracking(timePickerView: self)
        handleTouches(touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didEndTracking(timePickerView: self)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didEndTracking(timePickerView: self)
    }
    
    func handleTouches(_ touches: Set<UITouch>) {
        if !isEnabled {
            return
        }
        if let touchPoint = touches.first?.location(in: self) {
            let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            
            let value = newValue(from: currentValue, touch: touchPoint, start: CGPoint(x: bounds.midX, y: 0))
            currentValue = value
            
            let distance = centerPoint.distance(toPoint: touchPoint) - radius
            offset = min(maxOffset, max(distance, minOffset))
            var correctedPoint = touchPoint
            if distance > maxOffset {
                let startPoint = CGPoint(x: centerPoint.x, y: centerPoint.y - radius - maxOffset + knobSize)
                correctedPoint = startPoint.rotate(around: centerPoint, with: angle)
            }
            
            currentColor = gradientImageView.layer.colorOfPoint(point: correctedPoint)
            delegate?.circularPickerViewDidChangeValue(currentValue.round(), color: currentColor ?? UIColor.black, index: index)
        }
    }
    
    // MARK: Utilities methods
    let circleMinValue: CGFloat = 0
    let circleMaxValue: CGFloat = CGFloat(2 * Double.pi)
    let circleInitialAngle: CGFloat = -CGFloat(Double.pi / 2)

    func newValue(from oldValue: CGFloat, touch touchPosition: CGPoint, start startPosition: CGPoint) -> CGFloat {
        let angle = startPosition.angle(point: touchPosition, center: CGPoint(x: bounds.midX, y: bounds.midY))
        let interval = Interval(min: CGFloat(minValue), max: CGFloat(maxValue), rounds: rounds)
        let deltaValue = delta(in: interval, for: angle, oldValue: oldValue)
        
        var newValue = oldValue + deltaValue
        let range = CGFloat(maxValue - minValue)
        
        if newValue > CGFloat(maxValue) {
            newValue -= range
        }
        else if newValue < CGFloat(minValue) {
            newValue += range
        }
        return newValue
    }

    func delta(in interval: Interval, for angle: CGFloat, oldValue: CGFloat) -> CGFloat {
        let angleIntreval = Interval(min: circleMinValue , max: circleMaxValue)
        
        let oldAngle = scaleToAngle(value: oldValue, inInterval: interval)
        let deltaAngle = self.angle(from: oldAngle, to: angle)
        
        return scaleValue(deltaAngle, fromInterval: angleIntreval, toInterval: interval)
    }

    func scaleToAngle(value aValue: CGFloat, inInterval oldInterval: Interval) -> CGFloat {
        let angleInterval = Interval(min: circleMinValue , max: circleMaxValue)
        
        let angle = scaleValue(aValue, fromInterval: oldInterval, toInterval: angleInterval)
        return  angle
    }
    
    func scaleValue(_ value: CGFloat, fromInterval source: Interval, toInterval destination: Interval) -> CGFloat {
        let sourceRange = (source.max - source.min) / CGFloat(source.rounds)
        let destinationRange = (destination.max - destination.min) / CGFloat(destination.rounds)
        let scaledValue = source.min + (value - source.min).truncatingRemainder(dividingBy: sourceRange)
        let newValue =  (((scaledValue - source.min) * destinationRange) / sourceRange) + destination.min
        
        return  newValue
    }
    
    func angle(from alpha: CGFloat, to beta: CGFloat) -> CGFloat {
        let halfValue = circleMaxValue/2
        // Rotate right
        let offset = alpha >= halfValue ? circleMaxValue - alpha : -alpha
        let offsetBeta = beta + offset
        
        if offsetBeta > halfValue {
            return offsetBeta - circleMaxValue
        }
        else {
            return offsetBeta
        }
    }

}

extension AGCircularPickerView {
    
    func innerRect(for rect: CGRect) -> CGRect {
        let minSize: CGFloat = min(rect.width, rect.height)
        let margin: CGFloat = maxOffset //minSize * 0.2
        let rectSize: CGFloat = minSize - 2 * margin
        return CGRect(x: (rect.width - rectSize) / 2, y: (rect.height - rectSize) / 2, width: rectSize, height: rectSize)
    }
    
    func startPoint(rect: CGRect) -> CGPoint {
        let innerRect = self.innerRect(for: rect)
        radius = innerRect.height / 2
        return CGPoint(x: innerRect.midX, y: innerRect.midY - radius - offset)
    }
    
    func knobPath(rect: CGRect) -> UIBezierPath {
        let startPoint = self.startPoint(rect: rect)
        let knobStartPoint = CGPoint(x: startPoint.x - knobSize / 2, y: startPoint.y + knobSize)
        return UIBezierPath(ovalIn: CGRect(x: knobStartPoint.x, y: knobStartPoint.y, width: knobSize, height: knobSize))
    }
    
    func ellipsePath(rect: CGRect) -> UIBezierPath {
        let innerRect = self.innerRect(for: rect)
        
        radius = innerRect.height / 2
        let controlDelta = radius * 0.552
        
        let ellipsePath = UIBezierPath()
        let startPoint = self.startPoint(rect: rect)
        ellipsePath.move(to: startPoint)
        
        var controlPoint1 = CGPoint(x: startPoint.x + controlDelta, y: startPoint.y)
        let point2 = CGPoint(x: innerRect.maxX, y: innerRect.midY)
        var controlPoint2 = CGPoint(x: point2.x, y: point2.y - controlDelta)
        
        ellipsePath.addCurve(to: point2, controlPoint1:controlPoint1 , controlPoint2: controlPoint2)
        
        controlPoint1 = CGPoint(x: point2.x, y: point2.y + controlDelta)
        let point3 = CGPoint(x: innerRect.midX, y: innerRect.maxY)
        controlPoint2 = CGPoint(x: point3.x + controlDelta, y: point3.y)
        
        ellipsePath.addCurve(to: point3, controlPoint1:controlPoint1 , controlPoint2: controlPoint2)
        
        controlPoint1 = CGPoint(x: point3.x - controlDelta, y: point3.y)
        let point4 = CGPoint(x: innerRect.minX, y: innerRect.midY)
        controlPoint2 = CGPoint(x: point4.x, y: point4.y + controlDelta)
        
        ellipsePath.addCurve(to: point4, controlPoint1:controlPoint1 , controlPoint2: controlPoint2)
        
        controlPoint1 = CGPoint(x: point4.x, y: point4.y - controlDelta)
        controlPoint2 = CGPoint(x: startPoint.x - controlDelta, y: startPoint.y)
        
        ellipsePath.addCurve(to: startPoint, controlPoint1:controlPoint1 , controlPoint2: controlPoint2)
        
        return ellipsePath
    }
    
}
