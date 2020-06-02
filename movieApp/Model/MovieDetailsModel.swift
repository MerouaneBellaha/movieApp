//
//  MovieDetailsModel.swift
//  movieApp
//
//  Created by Merouane Bellaha on 02/06/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct MovieDetailsModel {

    private let data: MovieDetails

    init (data: MovieDetails) {
        self.data = data
    }

    var genres: String {
        return data.genres.compactMap { $0.name }.prefix(2).joined(separator: ", ")
    }

    var title: String {
        return data.title.uppercased()
    }

    var summary: String {
        return data.overview
    }

    var releaseYear: String {
        return data.release_date.components(separatedBy: "-").first ?? ""
    }

    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // refactoriser

        if let dateFormat = dateFormatter.date(from: data.release_date) {
            dateFormatter.dateStyle = .long
             return dateFormatter.string(from: dateFormat)
        }
        return ""
    }

    var video: String {
        return data.videos.results.first?.key ?? ""
    }

    var actorNames: String {
        return data.credits.cast.compactMap { $0.name }.prefix(3).joined(separator: ", ")
    }

    var producter: String {
        return data.credits.crew.first(where: { $0.job == "Director" })?.name ?? ""
    }

    var details: [String] {
        return [releaseDate, producter, actorNames, genres, productionCountry]
    }

    var productionCountry: String {
        var count: [String: Int] = [:]
        for company in data.production_companies {
            count[company.origin_country] = count[company.origin_country] == nil ? 1 : count[company.origin_country]! + 1
        }
        let countSorted = count.sorted(by: { $0.value > $1.value })
        let identifier = Locale(identifier: "fr_FR")
        guard let firstCompanyCountry = (countSorted.first?.key) else { return "" }
        return identifier.localizedString(forRegionCode: firstCompanyCountry) ?? ""
    }
}
