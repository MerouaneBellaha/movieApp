//
//  MovieDetailsViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 30/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import WebKit

class MovieDetailsViewController: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var releaseYear: UILabel!
    @IBOutlet private var detailsLabel: [UILabel]!
    @IBOutlet private weak var summary: UILabel!
    @IBOutlet private weak var trailerView: WKWebView!

    // MARK: - Properties

    var movieDetails: MovieDetailsModel?

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        setTrailer()
    }

    // MARK: - Methods
    
    private func setDetails() {
        guard let movieDetails = movieDetails else { return }

        movieTitle.text = movieDetails.title
        releaseYear.text = movieDetails.releaseYear
        summary.text = movieDetails.summary

        for (index, label) in detailsLabel.enumerated() {
            label.colorString(text: K.labels[index] + movieDetails.details[index], coloredText: K.labels[index])
            label.font = .italicSystemFont(ofSize: label.font.pointSize)
        }
    }

    private func setTrailer() {
        guard let movieDetails = movieDetails else { return }
        guard let trailerURL = URL(string: K.request.baseYoutube+movieDetails.video) else { return }
        let youtubeRequest = URLRequest(url: trailerURL)
        trailerView.load(youtubeRequest)
    }
}


