//
//  Struct.swift
//  MovieGallery
//
//  Created by andrew on 2022/12/18.
//

import Foundation
struct Movie: Codable {
    
    var id: Int!
    var vote_count:Int!
    var vote_average: Double
    var title: String
    var poster_path: String?
    var overview: String
    var release_date: String
}
struct APIResults:Codable {
    
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

