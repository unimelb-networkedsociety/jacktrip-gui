//
//  JacktripCore.swift
//  JacktripGui
//
//  Created by Yunhan on 20/3/18.
//  Copyright © 2018 NSI Lab. All rights reserved.
//

// Soul of the project
import Foundation

class JacktripCore {
    private var jacktripProcesses: [Process] = []
    static let instance = JacktripCore()
    
    var output: String = "" {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ProcessPipeNotificationKey), object: self) 
        }
    }
    
    func startServer(_ port: String) -> Process {
        // shell command to start server: jacktrip -s [port]
        return invokeProcess(args:["-s", "-o\(port)0"])
    }
    
    func startClient(_ ip: String, _ port: String) -> Process {
        // shell command to connect: jacktrip -c [ip] [port]
        return invokeProcess(args:["-c", ip, "-o\(port)0"])
    }
    
    func checkProcessStatus(target: Process) -> Bool {
        return target.isRunning
    }
    
    func killAllProcess() {
        for process in jacktripProcesses {
            if (process.isRunning) {
                process.terminate()
            }
        }
        
        jacktripProcesses = []
    }
    
    func killProcess(target: Process) {
        if(target.isRunning){
            target.terminate()
            jacktripProcesses.remove(at: jacktripProcesses.index(of: target)!)
        }
    }
    
    private func invokeProcess(args: [String]) -> Process {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: jacktripURL)
        task.arguments = args;
        jacktripProcesses.append(task)
        
        let pipe = Pipe()
        task.standardError = pipe
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
 
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
          object: outHandle, queue: nil) {  notification -> Void in
            let data = outHandle.availableData
            if data.count > 0 {
                if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    self.output += "\(str)\n"
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                print("EOF on stdout from process")
                NotificationCenter.default.removeObserver(obs1)
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
          object: task, queue: nil) { notification -> Void in
            NotificationCenter.default.removeObserver(obs2)
            print("terminated")
            if let id = self.jacktripProcesses.index(of: task) {
                self.jacktripProcesses.remove(at: id)
            }
        }
        
        do {
            try task.run()
        } catch {
            print("Unexpected error: \(error).")
        }
        
        return task
    }
    
    func clearLog() {
        output = ""
    }
}
