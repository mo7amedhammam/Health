//
//  INBodyDetailsVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

class INBodyDetailsVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    var SelectedinbodyitemModel : InbodyListItemM?
    var viewModel = InbodyListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyDetailsTVCell.self)
        TVScreen.reloadData()
        
//        Show_View_Done(SuperView: self.view, load: true , Stringtitle: "تم تحميل التقرير بنجاح", imgName: "logo")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
       

}


extension INBodyDetailsVC : UITableViewDataSource , UITableViewDelegate , INBodyDetailsTVCell_protocoal {
        
    func DownloadReport() {
        let downloadURL = URL(string: Constants.baseURL + (SelectedinbodyitemModel?.testFile ?? ""))!
        var urlextension = ""
        if let downloadURLString = SelectedinbodyitemModel?.testFile {
            if let lastDotIndex = downloadURLString.lastIndex(of: ".") {
                let extensionSubstring = downloadURLString.suffix(from: downloadURLString.index(after: lastDotIndex))
                urlextension = "." + extensionSubstring
            }
        }
        
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("downloadedFile\(urlextension)")

        print("downloadURL :",downloadURL)
        BaseNetwork.downloadFile(from: downloadURL, to: destinationURL) { [self] result in
            switch result {
            case .success:
                print("Download successful. File saved at \(destinationURL)")
                InbodyDownloaded()

            case .failure(let error):
                print("Download failed with error: \(error.localizedDescription)")
            }
        }
//        InbodyDownloaded()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "INBodyDetailsTVCell", for: indexPath) as! INBodyDetailsTVCell
        cell.inbodyitemModel = SelectedinbodyitemModel
        cell.delegae = self
        return cell
    }
    
}

extension INBodyDetailsVC{
    func InbodyDownloaded()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم تحمل التقرير بنجاح"
            viewDone.imgStr = "downloadicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
            }
        }
    }
}
