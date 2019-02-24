//
//  TableReadLineTypeTests.swift
//  TableReadWriterMacTests
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import XCTest

import Foundation
import XCTest

@testable import TableReadWriterMac

class TableReadLineTypeTests: XCTestCase {

    func testLineTypeEnum() {
        
        XCTAssertEqual(TableReadLineType.empty.rawValue, "empty", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.general.rawValue, "general", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.section.rawValue, "section", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.synopse.rawValue, "synopse", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageTitle.rawValue, "titlePageTitle", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageAuthor.rawValue, "titlePageAuthor", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageCredit.rawValue, "titlePageCredit", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageSource.rawValue, "titlePageSource", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageContact.rawValue, "titlePageContact", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageUnknown.rawValue, "titlePageUnknown", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.titlePageDraftDate.rawValue, "titlePageDraftDate", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.heading.rawValue, "heading", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.action.rawValue, "action", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.character.rawValue, "character", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.parenthetical.rawValue, "parenthetical", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.dialogue.rawValue, "dialogue", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.lyrics.rawValue, "lyrics", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.doubleDialogueCharacter.rawValue, "doubleDialogueCharacter", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.doubleDialogueParenthetical.rawValue, "doubleDialogueParenthetical", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.transition.rawValue, "transition", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.pageBreak.rawValue, "pageBreak", "Line Type Raw Value should be a string");
        XCTAssertEqual(TableReadLineType.centered.rawValue, "centered", "Line Type Raw Value should be a string");

    }
    
    func testLineTypeStyle() {
        let testSubject = TableReadLineTypeStyle(
            lineType: TableReadLineType.general,
            id: "general",
            description: "General",
            includeNextLine: true
        );
        
        XCTAssertEqual(testSubject.lineType, TableReadLineType.general, "Line Type should correctly store line type enum value");
        XCTAssertEqual(testSubject.id, "general", "Line Type should correctly store line type enum value");
        XCTAssertEqual(testSubject.description, "General", "Line Type should correctly store line type enum value");
        XCTAssertEqual(testSubject.includeNextLine, true, "Line Type should correctly store line type enum value");
        
        let testSubject2 = TableReadLineTypeStyle(
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
        
        XCTAssertEqual(
            testSubject2.lineType,
            TableReadLineType.parenthetical,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.id,
            "parenthetical", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.description,
            "Parenthetical", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.paragraphStyle.className,
            "TableReadWriterMac.TableReadParagraphStyle",
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.includeNextLine,
            true,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.fdxName,
            "Parenthetical",
            "Line Type should correctly store line type enum value");

        
    }
    
    func testLineTypeStylesByLineType() {
        
        let testSubject = TableReadLineTypeStyles.byLineType(TableReadLineType.parenthetical);
        
        XCTAssertEqual(
            testSubject.lineType,
            TableReadLineType.parenthetical,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject.id,
            "parenthetical", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject.description,
            "Parenthetical", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject.paragraphStyle.className,
            "TableReadWriterMac.TableReadParagraphStyle",
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject.includeNextLine,
            true,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject.fdxName,
            "Parenthetical",
            "Line Type should correctly store line type enum value");
        
        let testSubject2 = TableReadLineTypeStyles.byLineType(TableReadLineType.action);
        
        XCTAssertEqual(
            testSubject2.lineType,
            TableReadLineType.action,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.id,
            "action", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.description,
            "Action", "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.paragraphStyle.className,
            "TableReadWriterMac.TableReadParagraphStyle",
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.includeNextLine,
            false,
            "Line Type should correctly store line type enum value");
        XCTAssertEqual(
            testSubject2.fdxName,
            "Action",
            "Line Type should correctly store line type enum value");
        
    }
    
    

}
