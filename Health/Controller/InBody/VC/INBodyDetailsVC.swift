//
//  INBodyDetailsVC.swift
//  Health
//
//  Created by Hamza on 05/08/2023.
//

import UIKit
import Photos

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
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
       

}


extension INBodyDetailsVC : UITableViewDataSource , UITableViewDelegate , INBodyDetailsTVCell_protocoal {
    
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
    
    func DownloadReport(){
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
        
        Hud.showHud(in: self.view,text: "")
        BaseNetwork.downloadFile(from: downloadURL, to: destinationURL,progressHandler: { progress in
            let progressText = String(format: "%.0f%%", progress * 100)
            if progress > 0{
                Hud.updateProgress(progressText)
            } else {
                
                Hud.dismiss(from: self.view)
            }
        }){ [self] result in
            Hud.dismiss(from: self.view)
            switch result {
            case .success:
                print("Download successful. File saved at \(destinationURL)")
                InbodyDownloaded(filePath: destinationURL)
                
            case .failure(let error):
                print("Download failed with error: \(error.localizedDescription)")
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    func InbodyDownloaded(filePath: URL) {
        let destinationURL = filePath

        // Check if the file exists at the destination URL
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            let fileExtension = destinationURL.pathExtension.lowercased()

            if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                // It's an image file, save it to the photo library
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        // Save the image to the photo library
                        PHPhotoLibrary.shared().performChanges {
                            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: destinationURL)
                        } completionHandler: { success, error in
                            if success {
                                print("Image saved to photo library successfully.")
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
                                        viewDone.title = "تم تحميل التقرير بنجاح"
                                        viewDone.imgStr = "downloadicon"
                                        viewDone.action = {
                                            viewDone.removeFromSuperview()
                                        }
                                    }
                                }
                            } else {
                                // Handle the case where saving the image fails
                                print("Failed to save image to photo library. Error: \(error?.localizedDescription ?? "")")
                            }
                        }
                    } else {
                        // Handle the case where the app doesn't have permission to access the photo library
                        print("App does not have access to the photo library.")
                    }
                }
            } else if fileExtension == "pdf" {
                // Check if the PDF file is accessible by your app
                guard FileManager.default.isReadableFile(atPath: destinationURL.path) else {
                    print("App does not have permission to read the PDF file.")
                    return
                }
                // It's a PDF file, present the document picker
                let documentPicker = UIDocumentPickerViewController(url: destinationURL, in: .exportToService)
                documentPicker.delegate = self
                documentPicker.modalPresentationStyle = .formSheet
                present(documentPicker, animated: true, completion: nil)
            } else {
                // Handle unsupported file types
                print("Unsupported file type: \(fileExtension)")
            }
        } else {
            // Handle the case where the file doesn't exist at the specified URL
            print("File does not exist at \(destinationURL.path)")
        }
    }
    
}

extension INBodyDetailsVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let pickedURL = urls.first {
            // Handle the picked URL (e.g., save it to the Files app)
            savePDFToFilesApp(pickedURL)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle the case where the user cancels the document picker
    }
    
    func savePDFToFilesApp(_ pdfURL: URL) {
        // Handle the saved PDF file here if needed
        print("PDF file saved: \(pdfURL)")

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
                viewDone.title = "تم تحميل التقرير بنجاح"
                viewDone.imgStr = "downloadicon"
                viewDone.action = {
                    viewDone.removeFromSuperview()
                }
            }
        }
    }
    
    // Start a background task when the app enters the background state
    func applicationDidEnterBackground(_ application: UIApplication) {
        let backgroundTaskIdentifier = application.beginBackgroundTask {
            // download the file in the background task
            self.DownloadReport()
        }
    }
    
    
}
