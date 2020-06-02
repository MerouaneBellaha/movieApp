//
//  filmData.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct GenresList: Decodable {
    var genres: [Genre]
}

struct Genre: Decodable {
    var name: String
    var id: Int
}

struct MoviesList: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var poster_path: String
    var id: Int
    var title: String
    var overview: String
}

struct MovieDetails: Decodable {
    var genres: [Genre]
    var title: String
    var overview: String
    var release_date: String
    var videos: Results
}

struct Results: Decodable {
    var results: [VideoResult]
}

struct VideoResult: Decodable {
    var key: String
}
