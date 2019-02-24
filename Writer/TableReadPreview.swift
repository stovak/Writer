//
//  TableReadPreview.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


class TableReadPreview: NSView {
    
    let parser: ContinousFountainParser;
    
    init(withDocument document: TableReadDocument) {
        let myViewController = document.windowControllers[0].contentViewController;
        if (myViewController == nil) {
            /// figure out what to do here
        }
        let parentFrame = myViewController?.view.frame;
        self.parser = document.getParser();
        super.init(frame: parentFrame!)
        myViewController!.view.addSubview(self);
        self.isHidden = false;
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidUnhide() {
        NSLog("NO LONGER HIDDEN");
    }
    
    
}
