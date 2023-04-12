//
//  NetworkService.swift
//  QR_Scanner
//
//  Created by Sergio on 12.04.23.
//

import Foundation

final class NetworkService {

    static let shared = NetworkService()

    func getDataFromUrl(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }
}
