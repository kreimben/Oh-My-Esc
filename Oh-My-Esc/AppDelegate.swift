//
//  AppDelegate.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 1/8/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Common resource for managing mask monitor.
    var monitor: Any?
    // END
    
    let statusItem = NSStatusBar.system.statusItem(withLength: 18)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // MARK: Check accessibility and Add monitor.
        if !AXIsProcessTrusted() {
            IOHIDRequestAccess(.init(0))
        }
        
        // MARK: Implement menu bar app.
        if let button = statusItem.button {

            button.image = NSImage(named: "AppIcon")!.resized(to: NSSize(width: 18, height: 18))

        } else { fatalError() }
        
        self.statusItem.menu = OMEMenuMaker.shared.setMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        print("monitor info before remove it from NSEvent: \(String(describing: self.monitor))")
        OMESoundManager.shared.turnOffSound()
    }
}

