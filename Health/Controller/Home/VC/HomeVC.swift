//
//  HomeVC.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: HomeTVCell0.self)
        TVScreen.registerCellNib(cellClass: HomeTVCell1.self)
        TVScreen.reloadData()
    }
        
    
}


extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell0", for: indexPath) as! HomeTVCell0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell1", for: indexPath) as! HomeTVCell1
            cell.DataSourseDeledate()
            cell.indexx = indexPath.row
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing      = 10
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection   = .horizontal
            //
            if indexPath.row == 1 {
                cell.HViewCell.constant = 400
                cell.BtnMore.isHidden   = true
                cell.LaTitle.text = "قياساتك الأخيرة"
            } else if indexPath.row == 2 {
                cell.HViewCell.constant = 220
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "الأدوية التي قاربة على الإنتهاء"
            } else if indexPath.row == 3 {
                cell.HViewCell.constant = 320
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "نصائح حديثة"
            } else  {
                cell.HViewCell.constant = 320
                cell.BtnMore.isHidden   = false
                cell.LaTitle.text = "النصائح الأكثر مشاهدة"
            }
            
            cell.CollectionHome.collectionViewLayout =  layout
            cell.CollectionHome.reloadData()
            return cell
        }
    }
    
}
