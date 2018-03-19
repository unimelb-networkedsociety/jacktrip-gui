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
    let portData = [
        ["port": "1", "operation": "connect"],
        ["port": "2", "operation": "connect"],
        ["port": "3", "operation": "connect"],
        ["port": "4", "operation": "connect"]
    ]
    

    @IBOutlet var serverTableView: NSTableView!
    
    @IBOutlet var logTextView: NSTextView!
    
    @IBOutlet weak var ip: NSTextField!
    @IBOutlet weak var port: NSTextField!
    @IBAction func connectToServer(_ sender: NSButtonCell) {
        // shell command to connect: jacktrip -c [ip] [port]
        print(ip.stringValue, port.stringValue)
        shell(args:["-c",ip.stringValue, port.stringValue])
    }

    @IBAction func startServer(_ sender: NSButton) {
        print("starting server")
        shell(args: ["-s"])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serverTableView.delegate = self
        self.serverTableView.dataSource = self
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
                    self.logTextView.string += "\(line)\n"
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        
        try! self.jacktripTask.run()
    }
}

extension JacktripViewController:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return portData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        if tableColumn?.identifier.rawValue == "operation"{
            let result = tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "operation"), owner: self) as! NSButton
            result.title = portData[row]["operation"]!
            return result
        } else {
            let result = tableView.makeView(withIdentifier:(tableColumn?.identifier)!, owner: self) as! NSTableCellView
            result.textField?.stringValue = portData[row][(tableColumn?.identifier.rawValue)!]!
            return result
        }
        
    }
    
}

