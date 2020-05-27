//
//  filmData.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct FilmData: Decodable {
    var genres: [Genres]
}

struct Genres: Decodable {
    var name: String
}
