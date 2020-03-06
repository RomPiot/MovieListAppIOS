//
//  MovieResponse.swift
//  IosProject
//
//  Created by  on 05/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import Foundation

struct MovieResponse : Decodable {
    let page : Int?
    let totalResult : Int?
    let movieList : [Movie]
        private enum CodingKeys: String, CodingKey {
            case page
            case totalResult = "total_results"
            case movieList = "results"
        }
    }



