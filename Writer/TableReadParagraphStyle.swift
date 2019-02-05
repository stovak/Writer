//
//  TableReadParagraphStyle.swift
//  TableReadWriterMac
//
//  Created by Tom Stovall on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import AVKit

class TableReadParagraphStyle: NSMutableParagraphStyle {
    
    
    override init() {
        super.init();
        self.setValue(NSTextAlignment.left, forKey: "alignment");
        self.setValue(0, forKey: "firstLineHeadIndent");
        self.setValue(0, forKey: "headIndent");
        self.setValue(0, forKey: "tailIndent");
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTo(textStorage: NSTextStorage) {
        textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: self, range: NSMakeRange(0, textStorage.length));
    }
    
}
