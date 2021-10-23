//
//  User.swift
//  ios-Github-Followers-Clone
//
//  Created by sookim on 2021/10/24.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createAt: String
}
