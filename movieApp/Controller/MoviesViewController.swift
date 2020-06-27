//
//  MoviesViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 28/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlet properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var genreLabel: UILabel!

    // MARK: - Properties

    private var networkingRequest = NetworkingRequest()
    var moviesList: [Movie] = []
    var chosenGenre = ""     // passer via un init ?

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        genreLabel.text = chosenGenre
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellName)
    }

    // MARK: - Networking Result management

    private func manageResult(with result: Result<MovieDetailsModel, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let movieDetails):
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.toMovieDetails, sender: movieDetails)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as! MovieCell
        cell.movie = moviesList[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destinationVC = segue.destination as? MovieDetailsViewController, let movieDetails = sender as? MovieDetailsModel {
               destinationVC.movieDetails = movieDetails
           }
       }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieId = String(moviesList[indexPath.row].id)
        networkingRequest.getMovieDetails(request: .details, id: selectedMovieId) {
            self.manageResult(with: $0)
        }
    }
}
