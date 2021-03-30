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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusBarIcon), name: .updateStatusBarIcon, object: nil)
        
        // MARK: Check accessibility and Add monitor.
        if !AXIsProcessTrusted() { IOHIDRequestAccess(.init(0)) }
        
        // MARK: Implement menu bar app.        
        self.updateStatusBarIcon()
        
        self.statusItem.menu = OMEMenuMaker.shared.setMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        print("monitor info before remove it from NSEvent: \(String(describing: self.monitor))")
        OMESoundManager.shared.turnOffSound()
    }
}

extension AppDelegate {
    
    @objc
    func updateStatusBarIcon() {
        
        if let button = statusItem.button {
            
            let properSize = NSSize(width: 18, height: 18)
            
            let enable  = #imageLiteral(resourceName: "OME_Enable_Icon").resized(to: properSize)
            let disable = #imageLiteral(resourceName: "OME_Disable_Icon").resized(to: properSize)
            
            button.image = OMESoundManager.shared.showStatus() ? enable : disable
        }
    }
}
