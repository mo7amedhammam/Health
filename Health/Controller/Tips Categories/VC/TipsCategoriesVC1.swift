//
//  TipsCategoriesVC1.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC1: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    var Typecollection = "cell0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategoriesTVCell0.self)
        TVScreen.reloadData()
    }
    

   

}


extension TipsCategoriesVC1 : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategoriesTVCell0", for: indexPath) as! TipsCategoriesTVCell0
        
        if indexPath.row == 0 {
            cell.CollectionTips.dataSource = self
            cell.CollectionTips.delegate = self
            cell.CollectionTips.reloadData()
            Typecollection = "cell0"
        } else {
            cell.CollectionTips.dataSource = self
            cell.CollectionTips.delegate = self
            cell.CollectionTips.reloadData()
            Typecollection = "cells"
        }
        
        return cell
    }
        
}


extension TipsCategoriesVC1 : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Typecollection == "cell0" {
            return 5
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if Typecollection == "cell0" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell0", for: indexPath) as! TipsCategoriesCVCell0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsCategoriesCVCell1", for: indexPath) as! TipsCategoriesCVCell1
            return cell
            
        }
        
    }
    
    
}
