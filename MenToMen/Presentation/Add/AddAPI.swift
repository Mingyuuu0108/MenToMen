//
//  AddAPI.swift
//  MenToMen
//
//  Created by 이민규 on 2022/10/14.
//

import Foundation

struct ImageData: Decodable {
    let status: Int
    let message: String
    let data: [ImageDatas]
}

struct ImageDatas: Decodable {
    let imgUrl: String
}
