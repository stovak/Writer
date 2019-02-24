//
//  TableReadParagraphStylesTests.swift
//  TableReadWriterMacTests
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//
import XCTest

import Foundation
import XCTest

@testable import TableReadWriterMac

class TableReadParagraphStylesTests: XCTestCase {

    func testParagraphStyleStruct() {
        let paragraphStyle = TableReadParagraphStyle.initWithValues();
        
        XCTAssertNotNil(paragraphStyle, "Paragraph Style Should not be nil");
        XCTAssertEqual(paragraphStyle.alignment, NSTextAlignment.left, "Default alignment should be left");
        XCTAssertEqual(paragraphStyle.firstLineHeadIndent, 0, "First Line Head Indent should be zero.");
        XCTAssertEqual(paragraphStyle.headIndent, 0, "Head Indent should be zero");
        XCTAssertEqual(paragraphStyle.tailIndent, 0, "Tail Indent should be zero");
        XCTAssertEqual(paragraphStyle.lineHeightMultiple, 12, "Standard Line Height should be 12");
        XCTAssertEqual(paragraphStyle.maximumLineHeight, 0, "Line max height should be 0");
        XCTAssertEqual(paragraphStyle.minimumLineHeight, 0, "Line min height should be zero");
        XCTAssertEqual(paragraphStyle.paragraphSpacing, 0, "Paragraph Spacing should be zero");
        XCTAssertEqual(paragraphStyle.paragraphSpacingBefore, 0, "Paragraph Spacing before should be zero");

    }

}
