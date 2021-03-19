//
//  Sql.swift
//  bw
//
//  Created by chenjie5 on 2017/5/2.
//  Copyright © 2017年 duo. All rights reserved.
//

import GRDB

class Sqlite: NSObject {
    var dbQueue: DatabaseQueue!
    
    public static func shared() -> Sqlite {
        return Sqlite()
    }
    
    override init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath = documentsPath.appendingPathComponent(kName)
        var isDir : ObjCBool = false
        if !FileManager.default.fileExists(atPath: databasePath, isDirectory: &isDir) || !isDir.boolValue {
            try! FileManager.default.createDirectory(atPath: databasePath, withIntermediateDirectories: true, attributes: nil)
        }
        let databaseFile = databasePath.appending("/db-v2.sqlite")
        self.dbQueue = try! DatabaseQueue(path: databaseFile)
        
        //dbQueue.setupMemoryManagement(in: application)
    }
    
    func setupDatabase() throws {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("CreateTableImages") { db in
            try db.create(table: "images") { t in
                t.column("hsh", .text).notNull().primaryKey()
                t.column("date", .date).notNull()
                t.column("name", .text).notNull()
                t.column("info", .text).notNull()
                t.column("url", .text)
                t.column("mkt", .text).notNull()
            }
        }
        
        try migrator.migrate(dbQueue)
    }
}


