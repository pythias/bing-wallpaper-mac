//
//  AppDelegate.swift
//  bwHelper
//
//  Created by 陈杰 on 2021/8/11.
//  Copyright © 2021 duo. All rights reserved.
//

import Cocoa

class AutoLauncher: NSObject, NSApplicationDelegate {
    struct Constants {
        static let mainAppBundleId = "com.duo.bw"
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Constants.mainAppBundleId
        }
        
        var path = Bundle.main.bundlePath as NSString
        for _ in 1...4 {
            path = path.deletingLastPathComponent as NSString
        }
        
        if isRunning {
            NSLog("Bing Wallpaper, already started, path: %@")
            return
        }
        
        NSLog("Bing Wallpaper, application will be opened, path: %@", path)
        NSWorkspace.shared.open(URL(fileURLWithPath: path as String))
    }
}

