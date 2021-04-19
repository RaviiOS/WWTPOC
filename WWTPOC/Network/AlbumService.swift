//
//  AlbumService.swift
//  Swifterviewing
//
//  Created by Ravi Kumar Yaganti on 25/07/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import Foundation
class AlbumService: API, AlbumsServiceProtocol {
    
    func getAlbums(completionHandler: @escaping (Result<[Album]?, AlbumError>) -> ()) {
        let url = baseURL + photosEndpoint
        get(url: URL(string: url)!) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                guard let data = data else {
                    completionHandler(.failure(.parser(string: "Data not found")))
                    return
                }
                let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let albums = try decoder.decode([Album].self, from: modifiedDataInUTF8Format)
                    DispatchQueue.main.async {
                        completionHandler(.success(albums))
                    }
                } catch let error{
                    completionHandler(.failure(.parser(string: error.localizedDescription)))
                }
            }else{
                completionHandler(.failure(.custom(string: error?.localizedDescription ?? "")))
            }
        }
    }
}
