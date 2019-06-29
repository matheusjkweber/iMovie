//
//  MovieDetailsViewController.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//
import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    var viewModel: MovieDetailsViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    init(viewModel: MovieDetailsViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.title = self.viewModel?.title
        self.titleLabel.text = self.viewModel?.title
        self.releaseDateLabel.text = self.viewModel?.releaseDate
        self.votesLabel.text = "Votes: \(self.viewModel?.voteAverage ?? "0")"
        self.descriptionLabel.text = self.viewModel?.overview
        
        if let image = self.viewModel?.image {
            self.imageLabel.image = image
        }
    }
}
