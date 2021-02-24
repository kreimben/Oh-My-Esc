//
//  OMSoundManager.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 2/25/21.
//

import Cocoa

class OMSoundManager: NSObject {
    
    static let shared = OMSoundManager()
    
    private override init() { }
    
    func playSound() {
        NSLog("Play Sound!")
    }
}
