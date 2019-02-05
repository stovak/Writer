//
//  TableReadLineTypes.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import AppKit


struct TableReadLineType {
    let id: String;
    let description: String;
    let paragraphStyle: TableReadLineTypeParagraphStyle;
    let fontStyle: String;
    let uppercase: Bool;
    
    init( id: String,
          description: String,
          paragraphStyle: TableReadLineTypeParagraphStyle,
          fontStyle: String = "courier",
          uppercase: Bool = false
        ) {
        self.id = id;
        self.description = description;
        self.paragraphStyle = paragraphStyle;
        self.fontStyle = fontStyle;
        self.uppercase = uppercase;
    }
}

struct TableReadLineTypeParagraphStyle: {

    
    public static let CHARACTER_INDENT = CGFloat(220);
    public static let PARENTHETICAL_INDENT = CGFloat(185);
    public static let DIALOGUE_INDENT = CGFloat(150);
    public static let DIALOGUE_RIGHT = CGFloat(450);
    
    public static let DD_CHARACTER_INDENT = CGFloat(420);
    public static let DD_PARENTHETICAL_INDENT = CGFloat(385);
    public static let DOUBLE_DIALOGUE_INDENT = CGFloat(350);
    public static let DD_RIGHT = CGFloat(650);
    
    let alignment: NSTextAlignment;
    let firstLineHeadIndent: CGFloat;
    let headIndent: CGFloat;
    let tailIndent: CGFloat;
    let lineHeightMultiple: CGFloat;
    let maximumLineHeight: CGFloat;
    let minimumLineHeight: CGFloat;
    let lineSpacing: CGFloat;
    let paragraphSpacing: CGFloat;
    let paragraphSpacingBefore: CGFloat;
    
    init(   lineSpacing: CGFloat = 12,
            alignment: NSTextAlignment = NSTextAlignment.left,
            firstLineHeadIndent: CGFloat = 0,
            headIndent: CGFloat = 0,
            tailIndent: CGFloat = 0,
            lineHeightMultiple: CGFloat = 12,
            maximumLineHeight: CGFloat = 0,
            minimumLineHeight: CGFloat = 0,
            paragraphSpacing: CGFloat = 0,
            paragraphSpacingBefore: CGFloat = 0
        ) {
        self.lineSpacing = lineSpacing;
        self.alignment = alignment;
        self.firstLineHeadIndent = firstLineHeadIndent;
        self.headIndent = headIndent;
        self.tailIndent = tailIndent;
        self.lineHeightMultiple = lineHeightMultiple;
        self.maximumLineHeight = maximumLineHeight;
        self.minimumLineHeight = minimumLineHeight;
        self.paragraphSpacing = paragraphSpacing;
        self.paragraphSpacingBefore = paragraphSpacingBefore;
    }

}

class TableReadLineTypes: NSObject {
    
    public static func getParagraphStyle(forTypeID: String) -> TableReadParagraphStyle {
        let toReturn = TableReadParagraphStyle();
        let lineType = self.value(forKey: forTypeID) as! TableReadLineType;
        
        toReturn.lineSpacing = lineType.paragraphStyle.lineSpacing;
        toReturn.alignment = lineType.paragraphStyle.alignment;
        toReturn.firstLineHeadIndent = lineType.paragraphStyle.firstLineHeadIndent;
        toReturn.headIndent = lineType.paragraphStyle.headIndent;
        toReturn.tailIndent = lineType.paragraphStyle.tailIndent;
        toReturn.lineHeightMultiple = lineType.paragraphStyle.lineHeightMultiple;
        toReturn.maximumLineHeight = lineType.paragraphStyle.maximumLineHeight;
        toReturn.minimumLineHeight = lineType.paragraphStyle.minimumLineHeight;
        toReturn.paragraphSpacing = lineType.paragraphStyle.paragraphSpacing;
        toReturn.paragraphSpacingBefore = lineType.paragraphStyle.paragraphSpacingBefore;
        
        return toReturn;
    }
    
    
    public static func getFontStyle(forFontStyleID: String) -> NSFont {
        let trfs = TableReadFontStyle();
        let trf = trfs.value(forKey: forFontStyleID) as! TableReadFont;
        return trf.font;
    }
        
    
    public static let empty                       = TableReadLineType(
                                                        id: "empty",
                                                        description: "Empty",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: "courier"
                                                    );
    
