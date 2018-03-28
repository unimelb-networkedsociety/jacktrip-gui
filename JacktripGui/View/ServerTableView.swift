//
//  ServerTableView.swift
//  JacktripGui
//
//  Created by Yunhan Li on 24/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

import Cocoa

class ServerTableView: NSTableView {
    let portData = stride(from: 0, to: 100, by: 10).map {
        ["offset": String($0), "operation": ""]
    }

    func getPortOffset(index: Int) -> String? {
        if let ret = portData[index]["offset"] {
            return ret
        } else {
            return nil
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }
}

extension ServerTableView: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return portData.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        if tableColumn?.identifier.rawValue == "operation"{
            let result = tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "operation"), owner: self) as! ProcessTrigger
            return result
        } else {
            let result = tableView.makeView(withIdentifier:(tableColumn?.identifier)!, owner: self) as! NSTableCellView
            result.textField?.stringValue = portData[row][(tableColumn?.identifier.rawValue)!]!
            return result
        }
    }
}
