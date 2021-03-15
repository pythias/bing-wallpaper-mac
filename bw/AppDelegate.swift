//
//  AppDelegate.swift
//  bw
//
//  Created by chenjie5 on 2017/4/1.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarMenu: StatusBarMenu? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        try! Sqlite.shared().setupDatabase()
        Bing.shared().download(count: 8)
        
        self.statusBarMenu = StatusBarMenu(statusBar: NSStatusBar.system)
        self.statusBarMenu?.delegate = self
        
        Refresh.shared().createTimer()
        
        NSLog("applicationDidFinishLaunching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSLog("applicationWillTerminate")
    }
}


extension AppDelegate: StatusBarMenuDelegate {
    func statusBarMenuDidSelectQuit() {
        NSApplication.shared.terminate(self)
    }
}
