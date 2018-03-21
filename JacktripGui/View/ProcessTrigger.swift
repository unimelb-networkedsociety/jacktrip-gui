//
//  ProcessTrigger.swift
//  JacktripGui
//
//  Created by Yunhan on 21/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

class ProcessTrigger: NSButton {
    var _process : Process?
    
    // Hold a reference of the model
    var process : Process? {
        get {
            return _process
        }
        set {
            _process = newValue
            if let p = _process {
                notifyProcessTermination(p)
                if p.isRunning {
                    self.title = "disconnect"
                } else {
                    self.title = "connect"
                }
            } else {
                self.title = "connect"
            }
        }
    }
    
    private func notifyProcessTermination(_ process: Process) {
        var obs : NSObjectProtocol!
        obs = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
          object: process, queue: nil) { notification -> Void in
            NotificationCenter.default.removeObserver(obs)
            print("terminated single process")
            self.process = nil
        }
    }
}
