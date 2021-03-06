//
//  fimGenderRequest.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class NetworkingRequest {

    // MARK: - Properties

    private let session: URLSession
    private var task: URLSessionDataTask?

    // MARK: - Init

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - Networking for GenresViewController

    func getGenreList(request: RequestType, callBack: @escaping (Result<GenresList, RequestError>) -> ()) {

        guard let request = URL(string: K.request.baseURL+K.request.chosenRequest[request.value]+K.request.apikey+K.request.language) else {
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

        // MARK: - Networking for MoviesViewConroller

    func getMoviesListByGenre(request: RequestType, id: String, callBack: @escaping (Result<MoviesList, RequestError>) -> ()) {

        guard let request = URL(string: K.request.baseURL+K.request.chosenRequest[request.value]+K.request.apikey+K.request.language+K.request.options+id) else {
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

        // MARK: - Networking for MovieDetailsViewController

    func getMovieDetails(request: RequestType, id: String, callBack: @escaping (Result<MovieDetailsModel, RequestError>) -> ()) {

        guard let request = URL(string: K.request.baseURL+K.request.chosenRequest[request.value]+id+K.request.apikey+K.request.language+K.request.addVideos) else {

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

            guard let responseJson = try? JSONDecoder().decode(MovieDetails.self, from: data) else {
                callBack(.failure(.undecodableData))
                return
            }
            callBack(.success(MovieDetailsModel(data: responseJson)))
        }
        task?.resume()
    }
}
