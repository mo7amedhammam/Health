//
//  ProfileVC.swift
//  Health
//
//  Created by Hamza on 03/08/2023.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var TVscreen: UITableView!
    
    let ViewModel = ProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVscreen.dataSource = self
        TVscreen.delegate   = self
        TVscreen.registerCellNib(cellClass: ProfileTVCellLine.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellHeader.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellMiddle.self)
        TVscreen.registerCellNib(cellClass: ProfileTVCellLogout.self)
//        TVscreen.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetMyProfile()
    }
}


extension ProfileVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellHeader", for: indexPath) as! ProfileTVCellHeader
            if let user = ViewModel.responseModel{
                cell.LaName.text = user.name
                cell.LaPhone.text = user.mobile
            }
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
            
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLogout", for: indexPath) as! ProfileTVCellLogout
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // -- user image --
            
        } else if indexPath.row == 1 { // - "الرئيسية" -
            
        } else if indexPath.row == 2 { // - قياساتى -
            
        } else if indexPath.row == 3 { // - "جداول الأدوية الشهرية" -
            
        } else if indexPath.row == 4 { // - medecines notifications -

        } else if indexPath.row == 5 { // - "نصائح طبية" -
            
        } else if indexPath.row == 6 { // - inbody -
            PushTo(destination: INBodyVC.self)
            
        } else if indexPath.row == 7 { // - ProfileTVCellLine -
            
        } else if indexPath.row == 8 { // - "تغيير كلمة المرور" -
            PushTo(destination: ChangePasswordVC.self)
            
        } else if indexPath.row == 9 { // - "الحماية والخصوصية" -
            
        } else if indexPath.row == 10 { // - "الشروط والأحكام" -
            
        } else { // -- تسجيل خروج --
            Helper.logout()
            Helper.changeRootVC(newroot: LoginVC.self)
        }
        
    }
    
    func PushTo(destination:UIViewController.Type){
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: destination.self)else{return}
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// -- functions --
extension ProfileVC {
    func GetMyProfile(){
        ViewModel.GetMyProfile {[self] state in
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
//                Hud.showHud(in: self.view,text: "")
                print("loading")
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
//                TVscreen.reloadData()
                TVscreen.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            case .error(_,let error):
                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
}
