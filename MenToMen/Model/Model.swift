//
//  post.swift
//  MenToMen
//
//  Created by 이민규 on 2022/10/04.
//

import Foundation

struct Posts: Codable {
    var author: String?
    var content: String?
    var createDateTime: Date?
    var imgUrl: String?
    var postId: Int?
    var profileUrl: String?
//    var stdInFo: Student
    var tag: String?
    var updateDateTime: Date?
    var updateStatus: String?
    var userName: String?
}

struct Student {
    var grade: Int?
    var number: Int?
    var room: Int?
}

struct HomeResponse: Codable{
    var posts: [Posts]
}
