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
        
        // MARK: Check user's accessibility
        if AXIsProcessTrusted() { // If user give accessibility
            print("Success to get accessibility!")
            
            let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
                
                switch event.keyCode {
                case 53:
//                    print("ESC pressed!")
                    OMSoundManager.shared.playSound()
                default: break
                }
            }
            
            (NSApplication.shared.delegate as! AppDelegate).monitor = monitor
            
        } else { // If user not give accessiblity
            print("Get accessibility first!")
            
            self.showAlert()
        }
    }
    
    private
    func showAlert() {
        
        let alert = NSAlert()
        
        alert.messageText = "You seem to not allow accessibility to this app.\n\nSet it first please :)"
        
        alert.addButton(withTitle: "Allow")
        alert.addButton(withTitle: "Deny")
        
        alert.alertStyle = .informational
        
        alert.informativeText = "Because This app must have accessibility to monitor key stroke (What you type)."
        
        let response = alert.runModal()
        print("user response: \(response)")
        if response.rawValue == 1000 {
            
            // Open setting's privacy tabs
            IOHIDRequestAccess(.init(0))
            
        } else {
            
            // Send good bye message to user :(
            self.showOKBye()
        }
    }
    
    private
    func showOKBye() {
        let alert = NSAlert()
        
        alert.messageText = "OK Bye :("
        
        alert.addButton(withTitle: "Quit this app")
        
        let response = alert.runModal()
        if response.rawValue == 0 {
            exit(-1)
        }
    }
}

// MARK: @IBAction
extension MatsterViewController {
    
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
