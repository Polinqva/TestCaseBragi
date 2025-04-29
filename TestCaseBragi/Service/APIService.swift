//
//  APIService.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

import Foundation
import RxSwift

enum MediaType {
    case movie
    case tv
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    private let session = URLSession.shared
    // MARK: - Fetch Genres
    func fetchGenres(for type: MediaType) -> Observable<[Genre]> {
        let urlString: String
        switch type {
        case .movie:
            urlString = "\(Constants.baseURL)/genre/movie/list?api_key=\(Constants.apiKey)"
        case .tv:
            urlString = "\(Constants.baseURL)/genre/tv/list?api_key=\(Constants.apiKey)"
        }
        
        return request(urlString: urlString, type: GenresResponse.self)
            .map { $0.genres }
    }
    
    // MARK: - Fetch Movies/TV Shows by Genre
    func fetchItems(for type: MediaType, genreId: Int, page: Int) -> Observable<[MediaItem]> {
        let urlString: String
        switch type {
        case .movie:
            urlString = "\(Constants.baseURL)/discover/movie?api_key=\(Constants.apiKey)&with_genres=\(genreId)&page=\(page)"
        case .tv:
            urlString = "\(Constants.baseURL)/discover/tv?api_key=\(Constants.apiKey)&with_genres=\(genreId)&page=\(page)"
        }
        
        return request(urlString: urlString, type: ItemsResponse.self)
            .map { $0.results }
    }
    
    // MARK: - Fetch Details
    func fetchDetails(for type: MediaType, id: Int) -> Observable<MediaDetail> {
        let urlString: String
        switch type {
        case .movie:
            urlString = "\(Constants.baseURL)/movie/\(id)?api_key=\(Constants.apiKey)"
        case .tv:
            urlString = "\(Constants.baseURL)/tv/\(id)?api_key=\(Constants.apiKey)"
        }
        
        return request(urlString: urlString, type: MediaDetail.self)
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(urlString: String, type: T.Type) -> Observable<T> {
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.invalidURL)
        }
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIError.requestFailed)
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedObject)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.decodingFailed)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
