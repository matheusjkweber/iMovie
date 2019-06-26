//
//  ListMoviesCollectionViewCell.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

class ListMoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ListMoviesCollectionViewCell {
    func setup(title: String) {
       movieTitleLabel.text = title
        
        setLayout()
    }
    
    fileprivate func setLayout() {
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 40
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
}
