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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var genderList: [Genres] = [] { didSet { self.tableView.reloadData() }}
    var filmGenderRequest = FilmGenderRequest()
    var searchedGenderList: [Genres] = [] { didSet { self.tableView.reloadData() }}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        filmGenderRequest.getGenderList { self.manageResult(with: $0) }
        searchBar.searchTextField.textColor = .white
    }

    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.25) {
            self.searchBar.isHidden.toggle()
        }
        let newButton = UIBarButtonItem(barButtonSystemItem: searchBar.isHidden ? .search : .stop, target: self, action: #selector(searchTapped(_:)))
        self.navigationItem.setRightBarButton(newButton, animated: false)

        searchedGenderList.removeAll()
        searchBar.text?.removeAll()
        tableView.reloadData()
    }

    @IBAction private func genderAndListButtons(_ sender: UIButton) {
        toggleButtonSelection(sender: sender)
    }

    private func toggleButtonSelection(sender: UIButton) {
        sender.isSelected = true
        browseAndListButtons.first(where: { $0 != sender } )?.isSelected = false

        let backgroundColor = [UIColor(named: K.Colors.secondary), UIColor(named: K.Colors.primary)]

        var rightBackgroundColor: [UIColor?] {
            sender.tag == 0 ? backgroundColor : backgroundColor.reversed()
        }
        buttonsHighlighters.enumerated().forEach { $0.element.backgroundColor = rightBackgroundColor[$0.offset] }
    }

    private func manageResult(with result:Result<FilmData, RequestError>) {
        switch result {
        case .failure(let error):
            print(error.description)
        case .success(let filmData):
            DispatchQueue.main.async {
                self.genderList = filmData.genres
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchedGenderList.isEmpty else {
            return searchedGenderList.count
        }
        return genderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: K.Colors.primaryVariant)
        cell.selectedBackgroundView = backgroundView
        guard searchedGenderList.isEmpty else {
            cell.textLabel?.text = searchedGenderList[indexPath.row].name
            return cell
        }
        cell.textLabel?.text = genderList[indexPath.row].name
        return cell
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGenderList = (genderList.filter { $0.name.prefix(searchText.count) == searchText })
        // refactoriser
        if searchedGenderList.isEmpty {
            searchedGenderList.append(Genres(name: "no result"))
        }

    }
}

// present secondVC en passant la category pour effectuer l appel réseau sur second vc
// pop up erreur cette catégorie n 'existe pas ( appuie sur return mais le nom de la category n'est pas ocmplète)?
