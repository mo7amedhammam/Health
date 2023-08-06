//
//  INBodyDetailsVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class INBodyDetailsVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyDetailsTVCell.self)
        TVScreen.reloadData()
        
//        Show_View_Done(SuperView: self.view, load: true , Stringtitle: "تم تحميل التقرير بنجاح", imgName: "logo")
        
        
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
       

}


extension INBodyDetailsVC : UITableViewDataSource , UITableViewDelegate , INBodyDetailsTVCell_protocoal {
        
    func DownloadReport() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "INBodyDetailsTVCell", for: indexPath) as! INBodyDetailsTVCell
        cell.delegae = self
        return cell
    }
    
}
