//
//  SearchViewModel.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/05.
//

import Foundation
import Combine

final class SearchViewModel {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    // Data => Output
    @Published private(set) var users: [SearchResult] = []
    
    // User Action => Input
    func search(keyword: String) {
        let resource = Resource<SearchUserResponse>(
            base: "https://api.github.com/",
            path: "search/users",
            params: ["q": keyword],
            header: ["Content-type": "application/json"])

        networkService.load(resource)
            .receive(on: RunLoop.main)
            .print("[Debug]")
            .sink { completion in
                print("Completion: \(completion)")

                switch completion {
                case .failure(let error):
                    self.users = []
                case .finished: break
                }
            } receiveValue: { response in
                self.users = response.items
            }.store(in: &subscriptions)
    }
}
