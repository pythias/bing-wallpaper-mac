//
//  System.swift
//  bw
//
//  Created by chenjie5 on 2017/4/24.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class System: NSObject {
    public static func getVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    public static func setStartOnLogin(_ state: Int) {
        //SMLoginItemSetEnabled()
    }
}
