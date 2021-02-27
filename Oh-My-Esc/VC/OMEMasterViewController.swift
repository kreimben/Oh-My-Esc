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
        
        if !self.hasAuth() { self.enableAlertCheckBox.state = .off }
    }
    
    private
    func hasAuth() -> Bool { return IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeGranted }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.checkUpdate()
    }
    
    private
    func initPopUpButton() {
        // TODO: Choice sound files and make it being shown.
    }
    
    private
    func checkUpdate() {
        OMEUpdater.shared.isAvailableToUpdate { (tag) in
            print("new version tag info: \(tag)")
            
            let alert = NSAlert()
            
            alert.messageText = """
                There is a new version of this app.

                \(tag.name)
                """
            
            alert.addButton(withTitle: "Download new version")
            alert.addButton(withTitle: "Nope")
            
            alert.beginSheetModal(for: self.view.window!) { (response) in
                switch response {
                case .alertFirstButtonReturn:
                    NSWorkspace.shared.open(tag.zipball_url)
                    
                case .alertSecondButtonReturn:
                    print("Second button!")
                    
                default: break
                }
            }
        }
    }
}

// MARK: @IBAction
extension OMEMasterViewController {
    
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
            
            alert.beginSheetModal(for: self.view.window!) { (response) in
                switch response {
                case .alertFirstButtonReturn:
                    print("OK")
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy")!)
                default: break
                }
            }
        }
    }
    
    @IBAction
    func choiceSound(_ sender: NSPopUpButton) {
        
        let selected = sender.titleOfSelectedItem
        
        if selected == "Custom..." {
            let panel = NSOpenPanel()
            
            panel.canChooseFiles                = true
            panel.canChooseDirectories          = false
            panel.allowsMultipleSelection       = false
            panel.canResolveUbiquitousConflicts = false
            panel.canDownloadUbiquitousContents = true
            panel.allowsConcurrentViewDrawing   = true
            
            panel.allowedFileTypes = ["mp3"]
            
            if panel.canBecomeKey { panel.makeKey() }
            
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
        
        NSWorkspace.shared.open(URL(string: "https://github.com/kreimben/Oh-My-Esc/issues")!)
    }
    
    @IBAction
    func showHelp(_ sender: NSButton) {
        
        let vc = storyboard?.instantiateController(withIdentifier: "HelpView") as! NSViewController
        
//        presentAsSheet(vc)
        presentAsModalWindow(vc)
    }
}
