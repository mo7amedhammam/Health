//
//  SplashScreenVC.swift
//  Health
//
//  Created by Hamza on 28/07/2023.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    @IBOutlet weak var CollectionSplash: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        CollectionSplash.dataSource = self
        CollectionSplash.delegate = self
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell1.self)
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell2.self)
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell3.self)
                
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        CollectionSplash.setCollectionViewLayout(layout, animated: true)
        
        CollectionSplash.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        CollectionSplash.reloadData()
    }
    
}


extension SplashScreenVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , SplashScreenTVCell_protocoal {
    
    
    func SkipSplash() {
        Helper.onBoardOpened(opened: true)
        Helper.changeRootVC(newroot: LoginVC.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell1", for: indexPath) as! SplashScreenTVCell1
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell2", for: indexPath) as! SplashScreenTVCell2
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.delegate = self
            return cell
            
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell3", for: indexPath) as! SplashScreenTVCell3
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //here your custom value for spacing
    }
    
}
