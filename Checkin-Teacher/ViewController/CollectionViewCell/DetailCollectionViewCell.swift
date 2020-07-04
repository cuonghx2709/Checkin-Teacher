//
//  DetailCollectionViewCell.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class DetailCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak private var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupBinding(photo: Photo) {
        imageView.kf.setImage(with: URL(string: photo.url ?? ""))
    }
}
