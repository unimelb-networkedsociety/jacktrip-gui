//
//  ViewController.swift
//  JacktripGui
//
//  Created by Yunhan on 15/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa
import Foundation

class JacktripViewController: NSViewController {
    var jacktripTask: Process!

    @IBOutlet weak var ip: NSTextField!
    @IBOutlet weak var port: NSTextField!
    @IBAction func connectToServer(_ sender: NSButtonCell) {
        // shell command to connect: jacktrip -c [ip] [port]
        shell(args:["say","hello"])
        print("connect to", ip.stringValue, port.stringValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func shell(args: [String]) {

        self.jacktripTask = Process()
        self.jacktripTask.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        self.jacktripTask.arguments = args
        

        try! self.jacktripTask.run()
        if !self.jacktripTask.isRunning {
            let status = self.jacktripTask.terminationStatus
            if status == 0 {
                print("Task succeeded.")
            } else {
                print("Task failed.")
            }
        }
        

        //self.jacktripTask.waitUntilExit()
        //return output
    
    }
}
