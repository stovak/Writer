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
          paragraphStyle: TableReadParagraphStyle = TableReadParagraphStyle(),
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
        return TableReadLineTypeStyles().value(forKey: id.rawValue) as! TableReadLineTypeStyle;
    }
    
    public static func getFontStyle(forLineTypeId lineTypeID: String) -> TableReadFont {
        return (TableReadLineTypeStyles().value(forKey: lineTypeID) as! TableReadLineTypeStyle).fontStyle
    }
    
    
     let empty                       = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.empty,
                                           id: "empty",
                                           description: "Empty",
                                           includeNextLine: true
                                       );
    
     let section                     = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.section,
                                           id: "section",
                                           description: "Section",
                                           changesOutline: true,
                                           includeNextLine: true
                                       );
    
     let synopse                     = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.synopse,
                                           id: "synopse",
                                           description: "Synopse",
                                           changesOutline: true,
                                           includeNextLine: true
                                       );
    
     let titlePageTitle              = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageTitle,
                                           id: "titlePageTitle",
                                           description: "Title Page Title",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageAuthor             = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageAuthor,
                                           id: "titlePageAuthor",
                                           description: "Title Page Author",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageCredit             = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageCredit,
                                           id: "titlePageCredit",
                                           description: "Title Page Credit",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageSource             = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageSource,
                                           id: "titlePageSource",
                                           description: "Title Page Source",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageContact            = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageContact,
                                           id: "titlePageContact",
                                           description: "Title Page Contact",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageDraftDate          = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageDraftDate,
                                           id: "titlePageDraftDate",
                                           description: "Title Page Draft Date",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let titlePageUnknown            = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.titlePageUnknown,
                                           id: "titlePageUnknown",
                                           description: "Title Page Unknown",
                                           includeNextLine: true,
                                           isMetaData: true,
                                           fdxName: "TitlePage"
                                       );
    
     let heading                     = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.heading,
                                           id: "heading",
                                           description: "Heading",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.courier),
                                           uppercase: true,
                                           changesOutline: true,
                                           fdxName: "Scene Heading"
                                       );
    
     let action                      = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.action,
                                           id: "action",
                                           description: "Action",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier),
                                           fdxName: "Action"
                                       );
    
     let character                   = TableReadLineTypeStyle(
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
                                       );
    
     let parenthetical               = TableReadLineTypeStyle(
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
                                       );
    
     let dialogue                    = TableReadLineTypeStyle(
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
                                       );
    
     let doubleDialogueCharacter     = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.doubleDialogueCharacter,
                                           id: "doubleDialogueCharacter",
                                           description: "DD Character",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyleDefaults.DD_CHARACTER_INDENT.rawValue,
                                               headIndent: TableReadParagraphStyleDefaults.DD_CHARACTER_INDENT.rawValue,
                                               tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                                           ),
                                           includeNextLine: true
                                       );
    
     let doubleDialogueParenthetical = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.doubleDialogueParenthetical,
                                           id: "doubleDialogueParenthetical",
                                           description: "DD Parenthetical",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyleDefaults.DD_PARENTHETICAL_INDENT.rawValue,
                                               headIndent: TableReadParagraphStyleDefaults.DD_PARENTHETICAL_INDENT.rawValue,
                                               tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                                           ),
                                           includeNextLine: true
                                       );
    
     let doubleDialogue              = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.doubleDialogue,
                                           id: "doubleDialogue",
                                           description: "Double Dialogue",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyleDefaults.DOUBLE_DIALOGUE_INDENT.rawValue,
                                               headIndent: TableReadParagraphStyleDefaults.DOUBLE_DIALOGUE_INDENT.rawValue,
                                               tailIndent: TableReadParagraphStyleDefaults.DD_RIGHT.rawValue
                                           ),
                                           includeNextLine: true
                                       );
    
     let transition                  = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.transition,
                                           id: "transition",
                                           description: "Transition",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               alignment: NSTextAlignment.right
                                           ),
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier),
                                           uppercase: true,
                                           fdxName: "Transition"
                                       );
    
     let lyrics                      = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.lyrics,
                                           id: "lyrics",
                                           description: "Lyrics",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.courier)
                                       );
    
     let pageBreak                   = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.pageBreak,
                                           id: "pageBreak",
                                           description: "Page Break"
                                       );
    
     let centered                    = TableReadLineTypeStyle(
                                           lineType: TableReadLineType.centered,
                                           id: "centered",
                                           description: "Centered",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               alignment: NSTextAlignment.center
                                           )
                                       );
    
}


