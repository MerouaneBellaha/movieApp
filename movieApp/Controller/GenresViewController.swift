//
//  ViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {

    @IBOutlet var browseAndListButtons: [UIButton]!
    @IBOutlet var buttonsHighlighters: [UIView]!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var genresList: [Genre] = [] { didSet { self.tableView.reloadData() }}
    private var filmGenreRequest = FilmGenreRequest()
    private var searchedGenreList: [Genre] = [] { didSet { self.tableView.reloadData() }}

    private var chosenGenre = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filmGenreRequest.getGenreList(request: .genres) { self.manageResult(with: $0) }
        searchBar.searchTextField.textColor = .white
    }

    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.25) {
            self.searchBar.isHidden.toggle()
        }
        let newButton = UIBarButtonItem(barButtonSystemItem: searchBar.isHidden ? .search : .stop, target: self, action: #selector(searchTapped(_:)))
        self.navigationItem.setRightBarButton(newButton, animated: false)

        searchedGenreList.removeAll()
        searchBar.text?.removeAll()
        tableView.reloadData()
    }

    @IBAction private func browseAndListButtonsTapped(_ sender: UIButton) {
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

    private func manageResult(with result: Result<GenresList, RequestError>) {
        switch result {
        case .failure(let error):
            print(error.description)
        case .success(let filmData):
            DispatchQueue.main.async {
                self.genresList = filmData.genres
            }
        }
    }

    private func manageResult(with result: Result<MoviesList, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let moviesList):
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.toMoviesList, sender: moviesList.results)
            }
        }
    }
}

extension GenresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchedGenreList.isEmpty else {
            return searchedGenreList.count
        }
        return genresList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: K.Colors.primaryVariant)
        cell.selectedBackgroundView = backgroundView

        guard searchedGenreList.isEmpty else {
            cell.textLabel?.text = searchedGenreList[indexPath.row].name
            cell.selectionStyle = cell.textLabel?.text == K.noResult ? .none : .default
            return cell
        }

        cell.textLabel?.text = genresList[indexPath.row].name

        return cell
    }
}

extension GenresViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !(searchedGenreList.first?.name == K.noResult) else {
            return
        }
        var currentList: [Genre] { searchedGenreList.isEmpty ? genresList : searchedGenreList }
        let selectedGenreId = String(currentList[indexPath.row].id)
        filmGenreRequest.getMoviesListByGenre(request: .movies, id: selectedGenreId) { self.manageResult(with: $0) }
        chosenGenre = currentList[indexPath.row].name
        print(chosenGenre)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MoviesViewController, let moviesList = sender as? [Movie] {
            destinationVC.moviesList = moviesList
            destinationVC.chosenGenre = chosenGenre
            
        }
    }
}

extension GenresViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGenreList = (genresList.filter { $0.name.prefix(searchText.count) == searchText })
        // refactoriser
        if searchedGenreList.isEmpty {
            searchedGenreList.append(Genre(name: K.noResult, id: 0))
        }
    }
}

// present secondVC en passant la category pour effectuer l appel réseau sur second vc
// pop up erreur cette catégorie n 'existe pas ( appuie sur return mais le nom de la category n'est pas ocmplète)?

