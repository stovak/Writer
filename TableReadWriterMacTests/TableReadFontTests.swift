//
//  TableReadFontTests.swift
//  TableReadWriterMacTests
//
//  Created by TOM STOVALL on 2/7/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import XCTest

import Foundation
import XCTest

@testable import TableReadWriterMac

class TableReadFontTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFontStruct() {
        
        let testSubject = TableReadFont.init(
            id: "courier",
            description: "Courier",
            font: NSFont.init(
                descriptor: NSFontDescriptor.init(
                    name: "Courier",
                    size: CGFloat(TableReadFont.DEFAULT_SIZE)),
                size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
        );
        
        XCTAssertTrue(testSubject.id == "courier", "ID should be as given string");
        XCTAssertTrue(testSubject.description == "Courier", "Description should be as given string");
        XCTAssertEqual(testSubject.font.className, "NSFont", "The font property should be a member of NSFont");
        XCTAssertEqual(testSubject.font.pointSize, CGFloat(TableReadFont.DEFAULT_SIZE), "The font property should be a member of NSFont");

        
    }
    
    func testFontStyles() {
        let testSubject = TableReadFontStyle.styles[TableReadFontType.courier.rawValue];
        if (testSubject == nil) {
            XCTFail("Font Styles will not instantiate");
        }
        
        XCTAssertEqual(testSubject!.id, "courier", "ID should be as given string" + testSubject!.id);
        XCTAssertEqual(testSubject!.description, "Courier", "Description should be as given stringL " + testSubject!.description);
        XCTAssertEqual(testSubject!.font.className, "NSFont", "The font property should be a member of NSFont");
        XCTAssertEqual(testSubject!.font.pointSize, CGFloat(TableReadFont.DEFAULT_SIZE), "The font property should be a member of NSFont");

    }
    
}
