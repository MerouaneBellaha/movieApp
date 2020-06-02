//
//  Constants.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct K {
    static let reusableCell = "reusableCell"
    static let detailsCell = "detailsCell"
    static let toMoviesList = "toMoviesList"
    static let toMovieDetails = "toMovieDetails"
    static let noResult = "No result"
    static let nibName = "MovieCell"
    static let cellName = "movieCell"
    
    struct Colors {
        static let primary = "primary"
        static let primaryVariant = "primaryVariant"
        static let secondary = "secondary"
        static let white = "white"
    }

    struct request {
        static let apikey = "?api_key=b1f9eb78195e2b48911a79dee29c0f94"
        static let language = "&language=en-US"
        static let baseURL = "https://api.themoviedb.org/3"
        static let chosenRequest = ["/genre/movie/list", "/discover/movie", "/movie/"]
        static let options = "&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres="
        static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
        static let addVideos = "&append_to_response=videos"
        static let baseYoutube = "https://www.youtube.com/embed/"
    }
}
