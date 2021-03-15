//
//  Refresh.swift
//  bw
//
//  Created by chenjie5 on 2017/4/12.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class Refresh: NSObject {
    public static func shared() -> Refresh {
        return Refresh()
    }
    
    public func createTimer() {
        if #available(OSX 10.12, *) {
            Timer.scheduledTimer(withTimeInterval: vDownloadTimerSeconds, repeats: true) { (timer) in
                self.downloadTimerDidFire();
            }
            
            Timer.scheduledTimer(withTimeInterval: vDownloadTimerSeconds, repeats: true) { (timer) in
                self.randomTimerDidFire();
            }
        } else {
            Timer.scheduledTimer(timeInterval: vDownloadTimerSeconds, target: self, selector: #selector(downloadTimerDidFire), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: vRandomTimerSeconds, target: self, selector: #selector(randomTimerDidFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc public func downloadTimerDidFire() {
        Bing.shared().download(count: 1)
    }
    
    @objc public func randomTimerDidFire() {
        if Cache.shared().rotationType == Rotation.random {
            Wallpaper.shared().random()
        }
    }
}
