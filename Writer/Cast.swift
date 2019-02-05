//
//  Cast.swift
//  Writer
//
//  Created by TOM STOVALL on 2/1/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


class Cast: NSObject {
    
    var members: [ String: CastMember ] = [:];
    
    func addMemberRef(_ name: String) -> CastMember {
        let index = name.replaceAll(of: "(\\(([^)]+)\\))", with: "")
            .trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).replaceAll(of: "@", with: "");
        if let member = self.members[index] {
            member.addLine();
            return member;
        } else {
            let member = CastMember.fromName(index);
            member.addLine();
            self.members[index] = member;
            return member;
        }
    }
    
}
