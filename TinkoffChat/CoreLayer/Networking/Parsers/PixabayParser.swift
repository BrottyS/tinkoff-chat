//
//  PixabayParser.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

//"previewHeight":125,
//"likes":4,
//"favorites":5,
//"tags":"sun flower, flower, yellow flower",
//"webformatHeight":537,
//"views":489,
//"webformatWidth":640,
//"previewWidth":150,
//"comments":8,
//"downloads":253,
//"pageURL":"https://pixabay.com/en/sun-flower-flower-yellow-flower-2954258/",
//"previewURL":"https://cdn.pixabay.com/photo/2017/11/16/11/44/sun-flower-2954258_150.png",
//"webformatURL":"https://pixabay.com/get/eb3cb40b2af1093ed95c4518b74b4794e774e6d604b0144094f2c771a5ebb0_640.png",
//"imageWidth":2146,
//"user_id":1767157,
//"user":"Capri23auto",
//"type":"photo",
//"id":2954258,
//"userImageURL":"https://cdn.pixabay.com/user/2017/02/27/17-41-12-687_250x250.jpg",
//"imageHeight":1803

struct PixabayApiModel {
    //var previewHeight: Int?
    //var previewWidth: Int?
    var previewURL: String?
    //var imageHeight: Int?
    //var imageWidth: Int?
    //var webformatURL: String?
}

class PixabayParser: IParser {
    
    typealias Model = [PixabayApiModel]
    
    func parse(data: Data) -> [PixabayApiModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String : Any]] else {
                return nil
            }
            
            var images: [PixabayApiModel] = []
            
            for hit in hits {
                guard /*let appObjectName = appObject["im:name"] as? [String : String],
                    let name = appObjectName["label"],
                    let appObjectId = appObject["id"] as? [String : Any],
                    let appObjectIdAttributes = appObjectId["attributes"] as? [String : String],
                    let identifier = appObjectIdAttributes["im:id"],
                    let appObjectImages = appObject["im:image"] as? [[String : Any]],
                    let iconUrl = appObjectImages.last?["label"] as? String*/
                    
                    let previewURL = hit["previewURL"] as? String
                    
                    else { continue }
                images.append(PixabayApiModel(previewURL: previewURL))
            }
            
            return images
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
    
}
