//
//  MeasurementsCVCell.swift
//  Health
//
//  Created by Hamza on 08/08/2023.
//

import UIKit

class MeasurementsCVCell: UICollectionViewCell {

    
    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var LaTitle: UILabel!
    
    @IBOutlet weak var ImgMeasurement: UIImageView!
    
    @IBOutlet weak var LaNum: UILabel!
    
    @IBOutlet weak var LaLastNum: UILabel!
    
    @IBOutlet weak var LaDate: UILabel!
    
    @IBOutlet weak var LaWithDate: UILabel!
    @IBOutlet weak var ViewLastNum: UIView!
    @IBOutlet weak var LaLastMes: UILabel!
    @IBOutlet weak var ViewDate: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [LaLastMes,LaWithDate].forEach{ $0.reverselocalizedview()
        }
    }

}
