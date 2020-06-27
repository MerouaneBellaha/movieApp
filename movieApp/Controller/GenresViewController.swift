//
//  ViewController.swift
//  movieApp
//
//  Created by Merouane Bellaha on 27/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet private var browseAndListButtons: [UIButton]!
    @IBOutlet private var buttonsHighlighters: [UIView]!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let defaults = UserDefaults.standard
    private var networkingRequest = NetworkingRequest()
    private var chosenGenre = ""
    private var requestedGenreLists: [Genre] = [] { didSet { tableView.reloadData() }}
    private var genresList: [Genre] { browseAndListButtons.first?.isSelected == true ? requestedGenreLists : myList }
    private var searchedGenreList: [Genre] = [] { didSet { self.tableView.reloadData() }}
    private var currentList: [Genre] { searchedGenreList.isEmpty ? genresList : searchedGenreList }
    private var myDefaultsList: [Int: String] = [:] { didSet {
        guard myList.isEmpty  else { return }
        for (_, value) in myDefaultsList.enumerated() {
            myList.append(Genre(name: value.value, id: value.key))
        }
    }}
    private var myList: [Genre] = [] { didSet {
        myList.sort { $0.name < $1.name }
        tableView.reloadData() }
    }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        networkingRequest.getGenreList(request: .genres) { self.manageResult(with: $0) }

        if let outData = UserDefaults.standard.data(forKey: "myList") {
            guard let dataFormatted = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self], from: outData) as? [Int: String] ?? [:] else { return }
            myDefaultsList = dataFormatted
        }
    }

    // MARK: - IBAction methods

    @IBAction private func searchTapped(_ sender: UIBarButtonItem) {
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

    // MARK: - Methods

    private func toggleButtonSelection(sender: UIButton) {
        sender.isSelected = true
        browseAndListButtons.first(where: { $0 != sender } )?.isSelected = false

        let backgroundColor = [UIColor(named: K.Colors.secondary), UIColor(named: K.Colors.primary)]

        var rightBackgroundColor: [UIColor?] {
            sender.tag == 0 ? backgroundColor : backgroundColor.reversed()
        }
        buttonsHighlighters.enumerated().forEach { $0.element.backgroundColor = rightBackgroundColor[$0.offset] }

        tableView.reloadData()

    }

    // MARK: - Networking Result management

    private func manageResult(with result: Result<GenresList, RequestError>) {
        switch result {
        case .failure(let error):
            print(error.description)
        case .success(let filmData):
            DispatchQueue.main.async {
                //                self.genresList = filmData.genres
                self.requestedGenreLists = filmData.genres
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MoviesViewController, let moviesList = sender as? [Movie] {
            destinationVC.moviesList = moviesList
            destinationVC.chosenGenre = chosenGenre
        }
    }
}

// MARK: - UITableViewDataSource

extension GenresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // BUG with searchbar
        guard searchedGenreList.isEmpty || searchedGenreList.first?.name == K.noResult else {
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

// MARK: - UITableViewDelegate

extension GenresViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !(searchedGenreList.first?.name == K.noResult) else {
            return
        }
        let selectedGenreId = String(currentList[indexPath.row].id)
        networkingRequest.getMoviesListByGenre(request: .movies, id: selectedGenreId) { self.manageResult(with: $0) }
        chosenGenre = currentList[indexPath.row].name
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard browseAndListButtons.first?.isSelected == true else { return nil }

        let doneAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            if self.myDefaultsList.contains(where: { $0.value == self.currentList[indexPath.row].name }) {
                self.setAlertVc(with: "Cette catégorie est déjà dans votre Liste")
            } else {


                self.myDefaultsList[self.currentList[indexPath.row].id] = self.currentList[indexPath.row].name
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self.myDefaultsList, requiringSecureCoding: false) else { return }
                UserDefaults.standard.set(data, forKey: "myList")
                self.myList.append(Genre(name: self.currentList[indexPath.row].name, id: self.currentList[indexPath.row].id))
            }
            completionHandler(true)
        }
        doneAction.title = "add"
        doneAction.backgroundColor = UIColor(named: K.Colors.secondary)

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}

// MARK: - UISearchBarDelegate

extension GenresViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGenreList = (genresList.filter { $0.name.prefix(searchText.count) == searchText })
        // refactoriser BUG ?
        if searchedGenreList.isEmpty {
            searchedGenreList.append(Genre(name: K.noResult, id: 0))
        }

        tableView.reloadData()
    }
}

