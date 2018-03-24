//
//  NumberOnlyTextField.swift
//  JacktripGui
//
//  Created by Yunhan Li on 24/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

class NumberOnlyTextField: NSTextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.formatter = NumberOnlyFormatter()
    }
}
