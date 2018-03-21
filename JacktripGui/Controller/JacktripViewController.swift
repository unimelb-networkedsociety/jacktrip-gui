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
    let portData = [
        ["port": "0", "operation": "connect"],
        ["port": "1", "operation": "connect"],
        ["port": "2", "operation": "connect"],
        ["port": "3", "operation": "connect"]
    ]
    
    @IBOutlet var serverTableView: NSTableView!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet weak var ip: NSTextField!
    @IBOutlet weak var port: NSTextField!
    
    @IBAction func clientOperation(_ sender: ProcessTrigger) {
        if (sender.title == "connect") {
            sender.process = JacktripCore.instance.startClient(ip.stringValue, port.stringValue)
        } else {
            JacktripCore.instance.killProcess(target: sender.process!)
        }
    }
    
    @IBAction func serverOperation(_ sender: ProcessTrigger) {
        if (sender.title == "connect") {
            let indexPath = serverTableView.row(for: sender)
            let port = portData[indexPath]["port"]!
            sender.process = JacktripCore.instance.startServer(port)
        } else {
            JacktripCore.instance.killProcess(target: sender.process!)
        }
    }
    
    @IBAction func clearLog(_ sender: Any) {
        JacktripCore.instance.clearLog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(JacktripViewController.updateLog), name: NSNotification.Name(rawValue: ProcessPipeNotificationKey), object: nil)

        self.serverTableView.delegate = self
        self.serverTableView.dataSource = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @objc func updateLog() {
        logTextView.string = JacktripCore.instance.output
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
