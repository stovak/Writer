//
//  ContinuousFountainParserTests.swift
//  TableReadWriterMacTests
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import XCTest

import Foundation
import XCTest

@testable import TableReadWriterMac


class ContinuousFountainParserTests: XCTestCase {

    func testAccessors() {
        let parser = ContinousFountainParser.init(withString: miniScript)
        XCTAssertEqual(parser.lines.count, 8, "MiniScript should produce exactly 8 lines");
        
        //Check string and position at line
        var lineNumber = 0;
        var characterCount = 0;
        for lineString in miniScript.components(separatedBy: "\n") {
            XCTAssertEqual(parser.string(atLine: lineNumber),
                           lineString,
                           "Parsed Lines should be equal: " + lineString);
            XCTAssertEqual(parser.position(atLine: lineNumber),
                           characterCount,
                           "Parser Position should be calculated for line: \(lineNumber)  // \(characterCount)");
            lineNumber += 1;
            characterCount += lineString.count + 1; //+1 for the newline char that is omited in this representation
        }
        
        //Check description
        let toString = parser.description();
        XCTAssertEqual(toString, miniScriptExpectedToString, "Should be equal objects and clearly are not.");
        
        //Break test string at line, type at line and pos at line
        XCTAssertEqual(parser.string(atLine: -1), nil, "Line -1 should be empty string");
        XCTAssertEqual(parser.string(atLine: 20), nil, "line 20 should be empty string");
        XCTAssertEqual(parser.type(atLine: -1), nil, "Should not be found.");
        XCTAssertEqual(parser.type(atLine: 20), nil, "Should not be found.");
        XCTAssertEqual(parser.position(atLine: -1), nil, "Should not be found.");
        XCTAssertEqual(parser.position(atLine: 20), nil, "Should not be found.");
    }
    
    func testInitialParse() {
        let parser = ContinousFountainParser(withString: script);
        
        var i = 0; //User a counter and add "i += 1" after each line to prevent changing all numbers on every insertion
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageTitle, "TableReadLineType.titlePageTitle should parse correctly");
        XCTAssertEqual(parser.position(atLine: i), 0); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageAuthor, "TableReadLineType.titlePageAuthor should parse correctly");
        XCTAssertEqual(parser.position(atLine: i), 14); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageCredit, "TableReadLineType.titlePageCredit should parse correctly");
        XCTAssertEqual(parser.position(atLine: i), 36); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageSource, "TableReadLineType.titlePageSource should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageDraftDate, "TableReadLineType.titlePageDraftDate should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact, "TableReadLineType.titlePageContact should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact, "TableReadLineType.titlePageContact should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact, "TableReadLineType.titlePageContact should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageUnknown, "TableReadLineType.titlePageUnknown should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "TableReadLineType.empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.pageBreak, ".pageBreak should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "TableReadLineType.empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "TableReadLineType.heading should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 1, "Scene Number should increment correctly at line: \(i)");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "TableReadLineType.action should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "TableReadLineType.empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 2, "Line's scene number Should be 2 at line: \(i)");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "action should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character, "character should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "dialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "dialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueCharacter, "doubleDialogueCharacter should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue, "doubleDialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character, "character should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.parenthetical, "parenthetical should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "dialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "dialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.parenthetical, "parenthetical should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueCharacter, "doubleDialogueCharacter should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueParenthetical, "doubleDialogueParenthetical should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue, "doubleDialogue should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "doubleDialogue should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "doubleDialogue should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character, "action should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "action should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.transition, "transition should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "heading should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 3, "Line's scene number Should be 3 at line: \(i)");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "action should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.lyrics, "lyrics should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.transition, "transition should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "action should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.centered, "centered should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.pageBreak, "pageBreak should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.pageBreak, "pageBreak should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action, "action should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.section, "section should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.section, "section should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.synopse, "synopse should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character, "character should parse correctly at line: \(i)"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue, "dialogue should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "heading should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 4, "Line's scene number Should be nil:");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "heading should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 5, "Line's scene number Should be nil:");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "heading should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 6, "Line's scene number Should be nil:");
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty, "empty should parse correctly"); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading, "heading should parse correctly"); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i), 7, "Line's scene number Should be nil:");
    }
    
    func testInsertions() {
        let parser = ContinousFountainParser(withString: "");
        
        parser.parseChange(inRange: NSMakeRange(0, 0), withString: "INT. DAY - LIVING ROOM")
        
        //Perform single insertions and deletions, including line breaks!
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.heading, "adding a heading should be correctly parsed as heading");
        parser.parseChange(inRange: NSMakeRange(0, 0), withString: "Title: Script\n\n")
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.empty);

        parser.parseChange(inRange: NSMakeRange(33, 0), withString: "\n\n");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.character);
        
        parser.parseChange(inRange: NSMakeRange(35, 4), withString: "room\n");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        
        parser.parseChange(inRange: NSMakeRange(40, 0), withString: "this will soon be dialogue");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        
        parser.parseChange(inRange: NSMakeRange(35, 4), withString: "ROOM");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.character);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.dialogue);
        
        parser.parseChange(inRange: NSMakeRange(35, 5), withString: "");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        
        parser.parseChange(inRange: NSMakeRange(61,0), withString: "\n");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.empty);
        
        
        parser.parseChange(inRange: NSMakeRange(62,0), withString: "I'm Phteven");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.action);
        
        parser.parseChange(inRange: NSMakeRange(62,0), withString: "(friendly)\n");
        
        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 6), TableReadLineType.action);

        parser.parseChange(inRange: NSMakeRange(62,0), withString: "\nSTEVEN\n");

        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 6), TableReadLineType.character);
        XCTAssertEqual(parser.type(atLine: 7), TableReadLineType.parenthetical);
        XCTAssertEqual(parser.type(atLine: 8), TableReadLineType.dialogue);
        
        
        parser.parseChange(inRange: NSMakeRange(63,0), withString: "KAREN ^");

        XCTAssertEqual(parser.type(atLine: 0), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.type(atLine: 1), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 2), TableReadLineType.heading);
        XCTAssertEqual(parser.type(atLine: 3), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 4), TableReadLineType.action);
        XCTAssertEqual(parser.type(atLine: 5), TableReadLineType.empty);
        XCTAssertEqual(parser.type(atLine: 6), TableReadLineType.doubleDialogueCharacter);
        XCTAssertEqual(parser.type(atLine: 7), TableReadLineType.doubleDialogueParenthetical);
        XCTAssertEqual(parser.type(atLine: 8), TableReadLineType.doubleDialogue);
        
        //Replace everything with a complete script
        let lastLine = parser.lines.last;
        if (lastLine == nil) {
            fatalError("Something has gone very wrong");
        }
        let totalLength = lastLine!.position + lastLine!.string.count;
        parser.parseChange(inRange: NSMakeRange(0, totalLength), withString: script);
        
        var i = 0; //User a counter and add "i += 1" after each line to prevent changing all numbers on every insertion
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageTitle);
        XCTAssertEqual(parser.position(atLine: i), 0); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageAuthor);
        XCTAssertEqual(parser.position(atLine: i), 14); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageCredit);
        XCTAssertEqual(parser.position(atLine: i), 36); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageSource); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageDraftDate); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageContact); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.titlePageUnknown); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i-1), 1);
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.sceneNumber(atLine: i-1), 2);
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueCharacter); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.parenthetical); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.parenthetical); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueCharacter); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogueParenthetical); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.doubleDialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.transition); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.lyrics); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.transition); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.centered); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.pageBreak); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.pageBreak); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.action); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.section); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.section); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.synopse); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.character); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.dialogue); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.empty); i += 1;
        XCTAssertEqual(parser.type(atLine: i), TableReadLineType.heading); i += 1;
    }

}

