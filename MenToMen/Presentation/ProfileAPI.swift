//
//  ProfileAPI.swift
//  MenToMen
//
//  Created by 이민규 on 2022/10/13.
//

import Foundation

struct ProfileData: Decodable {
    let data: ProfileDatas
    let status: Int
    let message: String
}

struct ProfileDatas: Decodable {
    let name: String
    let email: String
    let profileImage: String?
    let stdInfo: InfoDatas
    let userId: Int
}

struct InfoDatas: Decodable {
    var grade: Int!
    var room: Int!
    var number: Int!
}
