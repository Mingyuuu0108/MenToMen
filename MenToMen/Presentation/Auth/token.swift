//
//  token.swift
//  MenToMen
//
//  Created by 이민규 on 2022/10/14.
//

import Foundation
import KeychainAccess

func saveToken(_ token: String, _ key: String) throws {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    try keychain.set(token, key: key)
}

func getToken(_ key: String) throws -> String {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    let token = try? keychain.getString(key) ?? ""
    return token!
}

func removeToken(_ key: String) throws {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    try keychain.remove(key)
}
