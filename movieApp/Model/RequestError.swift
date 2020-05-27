//
//  RequestError.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case incorrectUrl, noData, incorrectResponse, undecodableData

    var description: String {
        switch self {
        case .incorrectUrl:
            return "incorrect URL"
        case .noData:
            return "no data"
        case .incorrectResponse:
            return "incorrect response"
        case .undecodableData:
            return "undecodable data"
        }
    }
}
