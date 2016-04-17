//
//  View+Layout.swift
//  typic
//
//  Created by lixin on 1/2/16.
//  Copyright © 2016 lixin. All rights reserved.
//

import UIKit

extension UIView {
//    public func nodeFlexSize() -> CGSize {
//        return self.sizeThatFits(CGSize(width: CssUndefined, height: CssUndefined))
//    }
//    
//    public func nodeFlexHeight() -> CGSize {
//        var size = self.nodeFlexSize()
//        size.height = CssUndefined
//        return size
//    }
//    
//    public func nodeFlexWidth() -> CGSize {
//        var size = self.nodeFlexSize()
//        size.width = CssUndefined
//        return size
//    }
}

extension UIButton {
    public func nodeFlexSize() -> CGSize {
        return self.sizeThatFits(CGSize(width: CssUndefined, height: CssUndefined))
    }
    
    public func nodeFlexHeight() -> CGSize {
        var size = self.nodeFlexSize()
        size.height = CssUndefined
        return size
    }
    
    public func nodeFlexWidth() -> CGSize {
        var size = self.nodeFlexSize()
        size.width = CssUndefined
        return size
    }
}

extension UILabel {
    public func nodeMeasure() -> (CGFloat -> CGSize) {
        let attrText:NSAttributedString? = self.attributedText?.copy() as? NSAttributedString
        return {(width: CGFloat) -> CGSize in
            let measureWidth:CGFloat
            if width.isNaN {
                measureWidth = 10000
            } else {
                measureWidth = width
            }
            let meausredSize = attrText?.boundingRectWithSize(CGSize(width: measureWidth, height: 100000), options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading], context: nil)
            
            return meausredSize!.size
        }
    }
}

extension UITextField {
    public func nodeFlexSize() -> CGSize {
        return self.sizeThatFits(CGSize(width: CssUndefined, height: CssUndefined))
    }
    
    public func nodeFlexHeight() -> CGSize {
        var size = self.nodeFlexSize()
        size.height = CssUndefined
        return size
    }
    
    public func nodeFlexWidth() -> CGSize {
        var size = self.nodeFlexSize()
        size.width = CssUndefined
        return size
    }
//    public func nodeMeasure() -> (CGFloat -> CGSize) {
//        let attrText:NSAttributedString? = self.attributedText?.copy() as? NSAttributedString
//        return {(width: CGFloat) -> CGSize in
//            let measureWidth:CGFloat
//            if width.isNaN {
//                measureWidth = 10000
//            } else {
//                measureWidth = width
//            }
//            let meausredSize = attrText?.boundingRectWithSize(CGSize(width: measureWidth, height: 100000), options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading], context: nil)
//            
//            return meausredSize!.size
//        }
//    }
}