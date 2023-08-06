//
//  ProfileVC.swift
//  Health
//
//  Created by Hamza on 03/08/2023.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var TVscreen: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVscreen.dataSource = self
        TVscreen.delegate   = self
        TVscreen.registerCellNib(cellClass: ProfileTVCellLine.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellHeader.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellMiddle.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellLogout.self)
        TVscreen.reloadData()
    }
    
    
    
}


extension ProfileVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellHeader", for: indexPath) as! ProfileTVCellHeader
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "الرئيسية"
            cell.IVPhoto.image = UIImage(named: "user")
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "قياساتي"
            cell.IVPhoto.image = UIImage(named: "measurement")
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "جداول الأدوية الشهرية"
            cell.IVPhoto.image = UIImage(named: "table")
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "تنبيهات الأدوية"
            cell.IVPhoto.image = UIImage(named: "noti")
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "نصائح طبية"
            cell.IVPhoto.image = UIImage(named: "instruction")
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "Inbody"
            cell.IVPhoto.image = UIImage(named: "inbody")
            return cell
            
        } else if indexPath.row == 7 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLine", for: indexPath) as! ProfileTVCellLine
            return cell
            
        } else if indexPath.row == 8 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "تغيير كلمة المرور"
            cell.IVPhoto.image = UIImage(named: "location")
            return cell
            
        } else if indexPath.row == 9 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "الحماية والخصوصية"
            cell.IVPhoto.image = UIImage(named: "protection")
            return cell
            
        } else if indexPath.row == 10 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "الشروط والأحكام"
            cell.IVPhoto.image = UIImage(named: "terms")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLogout", for: indexPath) as! ProfileTVCellLogout
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            
        } else if indexPath.row == 3 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedicationScheduleVC") as! MedicationScheduleVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            
        } else if indexPath.row == 4 {
            
        } else if indexPath.row == 5 {
            
        } else if indexPath.row == 6 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "INBodyVC") as! INBodyVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            
        } else if indexPath.row == 7 {
            
            
        } else if indexPath.row == 8 {
            
        } else if indexPath.row == 9 {
            
        } else if indexPath.row == 10 {
            
        } else {
            
        }
        
    }
    
}
