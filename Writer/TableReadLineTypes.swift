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
    let id: String;
    let description: String;
    let paragraphStyle: TableReadParagraphStyle;
    let fontStyle: TableReadFont;
    let uppercase: Bool;
    let changesOutline: Bool;
    let includeNextLine: Bool;
    
    init( id: String,
          description: String,
          paragraphStyle: TableReadParagraphStyle = TableReadParagraphStyle(),
          fontStyle: TableReadFont? = nil,
          uppercase: Bool = false,
          changesOutline: Bool = false,
          includeNextLine: Bool = false
        ) {
        self.id = id;
        self.description = description;
        self.paragraphStyle = paragraphStyle;
        self.changesOutline = changesOutline;
        self.includeNextLine = includeNextLine;
        if (fontStyle == nil) {
            self.fontStyle = TableReadFontStyle.byType(TableReadFontType.courier);
        } else {
            self.fontStyle = fontStyle!;
        }
        self.uppercase = uppercase;
    }
}

@objc
class TableReadLineTypeStyles: NSObject {
    
    public static func byLineType(_ id: TableReadLineType) -> TableReadLineTypeStyle {
        return TableReadLineTypeStyles().value(forKey: id.rawValue) as! TableReadLineTypeStyle!;
    }
    
    
     let empty                       = TableReadLineTypeStyle(
                                           id: "empty",
                                           description: "Empty",
                                           includeNextLine: true
                                       );
    
     let section                     = TableReadLineTypeStyle(
                                           id: "section",
                                           description: "Section",
                                           changesOutline: true,
                                           includeNextLine: true
                                       );
    
     let synopse                     = TableReadLineTypeStyle(
                                           id: "synopse",
                                           description: "Synopse",
                                           changesOutline: true,
                                           includeNextLine: true
                                       );
    
     let titlePageTitle              = TableReadLineTypeStyle(
                                           id: "titlePageTitle",
                                           description: "Title Page Title",
                                           includeNextLine: true
                                       );
    
     let titlePageAuthor             = TableReadLineTypeStyle(
                                           id: "titlePageAuthor",
                                           description: "Title Page Author",
                                           includeNextLIne: true
                                       );
    
     let titlePageCredit             = TableReadLineTypeStyle(
                                           id: "titlePageCredit",
                                           description: "Title Page Credit",
                                           includeNextLine: true
                                       );
    
     let titlePageSource             = TableReadLineTypeStyle(
                                           id: "titlePageSource",
                                           description: "Title Page Source",
                                           includeNextLine: true
                                       );
    
     let titlePageContact            = TableReadLineTypeStyle(
                                           id: "titlePageContact",
                                           description: "Title Page Contact",
                                           includeNextLine: true
                                       );
    
     let titlePageDraftDate          = TableReadLineTypeStyle(
                                           id: "titlePageDraftDate",
                                           description: "Title Page Draft Date",
                                           includeNextLIne: true
                                       );
    
     let titlePageUnknown            = TableReadLineTypeStyle(
                                           id: "titlePageUnknown",
                                           description: "Title Page Unknown",
                                           includeNextLine: true
                                       );
    
     let heading                     = TableReadLineTypeStyle(
                                           id: "heading",
                                           description: "Heading",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.courier),
                                           uppercase: true,
                                           changesOutline: true
                                       );
    
     let action                      = TableReadLineTypeStyle(
                                           id: "action",
                                           description: "Action",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier)
                                       );
    
     let character                   = TableReadLineTypeStyle(
                                           id: "character",
                                           description: "Character",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.CHARACTER_INDENT,
                                               headIndent: TableReadParagraphStyle.CHARACTER_INDENT,
                                               tailIndent: TableReadParagraphStyle.DIALOGUE_RIGHT
                                           ),
                                           uppercase: true,
                                           includeNextLine: true
                                       );
    
     let parenthetical               = TableReadLineTypeStyle(
                                           id: "parenthetical",
                                           description: "Parenthetical",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.PARENTHETICAL_INDENT,
                                               headIndent: TableReadParagraphStyle.PARENTHETICAL_INDENT,
                                               tailIndent: TableReadParagraphStyle.DIALOGUE_RIGHT
                                           ),
                                           includeNextLine: true
                                       );
    
     let dialogue                    = TableReadLineTypeStyle(
                                           id: "dialogue",
                                           description: "Dialogue",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.DIALOGUE_INDENT,
                                               headIndent: TableReadParagraphStyle.DIALOGUE_INDENT,
                                               tailIndent: TableReadParagraphStyle.DIALOGUE_RIGHT
                                           ),
                                           includeNextLine: true
                                       );
    
     let doubleDialogueCharacter     = TableReadLineTypeStyle(
                                           id: "doubleDialogueCharacter",
                                           description: "DD Character",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.DD_CHARACTER_INDENT,
                                               headIndent: TableReadParagraphStyle.DD_CHARACTER_INDENT,
                                               tailIndent: TableReadParagraphStyle.DD_RIGHT
                                           ),
                                           includeNextLine: true
                                       );
    
     let doubleDialogueParenthetical = TableReadLineTypeStyle(
                                           id: "doubleDialogueParenthetical",
                                           description: "DD Parenthetical",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.DD_PARENTHETICAL_INDENT,
                                               headIndent: TableReadParagraphStyle.DD_PARENTHETICAL_INDENT,
                                               tailIndent: TableReadParagraphStyle.DD_RIGHT
                                           ),
                                           includeNextLine: true
                                       );
    
     let doubleDialogue              = TableReadLineTypeStyle(
                                           id: "doubleDialogue",
                                           description: "Double Dialogue",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               firstLineHeadIndent: TableReadParagraphStyle.DOUBLE_DIALOGUE_INDENT,
                                               headIndent: TableReadParagraphStyle.DOUBLE_DIALOGUE_INDENT,
                                               tailIndent: TableReadParagraphStyle.DD_RIGHT
                                           ),
                                           includeNextLine: true
                                       );
    
     let transition                  = TableReadLineTypeStyle(
                                           id: "transition",
                                           description: "Transition",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               alignment: NSTextAlignment.right
                                           ),
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.boldCourier),
                                           uppercase: true
                                       );
    
     let lyrics                      = TableReadLineTypeStyle(
                                           id: "lyrics",
                                           description: "Lyrics",
                                           fontStyle: TableReadFontStyle.byType(TableReadFontType.courier)
                                       );
    
     let pageBreak                   = TableReadLineTypeStyle(
                                           id: "pageBreak",
                                           description: "Page Break"
                                       );
    
     let centered                    = TableReadLineTypeStyle(
                                           id: "centered",
                                           description: "Centered",
                                           paragraphStyle: TableReadParagraphStyle.initWithValues(
                                               alignment: NSTextAlignment.center
                                           )
                                       );
    
}


