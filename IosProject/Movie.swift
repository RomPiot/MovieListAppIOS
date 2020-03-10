//
//  Movie.swift
//  IosProject
//
//  Created by  on 05/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import Foundation

struct Movie : Decodable {
        let id : Int?
        let title : String?
        let image : String?
        let image2 : String?
        let date : String?
        let synopsis : String?
        let time : Int?
        let subTitle : String?
        let genres : [Genre]?
        let video : [String:[MovieVideo]]?
        
        private enum CodingKeys: String, CodingKey {
            case id
            case title = "title"
            case image = "poster_path"
            case image2 = "backdrop_path"
            case date = "release_date"
            case synopsis = "overview"
            case time = "runtime"
            case subTitle = "tagline"
            case genres
            case video = "videos"
        }
    }



