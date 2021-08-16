//
//  StatusBarMenu.swift
//  bw
//
//  Created by chenjie5 on 2017/4/11.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa
import ServiceManagement

class StatusBarMenu: NSObject {
    struct Constants {
        static let helperBundlerId = "com.duo.bwHelper" as CFString
    }
    
    weak var delegate: StatusBarMenuDelegate?
    private var statusItem: NSStatusItem
    private var quitItem = NSMenuItem(title: Localized.shared().menu(kStatusItemQuit), action: #selector(quitAction), keyEquivalent: "")
    private var randomItem = NSMenuItem(title: Localized.shared().menu(kStatusItemRandom), action: #selector(randomAction(sender:)), keyEquivalent: "")
    private var todayItem = NSMenuItem(title: Localized.shared().menu(kStatusItemToday), action: #selector(todayAction(sender:)), keyEquivalent: "")
    private var infoItem = NSMenuItem(title: Localized.shared().menu(kStatusItemShow), action: #selector(infoAction(sender:)), keyEquivalent: "")
    private var autoLaunchItem = NSMenuItem(title: Localized.shared().menu(kStatusItemStart), action: #selector(autoLaunchAction), keyEquivalent: "")
    
    init(statusBar: NSStatusBar) {
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.image = NSImage(named: kStatusIcon)
        
        super.init()
        
        self.createMenu()
    }
    
    private func createMenu() {
        statusItem.menu = NSMenu()
        
        self.addRandomMenu()
        self.addTodayMenu()
        statusItem.menu?.addItem(NSMenuItem.separator())
        
        self.addInfoMenu()
        self.addAutoMenu()
        statusItem.menu?.addItem(NSMenuItem.separator())
        
        self.addQuitMenu()
        
        self.loadSaved()
    }
    
    private func loadSaved() {
        let rotation = Cache.shared().rotationType
        switch rotation {
        case .random:
            self.randomItem.state = NSControl.StateValue.on
            Wallpaper.shared().random()
        case .today:
            self.todayItem.state = NSControl.StateValue.on
            Wallpaper.shared().today()
        }
        
        if Cache.shared().startOnLogin {
            self.autoLaunchItem.state = .on
        }
    }
    
    private func addRandomMenu() {
        randomItem.image = NSImage(named: kStatusItemRandomIcon)
        randomItem.target = self
        statusItem.menu?.addItem(randomItem)
    }
    
    @objc private func randomAction(sender: AnyObject?) {
        if self.randomItem.state == NSControl.StateValue.on {
            return
        }
        
        Cache.shared().rotationType = Rotation.random
        
        self.randomItem.state = NSControl.StateValue.on
        self.todayItem.state = NSControl.StateValue.off
        
        Wallpaper.shared().random()
    }
    
    private func addTodayMenu() {
        todayItem.image = NSImage(named: kStatusItemTodayIcon)
        todayItem.target = self
        statusItem.menu?.addItem(todayItem)
    }
    
    @objc private func todayAction(sender: AnyObject?) {
        if self.todayItem.state == NSControl.StateValue.on {
            return
        }
        
        Cache.shared().rotationType = Rotation.today
        
        self.todayItem.state = NSControl.StateValue.on
        self.randomItem.state = NSControl.StateValue.off
        
        Wallpaper.shared().today()
    }
    
    private func addInfoMenu() {
        infoItem.target = self
        statusItem.menu?.addItem(infoItem)
    }
    
    @objc private func infoAction(sender: AnyObject?) {
        if infoItem.state == .on {
            infoItem.state = .off
            Wallpaper.shared().hideDetails()
        } else {
            infoItem.state = .on
            Wallpaper.shared().showDetails()
        }
    }
    
    private func addQuitMenu() {
        quitItem.image = NSImage(named: kStatusItemQuitIcon)
        quitItem.target = self
        statusItem.menu?.addItem(quitItem)
    }
    
    @objc private func quitAction() {
        delegate?.statusBarMenuDidSelectQuit()
    }
    
    private func addAutoMenu() {
        autoLaunchItem.target = self
        statusItem.menu?.addItem(autoLaunchItem)
    }
    
    @objc private func autoLaunchAction() {
        if autoLaunchItem.state == .on {
            autoLaunchItem.state = .off
        } else {
            autoLaunchItem.state = .on
        }
        
        let autoLaunch = (autoLaunchItem.state == .on)
        Cache.shared().startOnLogin = autoLaunch
        if (SMLoginItemSetEnabled(Constants.helperBundlerId, autoLaunch)) {
            NSLog("Bing Wallpaper updated auto lauch to %d", autoLaunch)
        }
    }
}

protocol StatusBarMenuDelegate: AnyObject {
    func statusBarMenuDidSelectQuit()
}
