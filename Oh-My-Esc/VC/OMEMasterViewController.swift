//
//  MasterViewController.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 1/8/21.
//

import Cocoa

class OMEMasterViewController: NSViewController {
    
    // MARK: @IBOutlet
    @IBOutlet var enableAlertCheckBox: NSButton!
    @IBOutlet var soundSelectionPopUpButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPopUpButton()
    }
    
    private func initPopUpButton() {
        // TODO: Choice sound files and make it being shown.
    }
}

// MARK: @IBAction
extension OMEMasterViewController {
    
    @IBAction
    func choiceSound(_ sender: NSPopUpButton) {
        
        let selected = sender.titleOfSelectedItem
        
        if selected == "Custom..." {
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.canResolveUbiquitousConflicts = true
            panel.canDownloadUbiquitousContents = true
            panel.isAccessoryViewDisclosed = true
            panel.makeKey()
            panel.begin { (response) in
                if response == NSApplication.ModalResponse.OK {
                    print("Selected URL: \(String(describing: panel.urls))")
                }
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
