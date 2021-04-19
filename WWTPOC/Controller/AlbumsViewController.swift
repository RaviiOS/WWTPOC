//
//  ViewController.swift
//  Swifterviewing
//
//  Created by Tyler Thompson on 7/9/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Properties
    lazy var viewModel: AlbumsListViewModel = {
        return AlbumsListViewModel()
    }()
    
    var albums:[Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init
        initView()
        initVM()
    }
}

//MARK:- Custom methods
extension AlbumsViewController {
    private func initView() {
        self.navigationItem.title = Constants.ALBUMS_LIST_TITLE
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: AlbumCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AlbumCell.self))
    }
    
    private func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
        
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: Constants.ALERT_TITLE, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: Constants.OK, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- TableView DataSource
extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlbumCell.self), for: indexPath) as? AlbumCell else {
            fatalError("Cell not exists in storyboard")
        }
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.albumListCellViewModel = cellVM
        return cell
    }
}

//MARK:- TableView Delegate
extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tapOnAlbume(at: indexPath)
    }
}

