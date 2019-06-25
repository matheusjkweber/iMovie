//
//  FilterView.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

class FilterView: UIView, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var filterValue: FilterValue = .none
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.clipsToBounds = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        makeCornerRadius()
    }
    
    func makeCornerRadius() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    @IBAction func didClickApplyButton(_ sender: Any) {
        
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
            return FilterValue.movies.rawValue
        case 1:
            return FilterValue.tvShows.rawValue
        default:
            return FilterValue.none.rawValue
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
