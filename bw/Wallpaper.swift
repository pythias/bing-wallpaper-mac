//
//  Wallpaper.swift
//  bw
//
//  Created by chenjie5 on 2017/4/11.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa
import GRDB

class Wallpaper: NSObject {
    static var detailWindows = [CGDirectDisplayID: WallpaperDetail]()
    
    public static func shared() -> Wallpaper {
        return Wallpaper()
    }
    
    public func today() {        
        self.setWallpaper(random: false)
    }
    
    public func random() {
        self.setWallpaper(random: true)
    }
    
    private func setWallpaper(random: Bool) {
        do {
            let sharedWorkspace = NSWorkspace.shared
            var screens = NSScreen.screens
            let wallpapers = random ? Image.random(count: screens.count * 2) : Image.latest(count: screens.count * 2)
            for wallpaper in wallpapers {
                if FileManager.default.fileExists(atPath: wallpaper.localPath) {
                    let screen = screens.popLast()!;
                    try sharedWorkspace.setDesktopImageURL(NSURL.fileURL(withPath: wallpaper.localPath), for: screen, options: [:])
                    self._updateDetail(wallpaper: wallpaper, screen: screen)
                }
                
                if screens.isEmpty {
                    break
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func hideDetails() {
        for screen in NSScreen.screens {
            let screenId = screen.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as! CGDirectDisplayID
            if Wallpaper.detailWindows[screenId] != nil {
                let detailWindow = Wallpaper.detailWindows[screenId]!
                detailWindow.orderOut(nil)
            }
        }
    }
    
    public func showDetails() {
        let sharedWorkspace = NSWorkspace.shared
        let screens = NSScreen.screens
        for screen in screens {
            let url = sharedWorkspace.desktopImageURL(for: screen)!
            let image = Image.byName(name: url.lastPathComponent)
            if image == nil {
                continue
            }
            
            self._showDetail(wallpaper: image!, screen: screen)
        }
    }
    
    private func _updateDetail(wallpaper: Image, screen: NSScreen) -> WallpaperDetail {
        let screenId = screen.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as! CGDirectDisplayID
        let detailWindow: WallpaperDetail
        if Wallpaper.detailWindows[screenId] == nil {
            detailWindow = WallpaperDetail(for: wallpaper, at: screen)
            Wallpaper.detailWindows[screenId] = detailWindow
        } else {
            detailWindow = Wallpaper.detailWindows[screenId]!
            detailWindow.setWallpaper(wallpaper: wallpaper)
        }
        
        return detailWindow
    }
    
    private func _showDetail(wallpaper: Image, screen: NSScreen) {
        let detailWindow = self._updateDetail(wallpaper: wallpaper, screen: screen)
        detailWindow.orderFrontRegardless()
    }
}
