//
//  MoviesViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 28/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    var moviesList: [Movie] = []
    @IBOutlet weak var genreLabel: UILabel!

    var chosenGenre = ""
    // passer via un init ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreLabel.text = chosenGenre
        tableView.dataSource = self
        // viewWillAppear ?
        tableView.reloadData()

        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellName)
    }
}

extension MoviesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as! MovieCell
        cell.overview.text = moviesList[indexPath.row].overview
        cell.title.text =  moviesList[indexPath.row].title
        

        let imagePath = URL(string: K.request.baseImageUrl+moviesList[indexPath.row].poster_path)!
        // guard let ? if let ?
        do {
            let data = try Data(contentsOf: imagePath)
            cell.posterImage.image = UIImage(data: data)
        } catch {
            //put noImageAvailable image
            cell.posterImage.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)

        }


        return cell
    }
}
