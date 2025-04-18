//
//  TipsCategories3TVCell.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategories3TVCell: UITableViewCell  {
    
    @IBOutlet weak var ImgTipCategory: UIImageView!
    @IBOutlet weak var LaTitle: UILabel!
    @IBOutlet weak var LaDAte: UILabel!
    @IBOutlet weak var CVDrugGroups: UICollectionView!
    @IBOutlet weak var HViewSuper: NSLayoutConstraint!
    var model : TipDetailsM?
    

    func calculateCollectionViewHeight() -> CGFloat {
//        CVDrugGroups.layoutIfNeeded()
//        let contentSize = CVDrugGroups.collectionViewLayout.collectionViewContentSize
//        return contentSize.height
        
        let numberOfItems = model?.drugGroups?.count // Number of items in UICollectionView
        let itemsPerRow   =  calculateItemsPerRow (for: CVDrugGroups)// Number of items per row (if applicable)
        let itemHeight    =  21.0 // Height of each item in UICollectionView
        let numberOfRows = ceil(Double(numberOfItems ?? 0) / Double(itemsPerRow))
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
//        CVDrugGroups.dataSource = self
//        CVDrugGroups.delegate = self
//        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
//        CVDrugGroups.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
        
//        let layout = CollectionViewFlowLayout() //MultipleSelectionCVFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        CVDrugGroups.translatesAutoresizingMaskIntoConstraints = false
//        CVDrugGroups.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
//        CVDrugGroups.collectionViewLayout = layout
//        CVDrugGroups.dataSource = self
//        CVDrugGroups.delegate = self
//        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
      

        CVDrugGroups.dataSource = self
        CVDrugGroups.delegate   = self
        CVDrugGroups.registerCell(cellClass: TipsCVCell.self)
        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
//        CVDrugGroups.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell
     
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.estimatedItemSize = AlignedCollectionViewFlowLayout.automaticSize
        CVDrugGroups.collectionViewLayout = alignedFlowLayout
        

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}


extension TipsCategories3TVCell:UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    //UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.drugGroups?.count ?? 0
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 20
//        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipDetailsDrugGroup", for: indexPath) as! TipDetailsDrugGroup
        
//        cell.LaDrugTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
//        let model = model?.drugGroups?[indexPath.row]
//        cell.LaDrugTitle.text = model?.title
//        return cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCVCell", for: indexPath) as! TipsCVCell
//        cell.LaTitle.transform = CGAffineTransform(scaleX: -1, y: 1)

        let model = model?.drugGroups?[indexPath.row]
        cell.LaTitle.text = model?.title
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let text = self.model?.drugGroups?[indexPath.row].title
//        let textSize = text!.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)])
//           let cellHeight = textSize.height
//           let cellWidth = textSize.width
//           return CGSize(width: cellWidth, height: cellHeight)
//       }
 
}

