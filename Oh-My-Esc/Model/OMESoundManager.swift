//
//  OMSoundManager.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 2/25/21.
//

import Cocoa

class OMESoundManager: NSObject {
    
    static let shared = OMESoundManager()
    
    var selected = ""
    
    public static let sounds = ["Ding",
                                "Mooyaho Classic",
                                "Mooyaho 2021",
                                "Beep",
                                
                                "Custom..."]
    
    private override init() { }
    
    func playSound() {
        
        switch self.selected {
        
        case "Ding":
            guard let a = NSDataAsset(name: "OME_ding") else { fatalError() }
            guard let sound = NSSound(data: a.data) else { fatalError() }
            sound.play()
            
        case "Mooyaho Classic":
            guard let a = NSDataAsset(name: "OME_mooyaho_Classic") else { fatalError() }
            guard let sound = NSSound(data: a.data) else { fatalError() }
            sound.play()
            
        case "Mooyaho 2021":
            guard let a = NSDataAsset(name: "OME_mooyaho_2021") else { fatalError() }
            guard let sound = NSSound(data: a.data) else { fatalError() }
            sound.play()
            
        case "Beep":
            NSSound.beep()
            
        default:
            guard let url = UserDefaults.standard.url(forKey: "custom_sound_url") else { fatalError() }
            guard let sound = NSSound(contentsOf: url, byReference: true) else { fatalError() }
            sound.play()
        }
    }
    
    func turnOnSound() {
        
        let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            print("Event: \(String(describing: event))")
            switch event.keyCode {
            case 53:
                print("ESC!!!")
                OMESoundManager.shared.playSound()
            default: break
            }
        }
        
        (NSApplication.shared.delegate as! AppDelegate).monitor = monitor
        print("monitor info: \(String(describing: monitor))")
    }
    
    func turnOffSound() {
        
        guard let monitor = (NSApplication.shared.delegate as! AppDelegate).monitor else {
            return
        }
        
        NSEvent.removeMonitor(monitor)
        (NSApplication.shared.delegate as! AppDelegate).monitor = nil
    }
    
    func showStatus() -> Bool {
        
        guard (NSApplication.shared.delegate as! AppDelegate).monitor != nil else {
            
            return false
        }
        
        return true
    }
}
