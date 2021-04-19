//
//  AlbumsListViewModel.swift
//  Swifterviewing
//
//  Created by Ravi Kumar Yaganti on 25/07/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import Foundation
class AlbumsListViewModel {
    //MARK:- Properties
    let apiService: AlbumsServiceProtocol
    private var albums: [Album] = [Album]()
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var isAllowSegue: Bool = false
    var selectedAlbum: AlbumError?
    
    //MARK:- Property Observables
    private var cellViewModels: [AlbumListCellViewModel] = [AlbumListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    
    //MARK:- Init
    init( apiService: AlbumsServiceProtocol = AlbumService(session: URLSession.shared)) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.getAlbums() {[weak self] (result) in
            self?.isLoading = false
            switch result {
            case .success(let albums):
                print(albums?.first?.title ?? "")
                guard let albums = albums else{
                    self?.alertMessage = Constants.NO_ALBUMS
                    return
                }
                self?.processFetchedAlbum(albums: albums)
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    //MARK:- Custom Methods
    func getCellViewModel( at indexPath: IndexPath ) -> AlbumListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( album: Album ) -> AlbumListCellViewModel {
        
        return AlbumListCellViewModel(title: album.title?.remoceCharacter(), imageUrl: album.thumbnailUrl)
    }
    
    private func processFetchedAlbum( albums: [Album] ) {
        self.albums = albums // Cache
        var vmc = [AlbumListCellViewModel]()
        for photo in albums {
            vmc.append( createCellViewModel(album: photo) )
        }
        self.cellViewModels = vmc
    }
    
}

//MARK:- Albums List User actions
extension AlbumsListViewModel {
    func tapOnAlbume( at indexPath: IndexPath ){
        // let selectedAlbum = self.albums[indexPath.row]
    }
}

//MARK:- Cell ViewModel
struct AlbumListCellViewModel {
    let title: String?
    let imageUrl: String?
}
