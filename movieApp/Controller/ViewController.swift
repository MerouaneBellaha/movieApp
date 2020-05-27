//
//  ViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var browseAndListButtons: [UIButton]!
    @IBOutlet var buttonsHighlighters: [UIView]!

    @IBOutlet weak var tableView: UITableView!

    var test = [UIButton]()

    var genderList: [Genres]? // Correct ?
    var filmGenderRequest = FilmGenderRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        filmGenderRequest.getGenderList { self.manageResult(with: $0) }
    }

    // Nécessaire de mettre private sur IB ?
    @IBAction private func browseTapped(_ sender: UIButton) {
        toggleButtonSelection(sender: sender)
    }

    @IBAction private func myListTapped(_ sender: UIButton) {
        toggleButtonSelection(sender: sender)
    }

    private func toggleButtonSelection(sender: UIButton) {
        sender.isSelected = true
        for button in browseAndListButtons where button != sender {
            button.isSelected = false
        }
        for button in buttonsHighlighters {
            button.backgroundColor == UIColor(named: K.Colors.primary) ? (button.backgroundColor = UIColor(named: K.Colors.secondary)) : (button.backgroundColor = UIColor(named: K.Colors.primary))
        }
    }

    private func manageResult(with result:Result<FilmData, RequestError>) {
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

