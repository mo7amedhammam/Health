//
//  INBodyVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit
import AVFoundation

enum FileType {
    case image, Pdf
}
class INBodyVC: UIViewController {
    @IBOutlet weak var TVScreen: UITableView!
    let refreshControl = UIRefreshControl()
    var imagePickerHelper : ImagePickerHelper?
    var image:UIImage?
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNewMes: UIButton!
    var pdfPickerHelper : PDFPickerHelper?
    var pdfURL:URL?
    var ImageOrPdf = 0
    let ViewModel = InbodyListVM()
//    var isAPIExecuting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyTVCell.self)
        // Initialize ImagePickerHelper here
        imagePickerHelper = ImagePickerHelper(viewController: self)
        pdfPickerHelper = PDFPickerHelper(viewController: self)
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        // Add the refresh control to the collection view
        TVScreen.addSubview(refreshControl)
        
        GetCustomerInbodyList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BtnNewMes.titleLabel?.font = UIFont(name: fontsenum.bold.rawValue, size: 24)!
        BtnBack.setImage(UIImage(resource: .backLeft).flippedIfRTL, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        GetCustomerInbodyList()
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
        if indexPath.row == (ViewModel.responseModel?.items?.count ?? 0) - 1 {
            // Check if the last cell is about to be displayed
            if let totalCount = ViewModel.responseModel?.totalCount, let itemsCount = ViewModel.responseModel?.items?.count, itemsCount < totalCount {
                // Load the next page if there are more items to fetch
                loadNextPage(itemsCount)
            }
        }
    }
    
    func loadNextPage(_ skipcount:Int){
        ViewModel.skipCount = skipcount
        GetCustomerInbodyList()
    }
    
}

//-- functions --
extension INBodyVC{
    
    func GetCustomerInbodyList() {
        ViewModel.GetCustomerInbodyList{[weak self] state in
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
                Hud.dismiss(from: self.view)
                print(state)
                CloseView_NoContent()
                if ViewModel.responseModel?.items?.count == 0 || ViewModel.responseModel?.items == nil {
                    LoadView_NoContent(Superview: TVScreen, title: "لا يوجد أي قياس لتحليل مكونات الجسم", img: "key-vector")
                } else {
                    TVScreen.reloadData()
                }
                
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    @objc func refreshData(){
        ViewModel.skipCount = 0
        GetCustomerInbodyList()
        refreshControl.endRefreshing()
    }
    
    func AddInbodyReport(filetype:FileType) {
        switch filetype {
        case .image:
            ViewModel.TestImage = image
            
        case .Pdf:
            ViewModel.TestPdf = pdfURL
        }
        ViewModel.Date = Helper.shared.ChangeFormate(NewFormat: "yyyy-MM-dd'T'HH:mm:ss").string(from: Date())
        ViewModel.AddCustomerInbodyReport(fileType:filetype,progressHandler: {[weak self] progress in
            guard let self = self else{return}

            let progressText = String(format: "%.0f%%", progress * 100)
            if progress > 0 {
                Hud.updateProgress(progressText)
            }else{
                Hud.dismiss(from: self.view)
            }
        }){[weak self] state in
            guard let self = self else{return}
            guard let state = state else{
                return
            }
            switch state {
            case .loading:
                Hud.showHud(in: self.view,text: "")
            case .stopLoading:
                Hud.dismiss(from: self.view)
            case .success:
                Hud.dismiss(from: self.view)
                print(state)
                
                ViewModel.skipCount = 0
                ViewModel.responseModel?.items?.removeAll()
                TVScreen.reloadData()
                
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
        
        
        let cancelButtom = UIAlertAction(title: "إلغاء", style: .cancel ,handler: { [self](action)->Void in
//            isAPIExecuting = false
        })
       
        alertController.addAction(imgButtom)
        alertController.addAction(pdfButtom)
        alertController.addAction(cancelButtom)
        
        self.navigationController?.present(alertController, animated: true)
    }
    
    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func showImagePickerMenue() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized: // User has granted camera permission
            showImagePicker()
        case .notDetermined: // Camera permission has not been requested yet
            requestCameraPermission { [weak self] granted in
                if granted {
                    self?.showImagePicker()
                } else {
                    // Handle the case where camera permission was denied
                    self?.showPermissionDeniedAlert()
                }
            }
        case .denied, .restricted: // Camera permission was denied or restricted
//            showPhotoLibrary()
            self.showPermissionDeniedAlert()
            print("denied")
        @unknown default:
//            showPhotoLibrary()
            self.showPermissionDeniedAlert()
            print("default")
        }
    }
    
    
    // Function to show permission denied alert
    private func showPermissionDeniedAlert() {
        let alertController = UIAlertController(title: "تم رفض إذن الكاميرا", message: "يرجى منح إذن الكاميرا في الإعدادات لالتقاط الصور.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "إعدادات", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel ,handler: { [self](action)->Void in
//            isAPIExecuting = false
        })
                                         
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // if image will be from gallery of camera
    func showImagePicker(){
//        guard !isAPIExecuting else {
//            // API call is already in progress, so return early
//            return
//        }
//        isAPIExecuting = true
        imagePickerHelper?.showImagePicker { [weak self] receivedImage in
            if let image = receivedImage {
                // Do something with the received image
                self?.ImageOrPdf = 0
                self?.image = image
                self?.AddInbodyReport(filetype: .image)
            } else {
                // Handle the case where no image was received or there was an error
            }
            // Reset the flag after the API call is complete
//            self?.isAPIExecuting = false
        }
    }
    
    // if pdf -> open document picker to select file
    func addPdfDocument(){
//        guard !isAPIExecuting else {
//            // API call is already in progress, so return early
//            return
//        }
//        isAPIExecuting = true
        
        pdfPickerHelper?.showPDFPicker{ pickedPDFURL in
            if let pdfURL = pickedPDFURL {
                // Do something with the picked PDF file URL
                self.ImageOrPdf = 1
                self.pdfURL = pdfURL
                print("Picked PDF file URL: \(pdfURL)")
                self.AddInbodyReport(filetype: .Pdf)
                
            } else {
                // Handle the case where no PDF file was picked or the user canceled
                print("No PDF file picked or canceled")
            }
            // Reset the flag after the API call is complete
//            self.isAPIExecuting = false
        }
    }
    
    // Start a background task when the app enters the background state
    func applicationDidEnterBackground(_ application: UIApplication) {
        let backgroundTaskIdentifier = application.beginBackgroundTask {
            // Upload the file in the background task
            if self.ImageOrPdf == 0 {
                self.showImagePickerMenue()
            } else {
                self.addPdfDocument()
            }
        }
    }
    
}
