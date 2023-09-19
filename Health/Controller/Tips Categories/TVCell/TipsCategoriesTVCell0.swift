//
//  TipsCategoriesTVCell0.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesTVCell0: UITableViewCell {
    
    @IBOutlet weak var CollectionTips: UICollectionView!
    @IBOutlet weak var LaCategoryTitle: UILabel!
    var nav:UINavigationController?
    var ViewModel:TipsVM = TipsVM(){
        didSet{
            CollectionTips.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .horizontal
        layout.minimumLineSpacing      = 20
        layout.minimumInteritemSpacing = 0
        CollectionTips.collectionViewLayout = layout
        CollectionTips.dataSource = self
        CollectionTips.delegate = self
        CollectionTips.registerCell(cellClass: TipsCategoriesCVCell0.self)
        CollectionTips.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func BUMore(_ sender: Any) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
        vc.ViewModel = ViewModel
//        vc.tipcategirytype = .All
        vc.LaTitle = "تصنيفات النصائح"
        nav?.pushViewController(vc, animated: true)
    }
    
}


extension TipsCategoriesTVCell0 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.allTipsResModel?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell0", for: indexPath) as! TipsCategoriesCVCell0
        let model = ViewModel.allTipsResModel?.items?[indexPath.row]
        cell.model = model
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC3.self) else{return}
        let model = ViewModel.allTipsResModel?.items?[indexPath.row]
        vc.categoryId = model?.id
        vc.LaTitle = model?.title

        nav?.pushViewController(vc, animated: true)
    }
    
}


