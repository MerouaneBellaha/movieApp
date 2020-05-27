//
//  fimGenderRequest.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class FilmGenderRequest {

    private let apiKey = "api_key=b1f9eb78195e2b48911a79dee29c0f94"
    private let language = "&language=en-US"
    private let baseURL = "https://api.themoviedb.org/3/genre/movie/list?"

    private let session: URLSession
    private var task: URLSessionDataTask?


    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getGenderList(callBack: @escaping (Result<FilmData, requestError>) -> ()) {

        guard let request = URL(string: baseURL+apiKey+language) else {
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

            guard let responseJson = try? JSONDecoder().decode(FilmData.self, from: data) else {
                callBack(.failure(.noData))
                return
            }
            callBack(.success(responseJson))
        }
        task?.resume()
    }

    enum requestError: Error {
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
}
