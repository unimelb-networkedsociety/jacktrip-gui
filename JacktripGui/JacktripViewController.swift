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

    @IBOutlet var log: NSTextView!
    @IBOutlet weak var ip: NSTextField!
    @IBOutlet weak var port: NSTextField!
    @IBAction func connectToServer(_ sender: NSButtonCell) {
        // shell command to connect: jacktrip -c [ip] [port]
        shell(args:["-c",ip.stringValue, port.stringValue])
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
        self.jacktripTask.executableURL = URL(fileURLWithPath: "/usr/local/bin/jacktrip")
        self.jacktripTask.arguments = args

        let pipe = Pipe()
        self.jacktripTask.standardOutput = pipe
        self.jacktripTask.standardError = pipe
        let outHandle = pipe.fileHandleForReading
        
        outHandle.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async { // Correct
                    self.log.string += "\(line)\n"
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        
        try! self.jacktripTask.run()
    }
}

