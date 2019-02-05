//
//  CastMember.swift
//  Writer
//
//  Created by TOM STOVALL on 2/1/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


class CastMember {
    
    let name: String;
    var lines: Double;
    
    init(_ name: String ) {
        self.name = name;
        self.lines = 0;
    }
    
    public static func fromName(_ name: String) -> CastMember {
        return CastMember.init(name);
    }
    
    func addLine() {
        self.lines = self.lines + 1;
    }
    
}
