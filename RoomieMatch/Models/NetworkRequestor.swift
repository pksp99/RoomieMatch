//
//  NetworkRequestor.swift
//  RoomieMatch
//
//  Created by Preet Karia on 5/1/23.
//

import Foundation
import UIKit


// This class is used to download JSON from given url and Image from the url
class NetworkRequester {
    static let shared = NetworkRequester()
    let imageCache = NSCache<NSString, AnyObject>()
    private init(){}
    
    
    
    //TODO need to implement postcall.
    
    
    //this method downloads JSON decodes it specific type
    func downloadJson<T>(url urlString: String, type: T.Type, completed: @escaping (T) -> ())  where T : Decodable {
        print("Downloading JSON from: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, err) in
            
            guard let jsonData = data else {
                print("Error downloading JSON")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type, from: jsonData)
                DispatchQueue.main.async {
                    completed(result)
                }
            } catch {
                print("Error Decoding JSON")
                print("\(error)")
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
