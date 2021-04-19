//
//  API.swift
//  Swifterviewing
//
//  Created by Tyler Thompson on 7/9/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import Foundation


enum AlbumError: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

protocol AlbumsServiceProtocol {
    func getAlbums(completionHandler: @escaping (Result<[Album]?, AlbumError>) -> ())
}


class API: NSObject {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    static let sharedInstance = API(session: URLSession.shared)
    
    // MARK: - Accessors
    class func shared() -> API {
        return sharedInstance
    }
    
    typealias completeClosure = ( _ data: Data?,_ response: URLResponse?, _ error: Error?)->Void
    let baseURL = "https://jsonplaceholder.typicode.com/"
    let photosEndpoint = "photos" //returns photos and their album ID
    let albumsEndpoint = "albums" //returns an album, but without photos
    
    func get( url: URL, callback: @escaping completeClosure ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, response, error)
        }
        task.resume()
    }
    
}

