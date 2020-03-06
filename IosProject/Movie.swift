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
//        let popularity : String?
//        let genre : [Genre]
        
        private enum CodingKeys: String, CodingKey {
            case id
            case title = "original_title"
            case image = "poster_path"
            case image2 = "backdrop_path"
            case date = "release_date"
            case synopsis = "overview"
//            case genre = "genre_ids"
        }
    
//    init(title: String, image: String, synopsis: String, date: String, image2: String) {
//        self.id = 1
//        self.title = title
//        self.image = image
//        self.synopsis = synopsis
//        self.image2 = image2
//        self.date = date
//    }
    }


public struct Genre : Decodable {
    // https://api.themoviedb.org/3/genre/movie/list?api_key=c6a59dc98134d1b3f4087bc55464ff10&language=fr
    let id : Int
    let name : String
}
