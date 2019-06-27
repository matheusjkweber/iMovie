//
//  FilterView.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

protocol FilterViewDelegate: class {
    func didSelectFilter(filterValue: MediaType)
}

class FilterView: UIView, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var filterValue: MediaType = .none
    weak var delegate: FilterViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        makeCornerRadius()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setup() {
        self.clipsToBounds = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeCornerRadius() {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 15, height:  15))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
    
    @IBAction func didClickApplyButton(_ sender: Any) {
        self.delegate?.didSelectFilter(filterValue: filterValue)
    }
}

//MARK: Picker delegate and datasource methods
extension FilterView {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(row){
        case 0:
            return MediaType.movies.rawValue
        case 1:
            return MediaType.tvShows.rawValue
        default:
            return MediaType.none.rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(row){
        case 0:
            self.filterValue = .movies
            break
        case 1:
            self.filterValue = .tvShows
            break
        default:
            self.filterValue = .none
        }
    }
}
