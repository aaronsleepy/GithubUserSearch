//
//  ViewController.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/03.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = SearchResult
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    @Published private(set) var users: [SearchResult] = []
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedSearchControl()
        configureCollectionView()
        bind()
        
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
    private func configureCollectionView() {
        // Presentation
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return nil }
            
            cell.configure(item.login)
            
            return cell
        })
        
        // Layout
        collectionView.collectionViewLayout = layout()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    // bind()
    // - 데이터 -> view
    //   - 검색된 사용자를 CollectionView 업데이트
    // - 사용자 인터랙션 대응
    //   - searchController 검색 -> 네트워크 요청
    private func bind() {
        $users
            .receive(on: RunLoop.main)
            .sink { users in
                self.applySectionItems(users)
            }.store(in: &subscriptions)
    }
    
    private func applySectionItems(_ items: [Item], to section: Section = .main) {
        // data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot)
    }
    
    /**
    private func bind() {
        // input: 사용자 입력을 받아서 처리해야할 것
        // - item 선택 되었을 때 처리
        didSelect
            .receive(on: RunLoop.main)
            .sink { item in
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "FrameworkDetailViewController") as! FrameworkDetailViewController
         
                viewController.framework.send(item)
    
            self.present(viewController, animated: true)
        }.store(in: &subscriptions)
        
        // output: data, state 변경에 따라서 UI 업데이트할 것
        // - items(frameworks)가 설정되었을 때 view를 업데이트
        frameworks
            .receive(on: RunLoop.main)
            .sink { list in
            self.applySectionItems(list)
        }.store(in: &subscriptions)
    }
    

     */

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

