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
    @IBOutlet var serverTableView: ServerTableView!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet weak var ip: NSTextField!
    @IBOutlet weak var port: NSTextField!
    @IBOutlet weak var numchannels: NSTextField!
    @IBOutlet weak var redundancy: NSTextField!
    @IBOutlet weak var bitres: NSTextField!
    @IBOutlet weak var queue: NSTextField!
    
    @IBAction func clientOperation(_ sender: ProcessTrigger) {
        if (sender.status == .idle) {
            sender.process = JacktripCore.instance.startClient(
                ip.stringValue, port.stringValue,
                numchannels: numchannels.stringValue, queue: queue.stringValue, redundancy: redundancy.stringValue, bitres: bitres.stringValue
            )
        } else {
            JacktripCore.instance.killProcess(target: sender.process!)
        }
    }
    
    @IBAction func serverOperation(_ sender: ProcessTrigger) {
        if (sender.status == .idle) {
            let indexPath = serverTableView.row(for: sender)
            if let port = serverTableView.getPortNumber(index: indexPath) {
                sender.process = JacktripCore.instance.startServer(
                    port, numchannels: numchannels.stringValue, queue: queue.stringValue, redundancy: redundancy.stringValue, bitres: bitres.stringValue
                )
            }
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
