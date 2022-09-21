import Foundation
import Alamofire

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}

struct Film: Decodable {
  let id: Int
  let title: String
  let openingCrawl: String
  let director: String
  let producer: String
  let releaseDate: String
  let starships: [String]

  enum CodingKeys: String, CodingKey {
    case id = "episode_id"
    case title
    case openingCrawl = "opening_crawl"
    case director
    case producer
    case releaseDate = "release_date"
    case starships
  }
}

extension Film {
  var titleLabelText: String {
    title
  }

  var subtitleLabelText: String {
    "Episode \(String(id))"
  }

  var item1: (label: String, value: String) {
    ("DIRECTOR", director)
  }

  var item2: (label: String, value: String) {
    ("PRODUCER", producer)
  }

  var item3: (label: String, value: String) {
    ("RELEASE DATE", releaseDate)
  }

  var listTitle: String {
    "STARSHIPS"
  }

  var listItems: [String] {
    starships
  }
}
struct Films: Decodable {
  let count: Int
  let all: [Film]

  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
