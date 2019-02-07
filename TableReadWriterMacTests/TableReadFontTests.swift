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
                    name: "Courier Prime",
                    size: CGFloat(TableReadFont.DEFAULT_SIZE)),
                size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
        );
        
        XCTAssertTrue(testSubject.id == "courier", "ID should be as given string");
        XCTAssertTrue(testSubject.description, "Description should be as given string");
        
    }
}
