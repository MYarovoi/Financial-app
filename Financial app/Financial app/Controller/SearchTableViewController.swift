//
//  ViewController.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 04.02.2025.
//

import UIKit
import Combine
import MBProgressHUD

class SearchViewModel {
    struct Input {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let setupNavigationBar: AnyPublisher<String, Never>
    }
    
    func transform(input: Input) -> Output {
        let setupNavigationBar: AnyPublisher<String, Never> = input.viewDidLoadPublisher.flatMap {
            return Just("Search").eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        
        return .init(setupNavigationBar: setupNavigationBar)
    }
}

class SearchTableViewController: UITableViewController, UIAnimatable {
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let viewModel = SearchViewModel()
    
    private enum Mode {
        case onboarding
        case search
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a company name or symbol"
        searchController.searchBar.autocapitalizationType = .allCharacters
        return searchController
    }()
    
    private let apiService = APIService()
    @Published private var searchQuery = String()
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onboarding
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        observe()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.send()
        setuptableView()
    }
    
    private func observe() {
        let input = SearchViewModel.Input(viewDidLoadPublisher: viewDidLoadSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.setupNavigationBar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.navigationItem.searchController = self?.searchController
                self?.navigationItem.title = title
            }.store(in: &cancellables)
        
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [weak self] searchQuery in
                guard !searchQuery.isEmpty else { return }
                guard let self = self else { return }
                showLoadingAnimation()
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { completion in
                    self.hideLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print("DEBUG: \(error.localizedDescription)")
                    case .finished: break
                    }
                } receiveValue: { searchResults in
                    self.tableView.isScrollEnabled = true
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                }.store(in: &self.cancellables)
            }.store(in: &cancellables)
        
        $mode.sink { [unowned self] mode in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &cancellables)
    }
    
    private func setuptableView() {
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.item]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        apiService.fetchTimeSeriesMonthlyAdjustedPublisher(keywords: symbol).sink { [weak self] completionResult in
            self?.hideLoadingAnimation()
            switch completionResult {
            case .finished: break
            case .failure(let error):
                print("DEBUG: Fetch failed: \(error)")
            }
        } receiveValue: { [weak self] timeSeriesMonthlyAdjusted in
            self?.hideLoadingAnimation()
            let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            self?.searchController.searchBar.text = ""
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
           let destination = segue.destination as? CalculatorTableViewController,
            let asset = sender as? Asset {
            destination.asset = asset
        }
    }
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
}
