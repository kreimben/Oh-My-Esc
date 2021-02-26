//
//  OMSoundManager.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 2/25/21.
//

import Cocoa

class OMESoundManager: NSObject {
    
    static let shared = OMESoundManager()
    
    private override init() { }
    
    func playSound() {
        NSLog("Play Sound!")
    }
}