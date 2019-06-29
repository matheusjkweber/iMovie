//
//  ErrorView.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func didClickTryAgainButton()
}

class ErrorView: UIView {
    var buttonAction: ButtonAction?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    weak var delegate: ErrorViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        self.buttonAction = nil
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonAction = nil
        super.init(coder: aDecoder)
    }
    
    func setup(errorMessage: String, buttonAction: ButtonAction? = {}) {
        self.messageLabel.text = errorMessage
        self.buttonAction = buttonAction
    }
    
    @IBAction func didClickTryAgainButton(_ sender: Any) {
        self.buttonAction?()
    }
}
