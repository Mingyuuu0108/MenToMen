import Foundation

public let decoder: JSONDecoder = JSONDecoder()

struct PostData: Decodable {
    var status: Int
    var message: String
    var data: [PostDatas]
}

struct PostDatas: Decodable {
    var author: Int?
    var content: String?
    var imgUrls: [String]?
    var createDateTime: String?
    var updateDateTime: String?
    var updateStatus: String?
    let postId: Int?
    var profileUrl: String?
    var tag: String?
    var userName: String?
    var stdInfo: InfoDatas
}

struct HomeResponse: Decodable{
    var posts: [PostData]
}
