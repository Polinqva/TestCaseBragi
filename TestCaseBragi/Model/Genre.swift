//
//  Genre.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct GenresResponse: Decodable {
    let genres: [Genre]
}
