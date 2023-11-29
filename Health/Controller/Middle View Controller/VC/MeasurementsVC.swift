//
//  MeasurementsVC.swift
//  Health
//
//  Created by Hamza on 02/08/2023.
//

import UIKit

class MeasurementsVC: UIViewController {
    
    
    @IBOutlet weak var CollectionScreen: UICollectionView!
    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var IVPhoto: UIImageView!
    @IBOutlet weak var IVPhotoOnLine: UIImageView!

    let ViewModel = MyMeasurementsStatsVM()
    
    let ViewModelProfile = ProfileVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CollectionScreen.dataSource = self
        CollectionScreen.delegate = self
        CollectionScreen.registerCell(cellClass: MeasurementsCVCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing      = 0
        layout.minimumInteritemSpacing = 0
        CollectionScreen.setCollectionViewLayout(layout, animated: true)
        LaName.text = "\(Helper.getUser()?.name ?? "")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getData()
            self.GetMyProfile()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension MeasurementsVC {
    func GetMyProfile() {
        ViewModelProfile.GetMyProfile {[weak self] state in
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
                if let user = ViewModelProfile.responseModel{
                    LaName.text  = user.name
                }
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


extension MeasurementsVC {
    
    func getData() {
                
        ViewModel.GetMeasurementsStats { [weak self]state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                CollectionScreen.reloadData()
                print(state)
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }        
    }
}



extension MeasurementsVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.ArrStats?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeasurementsCVCell", for: indexPath) as! MeasurementsCVCell
        let model = ViewModel.ArrStats![indexPath.row]
        print("formatValue : \( ViewModel.ArrStats![indexPath.row].formatValue!)")
        cell.LaTitle.text = model.title
        cell.LaNum.text = "\(model.measurementsCount ?? 0)"

        if model.measurementsCount == 0 {
            cell.ViewDate.isHidden = true
            cell.LaDate.text = ""
        } else {
            cell.LaDate.text = model.lastMeasurementDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy/MM/dd")
            cell.ViewDate.isHidden = false
        }
        
        if model.lastMeasurementValue == "" || model.lastMeasurementValue == nil {
            cell.LaLastNum.text       = "0"
        } else {
            cell.LaLastNum.text = model.lastMeasurementValue
        }
                
        if let img = model.image {
            //                let processor = SVGImgProcessor() // if receive svg image
            cell.ImgMeasurement.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ( collectionView.bounds.width - 20 )  / 2, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsDetailsVC.self) else{return}
        vc.ViewModel = ViewModel
        print("array",ViewModel.ArrMeasurement)
        if let model = ViewModel.ArrStats?[indexPath.row]{
            print("selectedModel",model)
            vc.id  =  model.medicalMeasurementID ?? 0
            vc.num = model.measurementsCount ?? 0
            vc.imgMeasurement = model.image ?? ""
            vc.TitleMeasurement = model.title ?? ""
//            vc.formatValue = model.formatValue ?? ""
            vc.formatRegex = model.regExpression ?? ""
            vc.formatHintMessage = model.normalRangValue ?? ""
            Shared.shared.MeasurementId = model.medicalMeasurementID ?? 0

        }
//        print("formatValue : \( ViewModel.ArrStats![indexPath.row].formatValue!)")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
