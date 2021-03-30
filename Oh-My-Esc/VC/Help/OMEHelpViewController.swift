//
//  OMEHelpViewController.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 3/30/21.
//

import Cocoa

class OMEHelpViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension OMEHelpViewController {
    
    @IBAction
    func visitWebsite(_ sender: NSButton) {
        
        NSWorkspace.shared.open(URL(string: "https://www.kreimben.com/")!)
    }
}
