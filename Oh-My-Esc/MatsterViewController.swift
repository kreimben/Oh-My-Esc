//
//  MasterViewController.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 1/8/21.
//

import Cocoa

class MatsterViewController: NSViewController {
    
    // MARK: @IBOutlet
    @IBOutlet var enableAlertCheckBox: NSButton!
    @IBOutlet var soundSelectionPopUpButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.hasAuth() { self.enableAlertCheckBox.state = .off }
    }
    
    private
    func hasAuth() -> Bool { return IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeGranted }
}

// MARK: @IBAction
extension MatsterViewController {
    
    @IBAction
    func checkButtonClicked(_ sender: NSButton) {
        if !self.hasAuth() {
            self.enableAlertCheckBox.state = .off
            
            let alert = NSAlert()
            
            alert.messageText = """
                                You didn't allow this app to access \"Input Monitoring\"!

                                Please check \"Oh My Esc\" in \"Input Monitoring\".
                                """
            alert.addButton(withTitle: "Go to Allow")
            
            let result = alert.runModal()
            
            switch result {
            case .alertFirstButtonReturn:
                print("OK")
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy")!)
            default: break
            }
        }
    }
    
    @IBAction
    func adviseMeClicked(_ sender: NSButton) {
        
        NSWorkspace.shared.open(URL(string: "mailto:aksidion@kreimben.com")!)
    }
    
    @IBAction
    func bugReportClicked(_ sender: NSButton) {
        
        NSWorkspace.shared.open(URL(string: "http://github.com/kreimben/")!)
    }
    
    @IBAction
    func showHelp(_ sender: NSButton) {
        
        let vc = storyboard?.instantiateController(withIdentifier: "HelpView") as! NSViewController
        
        //        presentAsSheet(vc)
        presentAsModalWindow(vc)
    }
}
