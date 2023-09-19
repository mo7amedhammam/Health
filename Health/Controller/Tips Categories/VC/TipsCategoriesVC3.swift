//
//  TipsCategoriesVC3.swift
//  Health
//
//  Created by Hamza on 26/08/2023.
//

import UIKit

class TipsCategoriesVC3: UIViewController {
    
    @IBOutlet weak var LaTitleBare: UILabel!
    @IBOutlet weak var TVScreen: UITableView!
    
    var categoryId:Int?
    var LaTitle : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LaTitleBare.text = LaTitle
        TVScreen.dataSource = self
        TVScreen.delegate   = self
        TVScreen.registerCellNib(cellClass: TipsCategories3TVCell.self)
        TVScreen.reloadData()
    }
    
    
    @IBAction func BUNoti(_ sender: Any) {
    }
    
    @IBAction func BUBack(_ sender: Any) {
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension TipsCategoriesVC3 : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCategories3TVCell", for: indexPath) as! TipsCategories3TVCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TipsCategoriesDetailsVC") as! TipsCategoriesDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
