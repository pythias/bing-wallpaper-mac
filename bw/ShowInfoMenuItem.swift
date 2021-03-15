//
//  ShowInfoMenuItem.swift
//  bw
//
//  Created by chenjie5 on 2017/5/5.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class ShowInfoMenuItem: NSMenuItem {
    init() {
        super.init(title: Localized.shared().menu(kStatusItemShow), action: #selector(clickAction), keyEquivalent: "")
        
        self.target = self
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickAction() {
        let sharedWorkspace = NSWorkspace.shared
        let screens = NSScreen.screens
        for screen in screens {
            print(sharedWorkspace.desktopImageURL(for: screen)!)
            print(sharedWorkspace.desktopImageOptions(for: screen) as Any)
        }
    }
}
