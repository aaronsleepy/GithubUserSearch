//
//  ViewController.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/03.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedSearchControl()
        
    }
    
    // searchController 구성 및 navigationItem에 추가
    private func embedSearchControl() {
        self.navigationItem.title = "Search"
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "aaronsleepy"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
    }
    
    // collectionView 구성
    
    // bind()
    // - 데이터 -> view
    //   - 검색된 사용자를 CollectionView 업데이트
    // - 사용자 인터랙션 대응
    //   - searchController 검색 -> 네트워크 요청


}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text
        print("search: \(keyword)")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("button clicked: \(searchBar.text)")
    }
}

