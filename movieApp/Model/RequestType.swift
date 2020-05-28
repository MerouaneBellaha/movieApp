//
//  RequestType.swift
//  movieApp
//
//  Created by Merouane Bellaha on 28/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

enum RequestType {
    case genres, movies, details
    var value: Int {
        switch self {
        case .genres:
            return 0
        case .movies:
            return 1
        case .details:
            return 2
        }
    }
}
