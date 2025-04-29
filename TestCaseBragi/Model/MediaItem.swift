//
//  MediaItem.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 29.04.2025.
//

struct MediaItem: Decodable {
    let id: Int
    let title: String?      
    let name: String?
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
struct MediaDetail: Decodable {
    let budget: Int?
    let revenue: Int?
    let lastAirDate: String?
    let lastEpisodeToAir: LastEpisode?
    
    enum CodingKeys: String, CodingKey {
        case budget
        case revenue
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
    }
}

struct LastEpisode: Decodable {
    let name: String
}

struct ItemsResponse: Decodable {
    let page: Int
    let results: [MediaItem]
}
