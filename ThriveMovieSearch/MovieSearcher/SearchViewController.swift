import UIKit

class SearchViewController: UITableViewController {
    
    private var movies = [Movie]()
    
    private var searchController: UISearchController
    private var searchLogic: SearchLogic
    
    init(searchController: UISearchController, searchLogic: SearchLogic) {
        self.searchController = searchController
        self.searchLogic = searchLogic
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSearchController()
        setupTableView()
    }
    
    func setupNavBar() {
        navigationItem.title = "🎬 Movie Searcher 🍿"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupTableView() {
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.rowHeight = 120
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseId)
    }
}

// UITableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseId, for: indexPath) as? MovieCell
        if movies.count <= indexPath.row {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell?.setupView(movie: movie)
        return cell ?? UITableViewCell()
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        
        searchLogic.getResults(forQuery: searchString, onCompletion: { [weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
}
