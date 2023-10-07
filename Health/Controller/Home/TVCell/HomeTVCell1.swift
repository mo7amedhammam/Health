//
//  HomeTVCell1.swift
//  Health
//
//  Created by Hamza on 01/10/2023.
//

import UIKit

class HomeTVCell1: UITableViewCell {

    @IBOutlet weak var HViewCell: NSLayoutConstraint!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var BtnMore: UIButton!
    @IBOutlet weak var CollectionHome: UICollectionView!
    var indexx = 0
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func BUMore(_ sender: Any) {
    }
    
    func DataSourseDeledate () {
        CollectionHome.dataSource = self
        CollectionHome.delegate   = self
        CollectionHome.registerCell(cellClass: HomeCVCell1.self)
        CollectionHome.registerCell(cellClass: HomeCVCell2.self)
        CollectionHome.registerCell(cellClass: HomeCVCell3.self)
        CollectionHome.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}


extension HomeTVCell1 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexx == 1 {
            return 6
        } else if indexx == 2 {
            return 4
        } else if indexx == 3 {
            return 4
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexx == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell1", for: indexPath) as! HomeCVCell1
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        } else if indexx == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell2", for: indexPath) as! HomeCVCell2
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        } else if indexx == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell3", for: indexPath) as! HomeCVCell3
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell3", for: indexPath) as! HomeCVCell3
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexx == 1 {
            return CGSize(width: ( (CollectionHome.frame.size.width - 10) / 3 ) , height: 160)
        } else if indexx == 2 {
            return CGSize(width: 350, height: 150)
        } else {
            return CGSize(width: 250, height: 250)
        }
    }
    
    
}
