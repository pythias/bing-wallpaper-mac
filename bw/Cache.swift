//
//  Cache.swift
//  bw
//
//  Created by chenjie5 on 2017/4/12.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa

class Cache: NSObject {
    public static func shared() -> Cache {
        return Cache()
    }
    
    var rotationType: Rotation {
        get {
            if let value: String = UserDefaults.standard.string(forKey: kCacheRotationType) {
                return Rotation(rawValue: value)!
            }
            
            return Rotation.random
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: kCacheRotationType)
        }
    }
    
    var startOnLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kCacheStartOnLogin)
        } set {
            UserDefaults.standard.set(newValue, forKey: kCacheStartOnLogin)
        }
    }
}
