//
//  MovieCell.swift
//  movieApp
//
//  Created by Merouane Bellaha on 28/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!

    var movie: Movie? {
        didSet {
            title.text = movie?.title
            overview.text = movie?.overview
            guard let data = movie?.poster_path.data else {
                posterImage.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                return
            }
            posterImage.image = UIImage(data: data)
        }
    }
}
