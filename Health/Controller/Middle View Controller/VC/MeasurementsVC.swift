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
        CollectionScreen.reloadData()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    
}



extension MeasurementsVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeasurementsCVCell", for: indexPath) as! MeasurementsCVCell
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MeasurementsDetailsVC") as! MeasurementsDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
}
