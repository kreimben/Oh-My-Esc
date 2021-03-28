//
//  OMEMenuMaker.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 3/28/21.
//

import Cocoa

class OMEMenuMaker: NSObject {
    
    class
    func setMenu() -> NSMenu {
        
        let m = NSMenu()
        
        let status = NSMenuItem(title: "Status: \(OMESoundManager.shared.showStatus() ? "On" : "Off")", action: nil, keyEquivalent: "")
//        status.onStateImage = NSImage(named: NSImage.Name("ome_enable"))
//        status.offStateImage = NSImage(named: NSImage.Name("ome_disable"))
        status.state = OMESoundManager.shared.showStatus() ? .on : .off
        
        m.addItem(status)
        
        m.addItem(NSMenuItem.separator())

        let quit = NSMenuItem(title: "Quit this app", action: #selector(quitThisApp), keyEquivalent: "q")

        m.addItem(quit)
        
        return m
    }
    
    @objc
    func quitThisApp() { exit(-1) }
}
