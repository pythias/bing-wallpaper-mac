//
//  main.swift
//  bwHelper
//
//  Created by 陈杰 on 2021/8/13.
//  Copyright © 2021 duo. All rights reserved.
//

import Foundation
import AppKit

let delegate = AutoLauncher()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
