//
//  UIView+OriginUtils.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 9/3/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

extension UIView {
    func frame(inView view: UIView) -> CGRect? {
        if let origin = origin(inView: view) {
            return CGRect(origin: origin, size: frame.size)
        }
        
        return nil
    }
    
    private func origin(inView view: UIView) -> CGPoint? {
        if superview == view {
            return frame.origin
        }
        
        if superview == nil {
            return nil
        }
        
        guard let parentOrigin = superview?.origin(inView: view) else {
            return nil
        }
        
        var origin = parentOrigin.pointByAdding(point: frame.origin)
        
        if let scrollView = superview as? UIScrollView {
            origin = origin.pointByRemoving(point: scrollView.contentOffset)
        }
        //print("Frame alloc for view \(String(describing: type(of: self))): \(origin.x) \(origin.y)")
        return origin
    }
    
    func isPoint(_ point: CGPoint, matchFrameOf view: UIView) -> Bool {
        guard let window = view.window,
            let targetRect = view.frame(inView: window),
            let sourcePoint = origin(inView: window)
            else {
                return false
        }
        let targetPoint = sourcePoint.pointByAdding(point: point)
        return targetRect.contains(targetPoint)
    }
}

extension CGPoint {
    func pointByAdding(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x,
                       y: self.y + point.y)
    }
    
    func pointByRemoving(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x,
                       y: self.y - point.y)
    }
}
