//
//  fimGenderRequest.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class FilmGenreRequest {

    private let apiKey = "api_key=b1f9eb78195e2b48911a79dee29c0f94"
    private let language = "&language=en-US"
    private let baseURL = "https://api.themoviedb.org/3"
    private let chosenRequest = ["/genre/movie/list?", "/discover/movie?"]
    private let options = "&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres="

    private let session: URLSession
    private var task: URLSessionDataTask?


    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getGenreList(request: RequestType, callBack: @escaping (Result<GenresList, RequestError>) -> ()) {

        guard let request = URL(string: baseURL+chosenRequest[request.value]+apiKey+language) else {
            callBack(.failure(.incorrectUrl))
            return
        }


        task?.cancel()

        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callBack(.failure(.noData))
                return
            }

            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    callBack(.failure(.incorrectResponse))
                    return
            }

            guard let responseJson = try? JSONDecoder().decode(GenresList.self, from: data) else {
                callBack(.failure(.noData))
                return
            }
            callBack(.success(responseJson))
        }
        task?.resume()
    }

    func getMoviesListByGenre(request: RequestType, id: String, callBack: @escaping (Result<MoviesList, RequestError>) -> ()) {

        guard let request = URL(string: baseURL+chosenRequest[request.value]+apiKey+language+options+id) else {
            callBack(.failure(.incorrectUrl))
            return
        }


        task?.cancel()

        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callBack(.failure(.noData))
                return
            }

            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    callBack(.failure(.incorrectResponse))
                    return
            }

            guard let responseJson = try? JSONDecoder().decode(MoviesList.self, from: data) else {
                callBack(.failure(.noData))
                return
            }
            callBack(.success(responseJson))
        }
        task?.resume()
    }
}
