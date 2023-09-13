//
//  INBodyVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit

enum FileType {
case image, Pdf
}
class INBodyVC: UIViewController {

    @IBOutlet weak var TVScreen: UITableView!
    
    var imagePickerHelper : ImagePickerHelper?
    var image:UIImage?

    var pdfPickerHelper : PDFPickerHelper?
    var pdfURL:URL?

    let ViewModel = InbodyListVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyTVCell.self)
        // Initialize ImagePickerHelper here
        imagePickerHelper = ImagePickerHelper(viewController: self)
        pdfPickerHelper = PDFPickerHelper(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetCustomerInbodyList()
    }
    
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BUNotification(_ sender: Any) {
        
    }
  
    @IBAction func BUAddNewMeasure(_ sender: Any) {
        chooseFileType()
    }

}


extension INBodyVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.responseModel?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "INBodyTVCell", for: indexPath) as! INBodyTVCell
         let model = ViewModel.responseModel?.items?[indexPath.row]
        cell.inbodyitemModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = ViewModel.responseModel?.items?[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "INBodyDetailsVC") as! INBodyDetailsVC
        vc.viewModel = ViewModel
        vc.SelectedinbodyitemModel = model
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last visible cell is close to the end of the table view
    
        let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last
        guard let modelarr = ViewModel.responseModel?.items else {return}
        if let lastVisibleCell = lastVisibleIndexPath, lastVisibleCell.row == modelarr.count - 1 {
            if modelarr.count > 0  {
                    self.loadNextPage()
            }
        }
    }
    func loadNextPage(){
        guard (ViewModel.responseModel?.totalCount ?? 0) > (ViewModel.responseModel?.items?.count ?? 0) , ViewModel.cansearch == true else {return}
        ViewModel.skipCount = ViewModel.responseModel?.items?.count
        GetCustomerInbodyList()
    }

}

//-- functions --
extension INBodyVC{
    
    func GetCustomerInbodyList() {
        ViewModel.GetCustomerInbodyList{[self] state in
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view)
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                TVScreen.reloadData()
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
   
    func AddInbodyReport(filetype:FileType) {
        switch filetype {
        case .image:
            ViewModel.TestImage = image

        case .Pdf:
            ViewModel.TestPdf = pdfURL

        }
        ViewModel.Date = Helper.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").string(from: Date())
        ViewModel.AddCustomerInbodyReport(fileType:filetype,progressHandler: { progress in
//            DispatchQueue.main.async {
                //                self.handleProgress(progress: progress)
                let progressText = String(format: "%.0f%%", progress * 100)
                if progress > 0{
//                    Hud.showHud(in: self.view,text: "")
                    Hud.updateProgress(progressText)
                }else{
                    Hud.dismiss(from: self.view)
                }
//            }
        }){[self] state in
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view,text: "")
//                print("Uploading...")
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                GetCustomerInbodyList()
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
             
    //choose type -> image or pdf
    func chooseFileType(){
        let alertController = UIAlertController(title: "اختر نوع الملف", message: "من فضلك حدد نوع الملف الذي سيتم اضافتة", preferredStyle: .actionSheet)
        let imgButtom = UIAlertAction(title: "صوره", style: .default,handler: { [self](action)->Void in
            print("upload image")
            showImagePickerMenue()
        })
        let pdfButtom = UIAlertAction(title: "ملف", style: .default,handler: { [self](action)->Void in
            print("upload pdf")
            addPdfDocument()
        })
        let cancelButtom = UIAlertAction(title: "إلغاء", style: .cancel)
        
        alertController.addAction(imgButtom)
        alertController.addAction(pdfButtom)
        alertController.addAction(cancelButtom)
        
        self.navigationController?.present(alertController, animated: true)
    }
    
    // if image will be from gallery of camera
    func showImagePickerMenue(){
        imagePickerHelper?.showImagePicker { [weak self] receivedImage in
            if let image = receivedImage {
                // Do something with the received image
                self?.image = image
                self?.AddInbodyReport(filetype: .image)
            } else {
                // Handle the case where no image was received or there was an error
            }
        }
    }
 
    // if pdf -> open document picker to select file
    func addPdfDocument(){
        pdfPickerHelper?.showPDFPicker{ pickedPDFURL in
            if let pdfURL = pickedPDFURL {
                // Do something with the picked PDF file URL
                self.pdfURL = pdfURL
                print("Picked PDF file URL: \(pdfURL)")
                self.AddInbodyReport(filetype: .Pdf)

            } else {
                // Handle the case where no PDF file was picked or the user canceled
                print("No PDF file picked or canceled")
            }
        }
    }
    
}
