//
//  INBodyVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class INBodyVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyTVCell.self)
        TVScreen.reloadData()
    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUNotification(_ sender: Any) {
        
    }
  
    @IBAction func BUAddNewMeasure(_ sender: Any) {
        
    }

}


extension INBodyVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "INBodyTVCell", for: indexPath) as! INBodyTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "INBodyDetailsVC") as! INBodyDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
