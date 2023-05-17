//
//  Model.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import Foundation

class Item : Decodable{
    var id : String?
    var rank : String?
    var header : String?
    var image : String?
    var weekend : String?
    var gross : String?
    var weeks : String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case rank = "rank"
        case header = "title"
        case image = "image"
        case weekend = "weekend"
        case gross = "gross"
        case weeks = "weeks"
    }
    
    init(id: String?, rank: String?, header: String?, image: String?, weekend: String?, gross: String?, weeks: String?) {
            self.id = id
            self.rank = rank
            self.header = header
            self.image = image
            self.weekend = weekend
            self.gross = gross
            self.weeks = weeks
        }
}

class MyResult : Decodable {
    var items : [Item]
    var errorMessage : String?
}
