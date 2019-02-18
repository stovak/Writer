//
//  TableReadParagraphStyle.swift
//  TableReadWriterMac
//
//  Created by Tom Stovall on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import AVKit

enum TableReadParagraphStyleDefaults: CGFloat {
    case CHARACTER_INDENT = 220;
    case PARENTHETICAL_INDENT = 185;
    case DIALOGUE_INDENT = 150;
    case DIALOGUE_RIGHT = 450;
    
    case DD_CHARACTER_INDENT = 420;
    case DD_PARENTHETICAL_INDENT = 385;
    case DOUBLE_DIALOGUE_INDENT = 350;
    case DD_RIGHT = 650;
}

class TableReadParagraphStyle: NSMutableParagraphStyle {
    
    override init() {
        super.init();
        self.setValue(NSTextAlignment.left, forKey: "alignment");
        self.setValue(0, forKey: "firstLineHeadIndent");
        self.setValue(0, forKey: "headIndent");
        self.setValue(0, forKey: "tailIndent");
    }
    
    public static func initWithValues(
        lineSpacing: CGFloat = 12,
        alignment: NSTextAlignment = NSTextAlignment.left,
        firstLineHeadIndent: CGFloat = 0,
        headIndent: CGFloat = 0,
        tailIndent: CGFloat = 0,
        lineHeightMultiple: CGFloat = 12,
        maximumLineHeight: CGFloat = 0,
        minimumLineHeight: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        paragraphSpacingBefore: CGFloat = 0
    ) -> TableReadParagraphStyle {
        let toReturn = TableReadParagraphStyle();
        toReturn.lineSpacing = lineSpacing;
        toReturn.alignment = alignment;
        toReturn.firstLineHeadIndent = firstLineHeadIndent;
        toReturn.headIndent = headIndent;
        toReturn.tailIndent = tailIndent;
        toReturn.lineHeightMultiple = lineHeightMultiple;
        toReturn.maximumLineHeight = maximumLineHeight;
        toReturn.minimumLineHeight = minimumLineHeight;
        toReturn.paragraphSpacing = paragraphSpacing;
        toReturn.paragraphSpacingBefore = paragraphSpacingBefore;
        return toReturn;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTo(textStorage: NSTextStorage) {
        textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: self, range: NSMakeRange(0, textStorage.length));
    }
    
}
