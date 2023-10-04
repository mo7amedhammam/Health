//
//  TipsCategoriesTVCell1.swift
//  Health
//
//  Created by Hamza on 27/08/2023.
//

import UIKit

class TipsCategoriesTVCell1: UITableViewCell {

    @IBOutlet weak var CollectionCat: UICollectionView!
    @IBOutlet weak var LaCategoryTitle: UILabel!
    var nav : UINavigationController?
    var tipcategirytype:enumTipsCategories = .All
    
    var dataArray : [TipsNewestM] = []{
        didSet{
            CollectionCat.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .horizontal
        layout.minimumLineSpacing      = 30
        layout.minimumInteritemSpacing = 0
        CollectionCat.collectionViewLayout = layout
        CollectionCat.dataSource = self
        CollectionCat.delegate = self
        CollectionCat.registerCell(cellClass: TipsCategoriesCVCell1.self)
//        CollectionCat.semanticContentAttribute = .forceRightToLeft
        CollectionCat.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func BUMoreFirstCollection(_ sender: Any) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC2.self) else {return}
        vc.hidesBottomBarWhenPushed = true
        vc.tipcategirytype = tipcategirytype
        vc.dataArray = dataArray

        switch tipcategirytype {
        case .All:
            print(0)
        case .Newest:
            vc.LaTitle = "نصائح حديثة"
            
        case .Interesting:
            vc.LaTitle = "نصائح تهمك"

        case .MostViewed:
            vc.LaTitle = "النصائح الأكثر مشاهدة"

        }
        nav?.pushViewController(vc, animated: true)
    }
        
}

extension TipsCategoriesTVCell1 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell1", for: indexPath) as! TipsCategoriesCVCell1
         let model = dataArray[indexPath.row]
            cell.model = model
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 250, height: 253)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC3.self) else{return}
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesDetailsVC.self) else {return}

        let model = dataArray[indexPath.row]
        vc.selectedTipId = model.id
        vc.ViewModel = TipsDetailsVM()
        vc.modalPresentationStyle = .fullScreen
        nav?.present(vc, animated: true)
    }
    
}
