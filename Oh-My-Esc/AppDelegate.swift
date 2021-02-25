//
//  AppDelegate.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 1/8/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Common resource for managing mask monitor.
    var monitor: Any?
    // END
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let requestType = kIOHIDRequestTypeListenEvent
        
        if IOHIDCheckAccess(requestType) != kIOHIDAccessTypeGranted { IOHIDRequestAccess(requestType) }
        
        let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            
            switch event.keyCode {
            case 53:
                OMSoundManager.shared.playSound()
            default: break
            }
        }
        
        self.monitor = monitor
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        print("monitor info before remove it from NSEvent: \(String(describing: self.monitor))")
        NSEvent.removeMonitor(self.monitor!)
    }
}

