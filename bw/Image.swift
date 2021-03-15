//
//  Image.swift
//  bw
//
//  Created by chenjie5 on 2017/4/24.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa
import GRDB
import Alamofire

class Image: Record {
    public var date: Date = Date()
    public var name: String = ""
    public var mkt: BingMKT = BingMKT.zh_cn
    public var hsh: String = ""
    public var info: String = ""
    public var url: String = ""
    
    private var _localPath: String = ""
    
    var hshUrl: String {
        get {
            return "\(kBingDownloadUrl)/\(self.hsh)"
        }
    }
    
    var localPath: String {
        get {
            if self._localPath == "" {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM/yyyy-MM-dd"
                self._localPath = Image.rootPath() + "/" + formatter.string(from: self.date) + "_" + self.name + ".jpg"
            }
            
            return self._localPath
        }
    }
    
    var downloaded: Bool {
        get {
            return FileManager.default.fileExists(atPath: self.localPath)
        }
    }
        
    init(hsh: String) {
        self.hsh = hsh
        
        super.init()
    }
    
    required init(row: Row) {
        self.date = row["date"]
        self.name = row["name"]
        self.mkt = BingMKT(rawValue: row["mkt"]) ?? BingMKT.zh_cn
        self.hsh = row["hsh"]
        self.info = row["info"]
        self.url = row["url"]
        
        super.init(row: row)
    }
    
    required init(json: NSDictionary, mkt: BingMKT) {
        self.date = Image._fromJsonDate(from: json["startdate"] as! String)
        self.name = Image._fromJsonName(from: json["url"] as! String)
        self.mkt = mkt
        self.hsh = json["hsh"] as! String
        self.info = json["copyright"] as! String
        self.url = json["url"] as! String
        
        super.init()
    }
    
    override class var databaseTableName: String {
        return "images"
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["date"] = self.date
        container["name"] = self.name
        container["hsh"] = self.hsh
        container["info"] = self.info
        container["url"] = self.url
        container["mkt"] = self.mkt.rawValue
    }
    
    public func save() -> Bool {
        do {
            return try Sqlite.shared().dbQueue.inDatabase { db -> Bool in
                let exists = try self.exists(db)
                if (!exists) {
                    try self.save(db)
                    return true
                }
                
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
        
    public func download(completionHandle: @escaping (Bool) -> Void) {
        if self.downloaded {
            completionHandle(true)
            return
        }
        
        let fileURL = URL(fileURLWithPath: self.localPath)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(self.hshUrl, to: destination).response { response in
            if response.error != nil || response.response?.statusCode != 200 {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    completionHandle(true)
                } catch {
                    print(error)
                    completionHandle(false)
                }
            } else {
                print(self.hshUrl)
                completionHandle(false)
            }
        }
    }
    
    public static func latest(count: Int) -> [Image] {
        var wallpapers = [Image]()
        do {
            try Sqlite.shared().dbQueue.inDatabase { db in
                let sortedByDate = Image.order(Column("date").desc).limit(count + 1)
                let images = try sortedByDate.fetchAll(db)
                for image in images {
                    if image.downloaded {
                        wallpapers.append(image)
                    } else {
                        image.download { (_) in
                            NSLog("wallpaper downloaded, %@", image.info)
                        }
                    }
                    
                    if wallpapers.count >= count {
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return wallpapers
    }
    
    public static func random(count: Int) -> [Image] {
        var wallpapers = [Image]()
        do {
            try Sqlite.shared().dbQueue.inDatabase { db in
                let images = try Image.fetchAll(db, sql: "SELECT * FROM `images` ORDER BY random() LIMIT \(count + 1)")
                for image in images {
                    if image.downloaded {
                        wallpapers.append(image)
                    } else {
                        image.download { (_) in
                            NSLog("wallpaper downloaded, %@", image.info)
                        }
                    }
                    
                    if wallpapers.count >= count {
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return wallpapers
    }
    
    public static func rootPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return "\(documentsPath)/\(kName)"
    }
    
    public static func byName(name: String) -> Image? {
        do {
            let components = name.split(separator: "_")
            if components.count != 2 {
                return nil
            }
            
            let date: Date = Image._fromNameDate(from: String(components[0]))
            let shortName: String = String(components[1].split(separator: ".").first!)
            
            return try Sqlite.shared().dbQueue.inDatabase { db -> Image? in
                let fetchByName = Image.filter(Column("name") == shortName).filter(Column("date") == date).limit(1)
                return try fetchByName.fetchOne(db)
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    private static func _fromJsonDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.date(from: string)!
    }
    
    private static func _fromNameDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)!
    }
    
    private static func _fromJsonName(from url: String) -> String {
        //th?id=OHR.CapePerpetua_ZH-CN4150223705_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp
        //OHR.CapePerpetua_ROW5628754232_1920x1080.jpg
        let components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                if item.name == "id" {
                    return (item.value?.components(separatedBy: "_").first!.components(separatedBy: ".").last!)!
                }
            }
        }

        return url.components(separatedBy: "_").first!.components(separatedBy: "/").last!.components(separatedBy: ".").last!
    }
}
