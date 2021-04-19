//
//  AlbumCell.swift
//  Swifterviewing
//
//  Created by Ravi Kumar Yaganti on 25/07/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    
    var albumListCellViewModel : AlbumListCellViewModel? {
        didSet {
            albumTitle.text = albumListCellViewModel?.title
            albumImageView.loadImage(fromURL: albumListCellViewModel?.imageUrl ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
