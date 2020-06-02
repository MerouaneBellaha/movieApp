//
//  MovieDetailsViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 30/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet var detailsLabel: [UILabel]!
    @IBOutlet weak var summary: UILabel!


    var movieDetails: MovieDetails?

    @IBOutlet weak var trailerView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setDetails()
        setTrailer()
        
        print(movieDetails)
    }

    private func setDetails() {
        guard let movieDetails = movieDetails else { return }
        movieTitle.text = movieDetails.title.uppercased()
        releaseYear.text = movieDetails.release_date.components(separatedBy: "-").first
        summary.text = movieDetails.overview
    }

    private func setTrailer() {
        guard let movieDetails = movieDetails else { return }
        guard let trailerURL = URL(string: K.request.baseYoutube+movieDetails.videos.results[0].key) else { return }
        let youtubeRequest = URLRequest(url: trailerURL)
        self.trailerView.load(youtubeRequest)
        setDetails()
    }
}


