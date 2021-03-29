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
    @IBOutlet var playButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPopUpButton()
        
        if !OMEAuth.hasAuth() { self.enableAlertCheckBox.state = .off }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.initSelection()
        
        self.checkUpdate()
        
        self.enableAlertCheckBox.state = OMESoundManager.shared.showStatus() ? .on : .off
        
        if self.isAvailableToPlayCustomSound() {
            self.playButton.isEnabled = true
        } else { self.playButton.isEnabled = false }
    }
    
    private
    func initSelection() {
        
        let b = self.soundSelectionPopUpButton!
        
        // delete default items first.
        b.removeAllItems()
        
        b.addItems(withTitles: OMESoundManager.sounds)
        
        if UserDefaults.standard.url(forKey: "custom_sound_url") != nil {
            b.selectItem(at: b.numberOfItems - 1)
        } else {
            b.selectItem(at: 0)
        }
        
        OMESoundManager.shared.selected = b.titleOfSelectedItem!
    }
    
    private
    func isAvailableToPlayCustomSound() -> Bool {
        
        if self.soundSelectionPopUpButton.titleOfSelectedItem! == "Custom..." {
            guard UserDefaults.standard.url(forKey: "custom_sound_url") != nil else { return false }
        }
        
        return true
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
        if !OMEAuth.hasAuth() {
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
        } else {
            
            let status = OMESoundManager.shared.showStatus()
            
            if !status {
                OMESoundManager.shared.turnOnSound()
            } else {
                OMESoundManager.shared.turnOffSound()
            }
        }
    }
    
    @IBAction
    func choiceSound(_ sender: NSPopUpButton) {
        
        self.playButton.isEnabled = false
        
        let selected = sender.titleOfSelectedItem
        
        if selected == "Custom..." {
            let panel = NSOpenPanel()
            
            panel.canChooseFiles                = true
            panel.canChooseDirectories          = false
            panel.allowsMultipleSelection       = false
            panel.canResolveUbiquitousConflicts = false
            panel.canDownloadUbiquitousContents = true
            panel.allowsConcurrentViewDrawing   = true
            
            panel.allowedFileTypes = [
                "mp3",
                "mp4",
                "wav",
                "m4a",
                "aac"
            ]
            
            if panel.canBecomeKey { panel.makeKey() }
            
            panel.begin { (response) in
                if response == NSApplication.ModalResponse.OK {
                    print("Selected URL: \(String(describing: panel.url))")
                    
                    UserDefaults.standard.set(panel.url!, forKey: "custom_sound_url")
                    
                    self.playButton.isEnabled = self.isAvailableToPlayCustomSound() ? true : false
                    OMESoundManager.shared.selected = ""
                }
            }
        } else { // Default sounds.
            
            OMESoundManager.shared.selected = sender.titleOfSelectedItem!
            UserDefaults.standard.removeObject(forKey: "custom_sound_url")
            self.playButton.isEnabled = true
        }
    }
    
    @IBAction
    func playSound(_ sender: NSButton) {
        
        OMESoundManager.shared.playSound()
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
