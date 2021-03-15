//
//  WallpaperDetail.swift
//  bw
//
//  Created by pythias on 2021/3/15.
//  Copyright © 2021 duo. All rights reserved.
//

import Cocoa

let DETAIL_WIDTH = 400
let DETAIL_HEIGHT = 48

class WallpaperDetail: NSPanel {
    private var detailText: NSTextField? = nil
    private var detailButton: NSButton? = nil
    private var wallpaper: Image? = nil
        
    public init(for wallpaper: Image, at screen: NSScreen) {
        let fullRect = NSRect(x: Int(screen.visibleFrame.minX) + 10, y: Int(screen.visibleFrame.minY) + 10, width: DETAIL_WIDTH, height: DETAIL_HEIGHT)
        super.init(contentRect:fullRect, styleMask: [.nonactivatingPanel], backing: .buffered, defer: true);
        self.wallpaper = wallpaper
        
        self.level = .mainMenu
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        let view = NSView(frame: self.frame)
        self.contentView = view
        
        let textRect = NSRect(x: 0, y: 0, width: DETAIL_WIDTH - DETAIL_HEIGHT, height: DETAIL_HEIGHT)
        detailText = NSTextField(frame: textRect)
        detailText?.stringValue = wallpaper.info
        detailText?.isSelectable = true
        detailText!.isEditable = false
        view.addSubview(detailText!)
        
        let buttonRect = NSRect(x: DETAIL_WIDTH - DETAIL_HEIGHT, y: 0, width: DETAIL_HEIGHT, height: DETAIL_HEIGHT)
        detailButton = NSButton(frame: buttonRect)
        detailButton?.bezelStyle = .helpButton
        detailButton?.isBordered = true
        detailButton?.target = self
        detailButton?.title = ""
        detailButton?.action = #selector(goDetail)
        view.addSubview(detailButton!)
    }
    
    public func setWallpaper(wallpaper: Image) {
        self.wallpaper = wallpaper
        detailText?.stringValue = wallpaper.info
    }

    @objc public func goDetail() {
        let url = URL(string: kBingSearchUrl.appending(self.wallpaper!.info.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        NSWorkspace.shared.open(url!)
    }
}
