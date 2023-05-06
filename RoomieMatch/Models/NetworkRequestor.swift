//
//  NetworkRequestor.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/1/23.
//

import Foundation
import UIKit
import Firebase


// This class is used to download JSON from given url, make a post call and Image from the url
class NetworkRequester {
    static let shared = NetworkRequester()
    let imageCache = NSCache<NSString, AnyObject>()
    var userId = Auth.auth().currentUser?.uid
    private init(){}
    
    
    //this is a postRequest to post requestBody 
    func postRequest<T: Encodable, U: Decodable>(url urlString: String, parameters: [String: Any]?, requestBody: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(userId, forHTTPHeaderField: "x-userId")
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(requestBody)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "edu.syr.RoomieMatch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(U.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    //this is a getRequest to download JSON and decode it specific type
    func postRequestWithNoBody<T: Decodable>(url urlString: String, parameters: [String: Any]? = nil, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }
        var request = URLRequest(url: urlComponents.url!)
        
        request.setValue(userId, forHTTPHeaderField: "x-userId")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "edu.syr.RoomieMatch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    
    //this is a getRequest to download JSON and decode it specific type
    func getRequest<T: Decodable>(url urlString: String, parameters: [String: Any]? = nil, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }
        var request = URLRequest(url: urlComponents.url!)
        
        request.setValue(userId, forHTTPHeaderField: "x-userId")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "edu.syr.RoomieMatch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    //this method is used to download Image from the URL. It also implements caching.
    func downloadImage(url urlString: String, completed: @escaping (UIImage) -> ()) {
        if let cachedImage = self.imageCache.object(forKey: urlString as NSString) as? UIImage{
            print("Returning cached Image for: \(urlString)")
            completed(cachedImage)
            return
        }
        print("Downloading Image from: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                print("Error downloading Image")
                print(err ?? "")
                return
            }
            guard let image = UIImage(data: data) else {
                print("Unable to create UIImage from the data")
                return
            }
            self.imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completed(image)
            }
        }.resume()
    }
}
