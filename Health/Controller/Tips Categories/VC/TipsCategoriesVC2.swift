//
//  TipsCategoriesVC2.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC2: UIViewController {
    
    
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var CollectionScreen: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .vertical
        layout.minimumLineSpacing      = 0
        layout.minimumInteritemSpacing = 0
        CollectionScreen.collectionViewLayout = layout
        CollectionScreen.dataSource = self
        CollectionScreen.delegate = self
        CollectionScreen.registerCell(cellClass: TipsCategories2CVCell.self)
        CollectionScreen.reloadData()
        
    }
    
    
    @IBAction func BUNoti(_ sender: Any) {
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}



extension TipsCategoriesVC2 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategories2CVCell", for: indexPath) as! TipsCategories2CVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 , height: 253)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TipsCategoriesVC3") as! TipsCategoriesVC3
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
