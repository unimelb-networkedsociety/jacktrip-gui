//
//  JacktripProcess.swift
//  JacktripGui
//
//  Created by Yunhan on 20/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

enum ProcessStatus {
    case idle
    case running
}

class JacktripProcess: Process {
    var status: ProcessStatus
    var id: Int
    static var count: Int = 0
    
    private static func generateId() -> Int {
        count += 1
        return count
    }
    
    override init() {
        self.status = .idle
        self.id = JacktripProcess.generateId()
        super.init()
    }
}
