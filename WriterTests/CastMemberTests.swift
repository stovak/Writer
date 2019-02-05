//
//  CastMemberTests.swift
//  WriterTests
//
//  Created by TOM STOVALL on 2/1/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import XCTest
@testable import TableRead


class CastMemberTests: XCTestCase {

    func testCastMember() {
        let member1 = CastMember.init("@TOM");
        XCTAssertEquals(member1.name, "TOM", "Names should auto filter out initial @");
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
