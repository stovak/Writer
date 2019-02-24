//
//  TableReadLineTypes.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import AppKit

enum TableReadLineType: String {
    case empty = "empty";
    case general = "general";
    case section = "section";
    case synopse = "synopse";
    case titlePageTitle = "titlePageTitle";
    case titlePageAuthor = "titlePageAuthor";
    case titlePageCredit = "titlePageCredit";
    case titlePageSource = "titlePageSource";
    case titlePageContact = "titlePageContact";
    case titlePageDraftDate = "titlePageDraftDate";
    case titlePageUnknown = "titlePageUnknown";
    case heading = "heading";
    case action = "action";
    case character = "character";
    case parenthetical = "parenthetical";
    case dialogue = "dialogue";
    case doubleDialogueCharacter = "doubleDialogueCharacter";
    case doubleDialogueParenthetical = "doubleDialogueParenthetical";
    case doubleDialogue = "doubleDialogue";
    case transition = "transition";
    case lyrics = "lyrics";
    case pageBreak = "pageBreak";
    case centered = "centered";
}

struct TableReadLineTypeStyle {
    let lineType: TableReadLineType;
    let id: String;
    let description: String;
    let paragraphStyle: TableReadParagraphStyle;
    let fontStyle: TableReadFont;
    let uppercase: Bool;
    let changesOutline: Bool;
    let includeNextLine: Bool;
    let isMetaData: Bool;
    let fdxName: String;
    
    init( lineType: TableReadLineType,
          id: String,
          description: String,
          paragraphStyle: TableReadParagraphStyle = TableReadParagraphStyle.initWithValues(),
          fontStyle: TableReadFont? = nil,
          uppercase: Bool = false,
          changesOutline: Bool = false,
          includeNextLine: Bool = false,
          isMetaData: Bool = false,
          fdxName: String = "General"
        ) {
        self.lineType = lineType;
        self.id = id;
        self.description = description;
        self.paragraphStyle = paragraphStyle;
        self.changesOutline = changesOutline;
        self.includeNextLine = includeNextLine;
        self.isMetaData = isMetaData;
        if (fontStyle == nil) {
            self.fontStyle = TableReadFontStyle.byType(TableReadFontType.courier);
        } else {
            self.fontStyle = fontStyle!;
        }
        self.uppercase = uppercase;
        self.fdxName = fdxName;
    }
}

@objc
class TableReadLineTypeStyles: NSObject {
    
    public static func byLineType(_ id: TableReadLineType) -> TableReadLineTypeStyle {
        return TableReadLineTypeStyles.styles[id.rawValue]!;
    }
    
    public static func getFontStyle(forLineType lineType: TableReadLineType) -> TableReadFont {
        return TableReadLineTypeStyles.styles[lineType.rawValue]!.fontStyle
    }
    
    public static let styles = [
        
        "empty": TableReadLineTypeStyle(
                   lineType: TableReadLineType.empty,
                   id: "empty",
                   description: "Empty",
                   includeNextLine: true
               ),
        
        "general": TableReadLineTypeStyle(
            lineType: TableReadLineType.general,
            id: "general",
            description: "General",
            includeNextLine: true
        ),
        
        
     "section": TableReadLineTypeStyle(
                   lineType: TableReadLineType.section,
                   id: "section",
                   description: "Section",
                   changesOutline: true,
                   includeNextLine: true
               ),
    
     "synopse": TableReadLineTypeStyle(
                   lineType: TableReadLineType.synopse,
                   id: "synopse",
                   description: "Synopse",
                   changesOutline: true,
                   includeNextLine: true
               ),
    
    "titlePageTitle": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageTitle,
                   id: "titlePageTitle",
                   description: "Title Page Title",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageAuthor": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageAuthor,
                   id: "titlePageAuthor",
                   description: "Title Page Author",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageCredit": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageCredit,
                   id: "titlePageCredit",
                   description: "Title Page Credit",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageSource": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageSource,
                   id: "titlePageSource",
                   description: "Title Page Source",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageContact": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageContact,
                   id: "titlePageContact",
                   description: "Title Page Contact",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageDraftDate" : TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageDraftDate,
                   id: "titlePageDraftDate",
                   description: "Title Page Draft Date",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
    "titlePageUnknown": TableReadLineTypeStyle(
                   lineType: TableReadLineType.titlePageUnknown,
                   id: "titlePageUnknown",
                   description: "Title Page Unknown",
                   includeNextLine: true,
                   isMetaData: true,
                   fdxName: "TitlePage"
               ),
    
     "heading": TableReadLineTypeStyle(
                   lineType: TableReadLineType.heading,
                   id: "heading",
                   description: "Heading",
                   fontStyle: TableReadFontStyle.byType(TableReadFontType.courier),
                   uppercase: true,
                   changesOutline: true,
                   fdxName: "Scene Heading"
               ),
    
     "action": TableReadLineTypeStyle(
                   lineType: TableReadLineType.action,
                   id: "action",
                   description: "Action",
                   fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier),
                   fdxName: "Action"
               ),
    
