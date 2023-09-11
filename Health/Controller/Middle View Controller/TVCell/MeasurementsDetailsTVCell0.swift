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
    
    @IBOutlet weak var BtnDay: UIButton!
    @IBOutlet weak var BtnMonth: UIButton!
    @IBOutlet weak var BtnYear: UIButton!
    @IBOutlet weak var btnAll: UIButton!

    
    
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
        delegate.Search(Lfrom : LaDateFrom , Lto : LaDateTo)
    }
    
    @IBAction func BUTearMonthDay(_ sender: UIButton) {
        delegate.TearMonthDay(tag: sender.tag , btnAll : btnAll , btnYear : BtnYear , btnMonth : BtnMonth  , btnDay : BtnDay , Lfrom : LaDateFrom , Lto : LaDateTo)
    }
    
    @IBAction func BUAllMeasurement(_ sender: Any) {
        delegate.AllMeasurement(btnAll : btnAll , btnYear : BtnYear , btnMonth : BtnMonth  , btnDay : BtnDay )
    }
    
    @IBAction func BUToDate(_ sender: Any) {
        delegate.FromDateToDate(select: "to" , LaDateFrom : LaDateFrom)
    }
    
    @IBAction func BUFromDate(_ sender: Any) {
        delegate.FromDateToDate(select: "from" , LaDateFrom : LaDateFrom)
    }
    
}

protocol MeasurementsDetailsTVCell0_Protocoal {
    
    func AllMeasurement (btnAll : UIButton , btnYear : UIButton , btnMonth : UIButton  , btnDay : UIButton )
    func TearMonthDay (tag : Int , btnAll : UIButton , btnYear : UIButton , btnMonth : UIButton  , btnDay : UIButton , Lfrom : UILabel , Lto : UILabel )
    func Search (Lfrom : UILabel , Lto : UILabel)
    func AddMeasurement ()
    func FromDateToDate (select : String , LaDateFrom : UILabel)

}