    public static let section                     = TableReadLineType(
                                                        id: "section",
                                                        description: "Section",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: "courier"
                                                    );
    
    public static let synopse                     = TableReadLineType(
                                                        id: "synopse",
                                                        description: "Synopse",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageTitle              = TableReadLineType(
                                                        id: "titlePageTitle",
                                                        description: "Title Page Title",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageAuthor             = TableReadLineType(
                                                        id: "titlePageAuthor",
                                                        description: "Title Page Author",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageCredit             = TableReadLineType(
                                                        id: "titlePageCredit",
                                                        description: "Title Page Credit",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageSource             = TableReadLineType(
                                                        id: "titlePageSource",
                                                        description: "Title Page Source",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageContact            = TableReadLineType(
                                                        id: "titlePageContact",
                                                        description: "Title Page Contact",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageDraftDate          = TableReadLineType(
                                                        id: "titlePageDraftDate",
                                                        description: "Title Page Draft Date",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let titlePageUnknown            = TableReadLineType(
                                                        id: "titlePageUnknown",
                                                        description: "Title Page Unknown",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let heading                     = TableReadLineType(
                                                        id: "heading",
                                                        description: "Heading",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle(),
                                                        uppercase: true
                                                    );
    
    public static let action                      = TableReadLineType(
                                                        id: "action",
                                                        description: "Action",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let character                   = TableReadLineType(
                                                        id: "character",
                                                        description: "Character",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.CHARACTER_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.CHARACTER_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DIALOGUE_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let parenthetical               = TableReadLineType(
                                                        id: "parenthetical",
                                                        description: "Parenthetical",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.PARENTHETICAL_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.PARENTHETICAL_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DIALOGUE_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let dialogue                    = TableReadLineType(
                                                        id: "dialogue",
                                                        description: "Dialogue",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.DIALOGUE_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.DIALOGUE_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DIALOGUE_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let doubleDialogueCharacter     = TableReadLineType(
                                                        id: "doubleDialogueCharacter",
                                                        description: "DD Character",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.DD_CHARACTER_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.DD_CHARACTER_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DD_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let doubleDialogueParenthetical = TableReadLineType(
                                                        id: "doubleDialogueParenthetical",
                                                        description: "DD Parenthetical",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.DD_PARENTHETICAL_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.DD_PARENTHETICAL_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DD_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let doubleDialogue              = TableReadLineType(
                                                        id: "doubleDialogue",
                                                        description: "Double Dialogue",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            firstLineHeadIndent: TableReadLineTypeParagraphStyle.DOUBLE_DIALOGUE_INDENT,
                                                            headIndent: TableReadLineTypeParagraphStyle.DOUBLE_DIALOGUE_INDENT,
                                                            tailIndent: TableReadLineTypeParagraphStyle.DD_RIGHT
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let transition                  = TableReadLineType(
                                                        id: "transition",
                                                        description: "Transition",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            alignment: NSTextAlignment.right
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle(),
                                                        uppercase: true
                                                    );
    
    public static let lyrics                      = TableReadLineType(
                                                        id: "lyrics",
                                                        description: "Lyrics",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let pageBreak                   = TableReadLineType(
                                                        id: "pageBreak",
                                                        description: "Page Break",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
    public static let centered                    = TableReadLineType(
                                                        id: "centered",
                                                        description: "Centered",
                                                        paragraphStyle: TableReadLineTypeParagraphStyle(
                                                            alignment: NSTextAlignment.right
                                                        ),
                                                        fontStyle: TableReadLineTypeFontStyle()
                                                    );
    
}
