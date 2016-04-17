//
//  Node.swift
//  SwiftBox
//
//  Created by Josh Abernathy on 2/6/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import UIKit
import CoreGraphics

public struct Edges {
	public let left: CGFloat
	public let right: CGFloat
	public let bottom: CGFloat
	public let top: CGFloat

	private var asTuple: (Float, Float, Float, Float) {
		return (Float(left), Float(top), Float(right), Float(bottom))
	}

	public init(left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, top: CGFloat = 0) {
		self.left = left
		self.right = right
		self.bottom = bottom
		self.top = top
	}

	public init(uniform: CGFloat) {
		self.left = uniform
		self.right = uniform
		self.bottom = uniform
		self.top = uniform
	}
}

public enum Direction: UInt32 {
	case Column = 0
	case Row = 1
}

public enum JustifyContent: UInt32 {
	case FlexStart = 0
	case Center = 1
	case FlexEnd = 2
	case SpaceBetween = 3
	case SpaceAround = 4
}

public enum AlignItems: UInt32 {
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

public enum SelfAlignment: UInt32 {
	case Auto = 0
	case FlexStart = 1
	case Center = 2
	case FlexEnd = 3
	case Stretch = 4
}

let CssUndefined = CGFloat.NaN

class VirtualView {
    var frame:CGRect
    init(frame: CGRect) {
        self.frame = frame
    }
}

public enum Position: UInt32 {
    case Relative = 0
    case Absolute = 1
}

/// A node in a layout hierarchy.
public class Node {
	/// Indicates that the value is undefined, for the flexbox algorithm to
	/// fill in.
	public static let Undefined: CGFloat = nan("SwiftBox.Node.Undefined")

	public let size: CGSize
	public var children: [Node]
    public let position: Position
    public let left: CGFloat
    public let right: CGFloat
    public let bottom: CGFloat
    public let top: CGFloat
	public let direction: Direction
	public let margin: Edges
	public let padding: Edges
	public let wrap: Bool
	public let justifyContent: JustifyContent
	public let alignSelf: SelfAlignment
	public let alignItems: AlignItems
	public let flex: CGFloat
	public let measure: (CGFloat -> CGSize)?
    public var view:UIView?
    private var virtualView: VirtualView?
    private weak var parentNode: Node?

    public init(size: CGSize = CGSize(width: Undefined, height: Undefined), children: [Node] = [], direction: Direction = .Column, margin: Edges = Edges(), padding: Edges = Edges(), wrap: Bool = false, justifyContent: JustifyContent = .FlexStart, alignSelf: SelfAlignment = .Auto, alignItems: AlignItems = .Stretch, flex: CGFloat = 0, measure: (CGFloat -> CGSize)? = nil, position: Position = .Relative,left: CGFloat = CssUndefined, right: CGFloat = CssUndefined, bottom: CGFloat = CssUndefined, top: CGFloat = CssUndefined,view: UIView? = nil) {
		self.size = size
		self.children = children
		self.direction = direction
		self.margin = margin
		self.padding = padding
		self.wrap = wrap
		self.justifyContent = justifyContent
		self.alignSelf = alignSelf
		self.alignItems = alignItems
		self.flex = flex
		self.measure = measure
        self.position = position
        self.left = left
        self.right = right
        self.bottom = bottom
        self.top = top
        self.view = view;
        if (self.view == nil) {
            self.virtualView = VirtualView(frame: CGRectZero)
        }
        for childNode in self.children {
            childNode.parentNode = self
        }
	}

    /**
     这个函数把Node transfer to NodeImpl
    */
	private func createUnderlyingNode() -> NodeImpl {
		let node = NodeImpl()
		node.node.memory.style.dimensions = (Float(size.width), Float(size.height))
        node.node.memory.style.position_type = css_position_type_t(position.rawValue)
        node.node.memory.style.position = (Float(left), Float(top), Float(right), Float(bottom))
        node.node.memory.style.margin = margin.asTuple
		node.node.memory.style.padding = padding.asTuple
		node.node.memory.style.flex = Float(flex)
		node.node.memory.style.flex_direction = css_flex_direction_t(direction.rawValue)
		node.node.memory.style.flex_wrap = css_wrap_type_t(wrap ? 1 : 0)
		node.node.memory.style.justify_content = css_justify_t(justifyContent.rawValue)
		node.node.memory.style.align_self = css_align_t(alignSelf.rawValue)
		node.node.memory.style.align_items = css_align_t(alignItems.rawValue)
		if let measure = measure {
			node.measure = measure
		}
		node.children = children.map { $0.createUnderlyingNode() }
		return node
	}

	/// Lay out the receiver and all its children with an optional max width.
    public func layout(maxWidth maxWidth: CGFloat? = nil) -> Layout {
		let node = createUnderlyingNode()
		if let maxWidth = maxWidth {
			node.layoutWithMaxWidth(maxWidth)
		} else {
			node.layout()
		}

		let children = createLayoutsFromChildren(node)
		return Layout(frame: node.frame, children: children)
	}
    
    public func apply(layout: Layout) {
        if let view = self.view {
            var node:Node = self
            
            if (node.parentNode != nil) {
                if (node.view != nil) {
                    var relatedPoint = CGPointZero
                    while (node.parentNode != nil && node.parentNode!.view == nil) {
                        node = node.parentNode!
                        relatedPoint = relatedPoint + node.virtualView!.frame.origin
                    }
                    var f = layout.frame
                    f.origin = f.origin + relatedPoint
                    if (f != view.frame) {
                        view.frame = f
                    }
                }
            } else {
                //this is rootview
                view.frame = layout.frame
            }
        } else {
            self.virtualView?.frame = layout.frame
        }
        for (s, childLayout) in Zip2Sequence(self.children, layout.children) {
            s.apply(childLayout)
        }
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func == (left: CGRect, right: CGRect) -> Bool {
    return CGRectEqualToRect(left, right)
}

func != (left: CGRect, right: CGRect) -> Bool {
    return !(left == right)
}

private func createLayoutsFromChildren(node: NodeImpl) -> [Layout] {
	return node.children.map {
		let child = $0 as! NodeImpl
		let frame = child.frame
		return Layout(frame: frame, children: createLayoutsFromChildren(child))
	}
}

public extension CGPoint {
	var isUndefined: Bool {
		return isnan(x) || isnan(y)
	}
}

public extension CGSize {
	var isUndefined: Bool {
		return isnan(width) || isnan(height)
	}
}

public extension CGRect {
	var isUndefined: Bool {
		return origin.isUndefined || size.isUndefined
	}
}
