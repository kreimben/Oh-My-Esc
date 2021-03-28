//
//  OMEAuth.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 3/28/21.
//

import Cocoa

class OMEAuth: NSObject {
    
    class
    func hasAuth() -> Bool { return AXIsProcessTrusted() }
}
