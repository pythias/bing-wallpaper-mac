//
//  Localized.swift
//  bw
//
//  Created by chenjie5 on 2017/5/5.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class Localized: NSObject {
    public static func shared() -> Localized {
        return Localized()
    }
    
    public func menu(_ key: String) -> String {
        return self.value(key, table: kLocalizedTableNameMenu)
    }
    
    public func value(_ key: String, table: String) -> String {
        return NSLocalizedString(key, tableName: table, bundle: Bundle.main, comment: "")
    }
}
