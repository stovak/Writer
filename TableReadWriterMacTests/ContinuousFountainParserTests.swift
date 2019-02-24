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
    + "INT. DAY - LIVING ROOM #1# \n"
    + "EXT. DAY - LIVING ROOM\n"
    + "\n"
    + "EXT. DAY - LIVING ROOM\n"
    + "Peter sités somewhere and does something\n"
    + "\n"
    + "PETER\n"
    + "I Liké sitting here\n"
    + "it mäkes me happy\n"
    + "\n"
    + "CHRIS ^\n"
    + "i'm alßo a person!\n"
    + "\n"
    + "HARRAY\n"
    + "(slightly irritated)\n"
    + "Why do i have parentheses?\n"
    + "They are weird!\n"
    + "(still slightly irritated)\n"
    + "\n"
    + "CHIRS ^\n"
    + "(looking at harray)\n"
    + "Why am i over here?\n"
    + "  \n"
    + "And I have holes in my text!\n"
    + "\n"
    + "§$!%\n"
    + "He indeed looks very happy\n"
    + "fade to:\n"
    + ".thisisaheading\n"
    + "!THISISACTION\n"
    + "~lyrics and stuff in this line\n"
    + ">transition\n"
    + "      \n"
    + "title: this is not the title page!\n"
    + ">center!<\n"
    + "===\n"
    + "======\n"
    + "This is on a new page\n"
    + "#section a\n"
    + "###section c\n"
    + "=synopse\n"
    + "@tom\n"
    + "dialogue\n"
    + "\n"
    + "INT./EXT stuff\n"
    + "\n"
    + "INT/EXT other things\n"
    + "\n"
    + "I/E things\n"
    + "\n"
    + "EST things\n";

