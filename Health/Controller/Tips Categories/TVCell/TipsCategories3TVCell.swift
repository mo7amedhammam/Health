//
//  TipsCategories3TVCell.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategories3TVCell: UITableViewCell {
    
    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaDAte: UILabel!
    @IBOutlet weak var CVDrugGroups: UICollectionView!
    @IBOutlet weak var HViewSuper: NSLayoutConstraint!
    
    var labelWidth = 0.0

    var model : TipDetailsM?{
        
        didSet {
            
//            guard let model = model else {return}
//            LaTitle.text = model.title
//            LaDAte.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
//            if let img = model.image {
//                //                let processor = SVGImgProcessor() // if receive svg image
//                ImgTipCategory.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)
//            }
            
//            CVDrugGroups.reloadData()
            
//            HViewSuper.constant = (100.0 + calculateCollectionViewHeight())

//            if model.drugGroups?.count == 0 {
//                HViewSuper.constant = 90
//            } else if model.drugGroups?.count == 1 {
//                HViewSuper.constant = 125
//            } else {
//                if ((model.drugGroups!.count) ) % 2 == 0 {
//                    HViewSuper.constant = (100.0 + CVDrugGroups.frame.height )
//                } else {
//                    HViewSuper.constant = (100.0 + CVDrugGroups.frame.height)
//                }
//            }
            
                        
        }
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
//        CVDrugGroups.layoutIfNeeded()
//        let contentSize = CVDrugGroups.collectionViewLayout.collectionViewContentSize
//        return contentSize.height
        
        let numberOfItems = model?.drugGroups?.count // Number of items in UICollectionView
        let itemsPerRow   =  calculateItemsPerRow (for: CVDrugGroups)// Number of items per row (if applicable)
        let itemHeight    =  20.0 // Height of each item in UICollectionView

        let numberOfRows = ceil(Double(numberOfItems!) / Double(itemsPerRow))
        let collectionViewHeight = numberOfRows * itemHeight
        return collectionViewHeight
    }

    func calculateItemsPerRow(for collectionView: UICollectionView) -> Int {
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInset = collectionViewFlowLayout?.sectionInset ?? UIEdgeInsets.zero
        let contentInset = collectionView.contentInset
        let itemSpacing = collectionViewFlowLayout?.minimumInteritemSpacing ?? 0.0
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right - contentInset.left - contentInset.right
        let itemWidth = collectionViewFlowLayout?.itemSize.width ?? 0.0
        // Calculate the number of items that can fit in one row
        let itemsPerRow = max(1, Int((availableWidth + itemSpacing) / (itemWidth + itemSpacing)))
        
        return itemsPerRow
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // drup groups collection tags .
        CVDrugGroups.dataSource = self
        CVDrugGroups.delegate = self
        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
//        CVDrugGroups.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
        
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .right, verticalAlignment: .top)
        alignedFlowLayout.estimatedItemSize = AlignedCollectionViewFlowLayout.automaticSize
        CVDrugGroups.collectionViewLayout = alignedFlowLayout
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension TipsCategories3TVCell:UICollectionViewDataSource,UICollectionViewDelegate {
    //UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.drugGroups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipDetailsDrugGroup", for: indexPath) as! TipDetailsDrugGroup

        cell.LaDrugTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
        let model = model?.drugGroups?[indexPath.row]
        cell.LaDrugTitle.text = model?.title
        cell.LaDrugTitle.font = UIFont(name: "LamaSans-Medium", size: 10)
        return cell
    }
 
}
