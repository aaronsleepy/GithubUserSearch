//
//  SearchUserResponse.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/04.
//

import Foundation

struct SearchUserRespones: Decodable {
    var items: [SearchResult]
}
