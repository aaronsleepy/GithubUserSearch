//
//  SearchResult.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/04.
//

import Foundation

struct SearchResult: Hashable, Identifiable, Decodable {
    var id: Int64
    var login: String
    var avatarUrl: URL
    var htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
