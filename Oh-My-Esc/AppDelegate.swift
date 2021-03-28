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
        let requestType = kIOHIDRequestTypeListenEvent
        
        if IOHIDCheckAccess(requestType) != kIOHIDAccessTypeGranted { IOHIDRequestAccess(requestType) }
        
        let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            print("Event: \(String(describing: event))")
            switch event.keyCode {
            case 53:
                print("ESC!!!")
                OMESoundManager.shared.playSound()
            default: break
            }
        }
        
        self.monitor = monitor
        print("monitor info: \(String(describing: monitor))")
        
        // MARK: Implement menu bar app.
        if let button = statusItem.button {

            button.image = NSImage(named: "AppIcon")!.resized(to: NSSize(width: 18, height: 18))
            
            self.setMenu()

        } else { fatalError() }
    }
    
    func setMenu() {
        
        let m = NSMenu()
        
        let status = NSMenuItem(title: "Status: \(OMEAuth.hasAuth() ? "On" : "Off")", action: nil, keyEquivalent: "")
        status.onStateImage = NSImage(named: NSImage.Name("ome_enable"))
        status.offStateImage = NSImage(named: NSImage.Name("ome_disable"))
        status.state = OMEAuth.hasAuth() ? .on : .off
        
        m.addItem(status)

        let quit = NSMenuItem(title: "Quit this app", action: #selector(quitThisApp), keyEquivalent: "q")

        m.addItem(quit)
        
        statusItem.menu = m
    }
    
    @objc
    func quitThisApp() { exit(-1) }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        print("monitor info before remove it from NSEvent: \(String(describing: self.monitor))")
        NSEvent.removeMonitor(self.monitor!)
    }
}

