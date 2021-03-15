//
//  main.swift
//  bw
//
//  Created by chenjie5 on 2017/4/1.
//  Copyright © 2017年 duo. All rights reserved.
//

import Foundation
import AppKit

let app = NSApplication.shared
let controller = AppDelegate()
app.setActivationPolicy(.prohibited)
app.delegate = controller
app.run()
