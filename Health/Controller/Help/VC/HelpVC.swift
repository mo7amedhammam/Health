//
//  HelpVC.swift
//  Sehaty
//
//  Created by Hamza on 16/12/2023.
//

import UIKit

class HelpVC: UIViewController {
    
    @IBOutlet weak var TVScreen: UITableView!
    @IBOutlet weak var LaName: UILabel!
    @IBOutlet weak var ImgUser: UIImageView!
    
    let ViewModel = HelpVM()
    let ViewModelProfile = ProfileVM()
    var currentIndex = -1
    var Play         = false
 
    private var selectedVideoIndex: Int?
    private var webViewHeights: [Int: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        TVScreen.dataSource = self
//        TVScreen.delegate  = self
//        TVScreen.registerCellNib(cellClass: HelpTVCell.self)
        setupTableView()

        getHelp()
//        GetMyProfile()
        
    }
    // MARK: - Setup
       private func setupTableView() {
           TVScreen.dataSource = self
           TVScreen.delegate = self
           TVScreen.registerCellNib(cellClass: HelpTVCell.self)
           
//           TVScreen.rowHeight = UITableView.automaticDimension
//           TVScreen.estimatedRowHeight = 200
//           TVScreen.separatorStyle = .none
       }
    
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func getHelp() {
        ViewModel.GetMyHelp { [weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                
                CloseView_NoContent()
                
                if ViewModel.ArrHelp == nil || ViewModel.ArrHelp?.count == 0  {
                    LoadView_NoContent(Superview: TVScreen, title: "لا يوجد مساعده  ", img: "")
                } else {
                    TVScreen.reloadData()
                }
                
                Hud.dismiss(from: self.view)
                print(state)
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    func GetMyProfile(){
        ViewModelProfile.GetMyProfile {[weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                //                Hud.showHud(in: self.view,text: "")
                print("loading")
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                if let user = ViewModelProfile.responseModel{
                    LaName.text  = user.name
                }
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
}

extension HelpVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return ViewModel.ArrHelp?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTVCell", for: indexPath) as! HelpTVCell
        guard let model = ViewModel.ArrHelp?[indexPath.row]else {return cell}
            
            cell.LaTitle1.text = model.title
            
            // Load the YouTube video URL
            if let youtubeURL = URL(string: model.videoURL ?? "") {
                let request = URLRequest(url: youtubeURL)
                cell.webView.load(request)
            }
            if indexPath.row == selectedVideoIndex {
                cell.configure(with : model, play: true)
            }
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentIndex = indexPath.row
        selectedVideoIndex = indexPath.row

//        Play         = true
//        TVScreen.reloadData()
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
}
