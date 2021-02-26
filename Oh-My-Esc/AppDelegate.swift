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
    
    let statusItem = NSStatusBar.system.statusItem(withLength: 18)
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // MARK: Check accessibility and Add monitor.
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
        
        // MARK: Implement menu bar app.
        if let button = statusItem.button {
//            let isGranted = IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeGranted
            button.image = NSImage(named: "AppIcon")!.resized(to: NSSize(width: 18, height: 18))
//            NSLog("menu bar image: \(String(describing: button.image))")
            button.action = #selector(openApp(_:))
        } else { fatalError() }
        
        let p = NSPopover()
        p.contentSize = NSSize(width: 500, height: 350)
        p.behavior = .transient
        p.contentViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "first") as? NSViewController
        self.popover = p
    }

    @objc
    func openApp(_ sender: Any?) {
        if popover.isShown { closePopover(sender: sender) }
        else { showPopover(sender: sender) }
    }

    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        print("monitor info before remove it from NSEvent: \(String(describing: self.monitor))")
        NSEvent.removeMonitor(self.monitor!)
    }
}

