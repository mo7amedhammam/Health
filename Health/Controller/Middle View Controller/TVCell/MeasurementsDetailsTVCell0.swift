//
//  MeasurementsDetailsTVCell0.swift
//  Health
//
//  Created by Hamza on 13/08/2023.
//

import UIKit

class MeasurementsDetailsTVCell0: UITableViewCell {

    @IBOutlet weak var LaNum: UILabel!
    
    @IBOutlet weak var LaDateFrom: UILabel!
    @IBOutlet weak var LaDateTo: UILabel!
    
    @IBOutlet weak var LaNaturalFrom: UILabel!
    @IBOutlet weak var LaNaturalTo: UILabel!
    
    var delegate : MeasurementsDetailsTVCell0_Protocoal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func BUAddMeasurement(_ sender: Any) {
        delegate.AddMeasurement()
    }
    
    @IBAction func BUSearch(_ sender: Any) {
        delegate.Search()
    }
    
    @IBAction func BUTearMonthDay(_ sender: UIButton) {
        delegate.TearMonthDay(tag: sender.tag)
    }
    
    
    @IBAction func BUAllMeasurement(_ sender: Any) {
        delegate.AllMeasurement()
    }
    
    
    @IBAction func BUToDate(_ sender: Any) {
        delegate.FromDateToDate(select: "to" , LaDateFrom : LaDateFrom)
    }
    
    @IBAction func BUFromDate(_ sender: Any) {
        delegate.FromDateToDate(select: "from" , LaDateFrom : LaDateFrom)
    }
    
}

protocol MeasurementsDetailsTVCell0_Protocoal {
    
    func AllMeasurement ()
    func TearMonthDay (tag : Int)
    func Search ()
    func AddMeasurement ()
    func FromDateToDate (select : String , LaDateFrom : UILabel)

}
