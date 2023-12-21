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
    var selected = 0
    
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
        selected = 0
        TVscreen.reloadData()
        
        GetMyProfile()
    }
}


extension ProfileVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 12
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellHeader", for: indexPath) as! ProfileTVCellHeader
            if let user = ViewModel.responseModel{
                cell.LaName.text  = user.name
                cell.LaPhone.text = user.mobile
            }
            return cell
            
//        } else if indexPath.row == 1 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            cell.LaTitle.text = "الرئيسية"
//            cell.IVPhoto.image = UIImage(named: "user")
//            return cell
//
//        } else if indexPath.row == 2 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            cell.LaTitle.text = "قياساتي"
//            cell.IVPhoto.image = UIImage(named: "measurement")
//            return cell
//
//        } else if indexPath.row == 3 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            cell.LaTitle.text = "جداول الأدوية الشهرية"
//            cell.IVPhoto.image = UIImage(named: "table")
//            return cell
//
//        } else if indexPath.row == 4 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            cell.LaTitle.text = "تنبيهات الأدوية"
//            cell.IVPhoto.image = UIImage(named: "noti")
//            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "نصائح طبية"
            cell.IVPhoto.image = UIImage(named: "instruction")
            if selected == 1 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "Inbody"
            cell.IVPhoto.image = UIImage(named: "newInbody")
            
            if selected == 2 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLine", for: indexPath) as! ProfileTVCellLine
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "تغيير كلمة المرور"
            cell.IVPhoto.image = UIImage(named: "location")
            if selected == 4 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "الحماية والخصوصية"
            cell.IVPhoto.image = UIImage(named: "protection")
            if selected == 5 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "المساعده "
            cell.IVPhoto.image = UIImage(named: "playmain")
            if selected == 6 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
            
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
            cell.LaTitle.text = "الشروط والأحكام"
            cell.IVPhoto.image = UIImage(named: "terms")
            if selected == 7 {
                cell.ViewColor.backgroundColor = UIColor(named: "secondary")
            } else {
                cell.ViewColor.backgroundColor = .clear
            }
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLogout", for: indexPath) as! ProfileTVCellLogout
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // -- user image --
            
//        } else if indexPath.row == 1 { // - "الرئيسية" -
//
//        } else if indexPath.row == 2 { // - قياساتى -
//
//        } else if indexPath.row == 3 { // - "جداول الأدوية الشهرية" -
//
//        } else if indexPath.row == 4 { // - medecines notifications -

        } else if indexPath.row == 1 { // - "نصائح طبية" -
            selected = 1
            TVscreen.reloadData()
            PushTo(destination: TipsCategoriesVC1.self)
        } else if indexPath.row == 2 { // - inbody -
            selected = 2
            TVscreen.reloadData()
            PushTo(destination: INBodyVC.self)
        } else if indexPath.row == 3 { // - ProfileTVCellLine -
            
        } else if indexPath.row == 4 { // - "تغيير كلمة المرور" -
            selected = 4
            TVscreen.reloadData()
            PushTo(destination: ChangePasswordVC.self)
        } else if indexPath.row == 5 { // - "الحماية والخصوصية" -
            selected = 5
            TVscreen.reloadData()
        } else if indexPath.row == 6 { // - "المساعده "-
            selected = 6
            TVscreen.reloadData()
            PushTo(destination: HelpVC.self)
            
        }  else if indexPath.row == 7 { // - "الشروط والأحكام" -
            selected = 7
            TVscreen.reloadData()
            PushTo(destination: TermsConditionsVC.self)
        }else { // -- تسجيل خروج --
            
            let actionSheet  = UIAlertController(title: "هل أنت متأكد بأنك تريد تسجيل الخروج؟", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "تسجيل الخروج", style: .default, handler: { (_) in
                Helper.logout()
                Helper.changeRootVC(newroot: StartScreenVC.self,transitionFrom: .fromLeft)
            })
            actionSheet.addAction(alertAction)
            
            let alertAction1 = UIAlertAction(title: "إلفاء", style: .destructive, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            actionSheet.addAction(alertAction1)
            
            // valide ipad action sheet
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
            //------------------------
            present(actionSheet, animated: true, completion: nil)
                    
        }
        
    }
    
    func PushTo(destination:UIViewController.Type){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: destination.self)else{return}
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

// -- functions --
extension ProfileVC {
    func GetMyProfile(){
        ViewModel.GetMyProfile {[weak self] state in
            guard let self = self else{return}
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