    "character": TableReadLineTypeStyle(
                   lineType: TableReadLineType.character,
                   id: "character",
                   description: "Character",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                    firstLineHeadIndent: TableReadParagraphStyleDefaults.CHARACTER_INDENT.rawValue,
                    headIndent: TableReadParagraphStyleDefaults.CHARACTER_INDENT.rawValue,
                    tailIndent: TableReadParagraphStyleDefaults.DIALOGUE_RIGHT.rawValue
                   ),
                   uppercase: true,
                   includeNextLine: true,
                   fdxName: "Character"
               ),
    
    "parenthetical": TableReadLineTypeStyle(
                   lineType: TableReadLineType.parenthetical,
                   id: "parenthetical",
                   description: "Parenthetical",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                    firstLineHeadIndent: TableReadParagraphStyleDefaults.PARENTHETICAL_INDENT.rawValue,
                       headIndent: TableReadParagraphStyleDefaults.PARENTHETICAL_INDENT.rawValue,
                       tailIndent: TableReadParagraphStyleDefaults.DIALOGUE_RIGHT.rawValue
                   ),
                   includeNextLine: true,
                   fdxName: "Parenthetical"
               ),
    
    "dialogue": TableReadLineTypeStyle(
                   lineType: TableReadLineType.dialogue,
                   id: "dialogue",
                   description: "Dialogue",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       firstLineHeadIndent: TableReadParagraphStyleDefaults.DIALOGUE_INDENT.rawValue,
                       headIndent: TableReadParagraphStyleDefaults.DIALOGUE_INDENT.rawValue,
                       tailIndent: TableReadParagraphStyleDefaults.DIALOGUE_RIGHT.rawValue
                   ),
                   includeNextLine: true,
                   fdxName: "Dialogue"
               ),
    
    "doubleDialogueCharacter": TableReadLineTypeStyle(
                   lineType: TableReadLineType.doubleDialogueCharacter,
                   id: "doubleDialogueCharacter",
                   description: "DD Character",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       firstLineHeadIndent: TableReadParagraphStyleDefaults.DD_CHARACTER_INDENT.rawValue,
                       headIndent: TableReadParagraphStyleDefaults.DD_CHARACTER_INDENT.rawValue,
                       tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                   ),
                   includeNextLine: true
               ),
    
    "doubleDialogueParenthetical": TableReadLineTypeStyle(
                   lineType: TableReadLineType.doubleDialogueParenthetical,
                   id: "doubleDialogueParenthetical",
                   description: "DD Parenthetical",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       firstLineHeadIndent: TableReadParagraphStyleDefaults.DD_PARENTHETICAL_INDENT.rawValue,
                       headIndent: TableReadParagraphStyleDefaults.DD_PARENTHETICAL_INDENT.rawValue,
                       tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                   ),
                   includeNextLine: true
               ),
    
    "doubleDialogue": TableReadLineTypeStyle(
                   lineType: TableReadLineType.doubleDialogue,
                   id: "doubleDialogue",
                   description: "Double Dialogue",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       firstLineHeadIndent: TableReadParagraphStyleDefaults.DOUBLE_DIALOGUE_INDENT.rawValue,
                       headIndent: TableReadParagraphStyleDefaults.DOUBLE_DIALOGUE_INDENT.rawValue,
                       tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                   ),
                   includeNextLine: true
               ),

    "transition": TableReadLineTypeStyle(
                   lineType: TableReadLineType.transition,
                   id: "transition",
                   description: "Transition",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       alignment: NSTextAlignment.right
                   ),
                   fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier),
                   uppercase: true,
                   fdxName: "Transition"
               ),
    
     "lyrics": TableReadLineTypeStyle(
                   lineType: TableReadLineType.lyrics,
                   id: "lyrics",
                   description: "Lyrics",
                   fontStyle: TableReadFontStyle.byType(TableReadFontType.courier)
               ),
    
    "pageBreak": TableReadLineTypeStyle(
                   lineType: TableReadLineType.pageBreak,
                   id: "pageBreak",
                   description: "Page Break"
               ),
    
    "centered": TableReadLineTypeStyle(
                   lineType: TableReadLineType.centered,
                   id: "centered",
                   description: "Centered",
                   paragraphStyle: TableReadParagraphStyle.initWithValues(
                       alignment: NSTextAlignment.center
                   )
               )
    ];
    
}