let miniScript = "INT. DAY - APPARTMENT\n"
    + "Ted, Marshall and Lilly are sitting on the couch\n"
    + "\n"
    + "TED\n"
    + "Wanna head down to the bar?\n"
    + "\n"
    + "MARSHALL\n"
    + "Sure, let's go!";

let miniScriptExpectedToString = "0 Heading: \"INT. DAY - APPARTMENT\"\n"
    + "1 Action: \"Ted, Marshall and Lilly are sitting on the couch\"\n"
    + "2 Empty: \"\"\n"
    + "3 Character: \"TED\"\n"
    + "4 Dialogue: \"Wanna head down to the bar?\"\n"
    + "5 Empty: \"\"\n"
    + "6 Character: \"MARSHALL\"\n"
    + "7 Dialogue: \"Sure, let's go!\"\n";

let script = ""
    + "Title: Script\n"
    + "Author: Florian Maier\n"
    + "Credit: Thomas Maier\n"
    + "source: somewhere\n"
    + "DrAft Date: 42.23.23\n"
    + "Contact: florian@maier.de\n"
    + "   noeller@me.com\n"
    + "\ttest@abc.\nde"
    + "Key: value\n"
    + "\n"
    + "===\n"                                      // LINE 10
    + "\n"
    + "INT. DAY - LIVING ROOM #1# \n"
    + "EXT. DAY - LIVING ROOM\n"
    + "\n"
    + "EXT. DAY - LIVING ROOM\n"
    + "Peter sités somewhere and does something\n"
    + "\n"
    + "PETER\n"
    + "I Liké sitting here\n"
    + "it mäkes me happy\n"                       // line 20
    + "\n"
    + "CHRIS ^\n"
    + "i'm alßo a person!\n"
    + "\n"
    + "HARRAY\n"
    + "(slightly irritated)\n"
    + "Why do i have parentheses?\n"
    + "They are weird!\n"
    + "(still slightly irritated)\n"
    + "\n"                                        //LINE 30
    + "CHIRS ^\n"
    + "(looking at harray)\n"
    + "Why am i over here?\n"
    + "  \n"
    + "And I have holes in my text!\n"
    + "\n"
    + "§$!%\n"
    + "He indeed looks very happy\n"
    + "fade to:\n"
    + ".thisisaheading\n"                         //LINE 40
    + "!THISISACTION\n"
    + "~lyrics and stuff in this line\n"
    + ">transition\n"
    + "      \n"
    + "title: this is not the title page!\n"
    + ">center!<\n"
    + "===\n"
    + "======\n"
    + "This is on a new page\n"
    + "#section a\n"                             //LINE 50
    + "###section c\n"
    + "=synopse\n"
    + "@tom\n"
    + "dialogue\n"
    + "\n"
    + "INT./EXT stuff\n"
    + "\n"
    + "INT/EXT other things\n"
    + "\n"                                          //LINE 60
    + "I/E things\n"
    + "\n"
    + "EST things\n";

