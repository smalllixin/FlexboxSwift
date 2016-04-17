//
//  ViewController.swift
//  realswiftbox
//
//  Created by lixin on 4/17/16.
//  Copyright © 2016 lxtap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var toggleState: Bool = false
    var slogo:UILabel?
    var slogo2:UILabel?
    var toggleBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slogo = UILabel()
        self.view?.addSubview(slogo)
        self.slogo = slogo
        
        slogo.attributedText = NSAttributedString(string: "Just Work", attributes: [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.blackColor(),
        ])
        slogo.backgroundColor = UIColor.grayColor()
        
        let slogo2 = UILabel()
        self.view?.addSubview(slogo2)
        slogo2.attributedText = NSAttributedString(string: "swift sweet", attributes: [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
            NSForegroundColorAttributeName: UIColor.blackColor(),
        ])
        slogo2.backgroundColor = UIColor.grayColor()
        self.slogo2 = slogo2
        
        let toggleBtn = UIButton(type: .System)
        self.view?.addSubview(toggleBtn)
        toggleBtn.setAttributedTitle(NSAttributedString(string: "Toggle", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12), NSForegroundColorAttributeName:UIColor.blackColor()]), forState: .Normal)
        toggleBtn.addTarget(self, action: #selector(ViewController.toggleBtnPressed), forControlEvents: .TouchUpInside)
        self.toggleBtn = toggleBtn
        let parent = layoutNode()
        let layout = parent.layout()
        parent.apply(layout)
        print(self.toggleBtn?.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutNode() -> Node {
        let parent = Node(
            flex: 1,
            size: self.view.frame.size,
            direction: .Column,
            justifyContent: .FlexEnd,
            alignItems: .Stretch,
            children: [
                Node(
                    flex: 1,
                    margin: Edges(left: 0, right: 0, bottom: 0, top: self.toggleState ? 107 : 207),
                    direction: .Column,
                    alignItems: .Center,
                    children: [
                        Node(
                            view: slogo,
                            measure: slogo!.nodeMeasure(),
                            margin: Edges(left: 0, right: 0, bottom: 0, top: 20)
                        ),
                        Node(
                            view: slogo2,
                            measure: slogo2!.nodeMeasure(),
                            margin: Edges(left: 0, right: 0, bottom: 0, top: self.toggleState ? 20 : 100)
                        )
                    ]
                ),
                Node(
                    view: toggleBtn,
                    size: CGSize(width: 200, height: 50),
                    margin:Edges(left: 0, right: 0, bottom: 30, top: 0),
                    alignSelf: .Center
                )
            ]
        )
        return parent
    }

    func toggleBtnPressed() {
        self.toggleState = !self.toggleState
        let node = layoutNode()
        let layout = node.layout()
        UIView.animateWithDuration(0.5) { 
            node.apply(layout)
        }
    }
}

