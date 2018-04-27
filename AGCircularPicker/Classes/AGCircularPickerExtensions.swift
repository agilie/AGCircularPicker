//
//  AGCircularPickerExtensions.swift
//  AGCircularPicker
//
//  Created by Sergii Avilov on 6/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

extension UIView {
    
    func addAndPin(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraints([left, right, top, bottom])
    }
    
    func addToCenter(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraints([centerX, centerY])
    }
    
}

extension CGFloat {
    
    func round(_ minValue: Int) -> Int {
        if self > CGFloat(minValue) && self < CGFloat(minValue) + 0.5 {
            return minValue
        }
        return Int(ceil(self))
    }
    
}

extension UIBezierPath {
    
    func rotate(centerPoint: CGPoint, angle: CGFloat) {
        apply(CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y).inverted())
        apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
        apply(CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y))
    }
    
}

extension CGVector {
    
    init(sourcePoint source: CGPoint, endPoint end: CGPoint) {
        let dx = end.x - source.x
        let dy = end.y - source.y
        self.init(dx: dx, dy: dy)
    }
    
    func dotProduct(_ v: CGVector) -> CGFloat {
        let dotProduct = (dx * v.dx) + (dy * v.dy)
        return dotProduct
    }
    
    func determinant(_ v: CGVector) -> CGFloat {
        let determinant = (v.dx * dy) - (dx * v.dy)
        return determinant
    }
    
}

extension CGPoint {
    
    func angle(point: CGPoint, center: CGPoint) -> CGFloat {
        /*
         we get the angle by using two vectors
         http://www.vitutor.com/geometry/vec/angle_vectors.html
         https://www.mathsisfun.com/geometry/unit-circle.html
         https://en.wikipedia.org/wiki/Dot_product
         https://en.wikipedia.org/wiki/Determinant
         */
        
        let u = CGVector(sourcePoint: center, endPoint: self)
        let v = CGVector(sourcePoint: center, endPoint: point)
        
        let dotProduct = u.dotProduct(v)
        let determinant = u.determinant(v)
        
        let uv = (dotProduct: Float(dotProduct), determinant: Float(determinant))
        let angle = atan2(uv.determinant, uv.dotProduct)
        
        // change the angle interval
        let newAngle = (angle < 0) ? -angle : Float(Double.pi * 2) - angle
        
        return CGFloat(newAngle)
    }
    
    
    func angle(to comparisonPoint: CGPoint, previousAngle: CGFloat, maxAngle: CGFloat = 360) -> CGFloat {
        let originX = comparisonPoint.x - self.x
        let originY = comparisonPoint.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians + .pi / 2).degrees
        
        var previous = previousAngle
        while previous > 360 {
            previous -= 360
        }
        
        if bearingDegrees < 0 && previousAngle < 180 {
            bearingDegrees = maxAngle + bearingDegrees
        }
        
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        
        if previous > 180 && bearingDegrees < 180 {
            bearingDegrees = 360 + bearingDegrees
        }
        let offset = (bearingDegrees - previous)
        if offset >= 0 {
            bearingDegrees = previousAngle + offset
        } else {
            bearingDegrees = previousAngle + offset
        }
        
        if bearingDegrees > maxAngle {
            bearingDegrees = maxAngle - bearingDegrees
        }
        return bearingDegrees
    }
    
    func distance(toPoint p:CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
    
    func rotate(around center: CGPoint, with degrees: CGFloat) -> CGPoint {
        let dx = self.x - center.x
        let dy = self.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + degrees * CGFloat(.pi / 180.0) // convert it to radians
        let x = center.x + radius * cos(newAzimuth)
        let y = center.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
    
}

extension CGFloat {
    
    var degrees: CGFloat {
        return self * CGFloat(180.0 / .pi)
    }
    
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
}

public extension UIColor {
    
    static func rgb_color(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
}

extension UIImage {
    
    public class func image(withColors colors: [UIColor], locations: [CGFloat], size: CGSize, angle: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        guard
            let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors.map { $0.cgColor } as CFArray,
                                      locations: locations) else {
                                        return nil
        }
        
        let degree: CGFloat = (angle + 90) * .pi / 180;
        let center = CGPoint(x: size.width / 2, y: size.height / 2);
        let startPoint = CGPoint(x: center.x - cos (degree) * size.width/2, y: center.y - sin(degree) * size.height/2);
        let endPoint = CGPoint(x: center.x + cos (degree) * size.width/2, y: center.y + sin(degree) * size.height/2);
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions());
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

extension CALayer {
    
    func colorOfPoint(point:CGPoint) -> UIColor? {
        
        let correctedPoint = CGPoint(x: min(max(0, point.x), bounds.width - 2), y: min(max(0, point.y), bounds.height - 2))
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -correctedPoint.x, y: -correctedPoint.y)
        render(in: context!)
        let red = CGFloat(pixel[0])
        let green = CGFloat(pixel[1])
        let blue = CGFloat(pixel[2])
        let alpha = CGFloat(pixel[3])
        let color:UIColor = UIColor(red: red / 255.0,
                                    green: green / 255.0,
                                    blue: blue / 255.0,
                                    alpha: alpha / 255.0)
        
        pixel.deallocate()
        return color
    }
    
}

public struct Interval {
    var min: CGFloat = 0.0
    var max: CGFloat = 0.0
    var rounds: Int
    
    init(min: CGFloat, max: CGFloat, rounds: Int = 1) {
        assert(min <= max && rounds > 0, NSLocalizedString("Illegal interval", comment: ""))
        
        self.min = min
        self.max = max
        self.rounds = rounds
    }
}
