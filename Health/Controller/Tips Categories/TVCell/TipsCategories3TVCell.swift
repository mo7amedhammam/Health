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

    var model : TipDetailsM?{
        didSet{
            guard let model = model else {return}
            LaTitle.text = model.title
            LaDAte.text = model.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a")
            if let img = model.image {
                //                let processor = SVGImgProcessor() // if receive svg image
                ImgTipCategory.kf.setImage(with: URL(string:Constants.baseURL + img.validateSlashs()), placeholder: UIImage(named: "person"), options: nil, progressBlock: nil)
            }
            setDrugGroups()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension TipsCategories3TVCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    fileprivate func setDrugGroups() {
        
        // drup groups collection tags .
        CVDrugGroups.dataSource = self
        CVDrugGroups.delegate = self
        CVDrugGroups.registerCell(cellClass: TipDetailsDrugGroup.self)
        CVDrugGroups.transform = CGAffineTransform(scaleX: -1, y: 1) //first tip mirror effect for x -> second in cell

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.drugGroups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipDetailsDrugGroup", for: indexPath) as! TipDetailsDrugGroup
        let model = model?.drugGroups?[indexPath.row]
        cell.LaDrugTitle.text = model?.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate and return the size of the cell based on your content
        return CGSize(width: collectionView.bounds.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // Adjust the spacing between cells as needed
    }
}
