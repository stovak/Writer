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
    
    public static let CHARACTER_INDENT = CGFloat(220);
    public static let PARENTHETICAL_INDENT = CGFloat(185);
    public static let DIALOGUE_INDENT = CGFloat(150);
    public static let DIALOGUE_RIGHT = CGFloat(450);
    
    public static let DD_CHARACTER_INDENT = CGFloat(420);
    public static let DD_PARENTHETICAL_INDENT = CGFloat(385);
    public static let DOUBLE_DIALOGUE_INDENT = CGFloat(350);
    public static let DD_RIGHT = CGFloat(650);
    
    
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
