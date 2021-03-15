//
//  Bing.swift
//  bw
//
//  Created by chenjie5 on 2017/4/11.
//  Copyright © 2017年 duo. All rights reserved.
//

import Cocoa
import Alamofire
import PromiseKit

enum BineError: Error {
    case fetchMkt
    case download
}

class Bing: NSObject {
    public static func shared() -> Bing {
        return Bing()
    }

    public func download(count: Int = 1) {
        var promises = [Promise<[Image]>]()
        for mkt in BingMKT.allValues {
            promises.append(_fetchImages(mkt: mkt, count: count))
        }
        
        var downloadPromises = [Promise<Image>]()
        firstly {
            when(fulfilled: promises).done { [self] v in
                for images in v {
                    for image in images {
                        downloadPromises.append(_downloadImage(image: image))
                    }
                }
            }.then { v in
                firstly {
                    when(fulfilled: downloadPromises).done { images in
                        for image in images {
                            print("download", image)
                        }
                    }
                }
            }
        }
    }
    
    private func _fetchImages(mkt: BingMKT, count: Int) -> Promise<[Image]> {
        return Promise { seal in
            let url = "\(kBingAPI)?format=js&idx=0&n=\(count)&mkt=\(mkt.rawValue)"
            Alamofire.request(url).responseJSON { response in
                guard let json = response.result.value as? NSDictionary else {
                    seal.reject(BineError.fetchMkt)
                    return
                }
                
                guard let images = json["images"] as? [NSDictionary] else {
                    seal.reject(BineError.fetchMkt)
                    return
                }
                
                var imageRows = [Image]()
                for image in images {
                    let imageRow = Image(json: image, mkt: mkt)
                    if (imageRow.save()) {
                        imageRows.append(imageRow)
                        print("save", imageRow)
                    }
                }
                
                seal.fulfill(imageRows)
            }
        }
    }
        
    private func _downloadImage(image: Image) -> Promise<Image> {
        return Promise { seal in
            image.download { (result) in
                if (result) {
                    seal.fulfill(image)
                } else {
                    seal.reject(BineError.download)
                }
            }
        }
    }
}
