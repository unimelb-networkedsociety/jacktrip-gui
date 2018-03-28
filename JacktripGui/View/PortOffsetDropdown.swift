//
//  PortOffsetDropdown.swift
//  JacktripGui
//
//  Created by Yunhan on 28/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

class PortOffsetDropdown: NSComboBox {
    let offsets = stride(from: 0, to: 100, by: 10).map { $0 }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.removeAllItems()
        self.addItems(withObjectValues: offsets)
        self.selectItem(at: 0)
        self.formatter = NumberOnlyFormatter()
    }
}
