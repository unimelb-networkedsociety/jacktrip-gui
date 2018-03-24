//
//  ProcessTrigger.swift
//  JacktripGui
//
//  Created by Yunhan on 21/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

enum ProcessStatus { case idle; case running }

class ProcessTrigger: NSButton {
    private var _process: Process?
    private var _status: ProcessStatus = .idle

    var status: ProcessStatus {
        get {
            return _status
        }
        set {
            _status = newValue
            if (_status == .running) {
                self.title = "Stop"
            } else {
                self.title = "Start"
            }
        }
    }
    
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
                    status = .running
                } else {
                    status = .idle
                }
            } else {
                status = .idle
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.status = .idle
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
