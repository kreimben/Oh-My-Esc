//
//  OMEMenuMaker.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 3/28/21.
//

import Cocoa

class OMEMenuMaker: NSObject {
    
    private var statusMenu: NSMenuItem?
    
    public static let shared = OMEMenuMaker()
    
    func setMenu() -> NSMenu {
        
        let m = NSMenu()
        
        m.delegate = self
        
        let openThisApp = NSMenuItem(title: "Open this app", action: #selector(openApp), keyEquivalent: "")
        
        openThisApp.target = self
        
        m.addItem(openThisApp)
        
        let status = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        
        self.statusMenu = status
        
        status.target = self
        status.action = #selector(changeStatus)
        m.addItem(status)
        
        m.addItem(NSMenuItem.separator())

        let quit = NSMenuItem(title: "Quit this app", action: #selector(quitThisApp), keyEquivalent: "q")
        
        quit.target = self

        m.addItem(quit)
        
        return m
    }
    
    func updateState() {
        
        let status = OMESoundManager.shared.showStatus()
        
        self.statusMenu!.title = "Status: \(status ? "On" : "Off")"
        self.statusMenu!.state = status ? .on : .off
    }
    
    @objc
    func openApp() {
        guard let vc = NSStoryboard(name: "OMEMasterView", bundle: nil).instantiateInitialController() as? NSWindowController else { fatalError() }
        
        vc.showWindow(self)
    }
    
    @objc
    func changeStatus() {
        
        if OMESoundManager.shared.showStatus() {
            OMESoundManager.shared.turnOffSound()
        } else {
            OMESoundManager.shared.turnOnSound()
        }
    }
    
    @objc
    func quitThisApp() { exit(-1) }
}

extension OMEMenuMaker: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        NSLog("Menu will open!")
        
        self.updateState()
    }
}
