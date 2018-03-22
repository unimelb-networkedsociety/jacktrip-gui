//
//  NumberOnlyFormatter.swift
//  JacktripGui
//
//  Created by Yunhan on 22/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

class NumberOnlyFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialString.isEmpty {
            return true
        }
        
        if let target = Int(partialString) {
            if target >= 0 {
                return true
            }
        }
        return false
    }
}
