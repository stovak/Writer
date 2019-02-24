//
//  TableReadFontStyle.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation

enum TableReadFontType: String {
    case courier = "courier";
    case boldCourier = "boldCourier";
    case italicCourier = "italicCourier";
    case boldItalicCourier = "boldItalicCourier";
}


struct TableReadFont {
    
    public static let DEFAULT_SIZE = Int16(13);
    
    let id: String;
    let description: String;
    let font: NSFont;
    var size: Int16 = 0;
    
    init(id: String, description: String, font: NSFont) {
        self.id = id;
        self.description = description;
        self.font = font;
        self.getSize();
    }
    
    mutating func getSize() -> Int16 {
        if (self.size == 0) {
            let userDefaults = UserDefaults.init();
            if let fontsize = userDefaults.value(forKey: "Fontsize") as? Int16 {
                self.size = fontsize;
            } else {
                self.size = Int16(TableReadFont.DEFAULT_SIZE);
            }
            
        }
        return self.size;
    }
}

class TableReadFontStyle: NSObject {
    
    public static func byType(_ type: TableReadFontType) -> TableReadFont {
        return TableReadFontStyle.styles[type.rawValue]!;
    }
    
    public static func findFont(_ name: String) -> NSFont {
        debugPrint("findFont");
        guard let customFont = NSFont(name: name, size: CGFloat(TableReadFont.DEFAULT_SIZE)) else {
            for family in NSFontManager.shared.availableFontFamilies {
                for member in NSFontManager.shared.availableMembers(ofFontFamily: family)!  {
                    print("Family: \(family.description) Font names: \(member.description)")
                }
            }
            
                fatalError("Failed to load the \(name) font.");
        }
        dump(customFont);
        return customFont;
    }
    
    
    public static let styles: [ String: TableReadFont ] = [
        "courier": TableReadFont.init(
                    id: "courier",
                    description: "Courier",
                    font: TableReadFontStyle.findFont("Courier")
                ),
        "boldCourier": TableReadFont.init(
                id: "boldCourier",
                description: "Bold Courier",
                font: TableReadFontStyle.findFont("Courier-Bold")
            ),
        "italicCourier": TableReadFont.init(
                id: "italicCourier",
                description: "Italic Courier",
                font: TableReadFontStyle.findFont("Courier-Oblique")
            ),
        "boldItalicCourier": TableReadFont.init(
                id: "boldItalicCourier",
                description: "Bold Italic Courier",
                font: TableReadFontStyle.findFont("Courier-BoldOblique")
            )
    ];
}
