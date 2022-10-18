//
//  SignInAPI.swift
//  MenToMen
//
//  Created by 이민규 on 2022/10/14.
//

import Foundation

struct CodeData: Decodable {
    let status: Int
    let message: String
    let data: CodeDatas
}

struct CodeDatas: Decodable {
    let name: String
    let profileImage: String?
    let location: String
}

struct LoginData: Decodable {
    let status: Int
    let message: String
    let data: LoginDatas
}

struct LoginDatas: Decodable {
    let accessToken: String
    let refreshToken: String
}
