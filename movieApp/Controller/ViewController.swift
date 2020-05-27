//
//  ViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myListButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

//    var fakeList = ["film1", "film2"]
    var genderList: [Genres]?
    var filmGenderRequest = FilmGenderRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        filmGenderRequest.getGenderList { result in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let filmData):
                self.genderList = filmData.genres
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func browseTapped(_ sender: Any) {
        toggleButtonSelection()
    }

    @IBAction func myListTapped(_ sender: Any) {
        toggleButtonSelection()
    }

    func toggleButtonSelection() {
        if myListButton.isSelected == true {
            myListButton.isSelected = false
            browseButton.isSelected = true
        } else {
            myListButton.isSelected = true
            browseButton.isSelected = false
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let genderList = genderList else { return 0 }
        return genderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: K.Colors.primaryVariant)
        cell.selectedBackgroundView = backgroundView
        guard let genderList = genderList else { return cell }
        cell.textLabel?.text = genderList[indexPath.row].name
        return cell
    }
}

//extension ViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let currentCell = tableView.cellForRow(at: indexPath) else { return }
//        currentCell.backgroundColor = UIColor(named: K.Colors.primaryVariant)
//    }
//}

