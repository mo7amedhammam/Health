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
    
    @IBOutlet weak var imgShare: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TVScreen.dataSource = self
        TVScreen.delegate = self
        TVScreen.registerCellNib(cellClass: INBodyDetailsTVCell.self)
        TVScreen.reloadData()
        
        imgShare.kf.setImage(with: URL(string: Constants.baseURL + (SelectedinbodyitemModel?.testFile ?? "")), placeholder: UIImage(named: "defaultLogo"), options: nil, progressBlock: nil)

        
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
//                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    func InbodyDownloaded(filePath: URL) {
        let destinationURL = filePath
        print("destinationURL :: \(destinationURL)")
        // Check if the file exists at the destination URL
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            let fileExtension = destinationURL.pathExtension.lowercased()

            if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" || fileExtension == "webp" ||  fileExtension == "svg" {
                
//                downloadAndSaveImage(from: filePath) { result in
//                    switch result {
//                    case .success(let filePath):
//                        print("Image saved successfully at: \(filePath)")
//                        print("Image saved to photo library successfully.")
//                        DispatchQueue.main.async { [weak self] in
//                            guard let self = self else { return }
//                            if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
//                                viewDone.title = "تم تحميل التقرير بنجاح"
//                                viewDone.imgStr = "downloadicon"
//                                viewDone.action = {
//                                    viewDone.removeFromSuperview()
//                                }
//                            }
//                        }
//
//                    case .failure(let error):
//                        self.showAlert(message: "Failed to save image. Error: \(error.localizedDescription)")
//                        print("Failed to save image. Error: \(error.localizedDescription)")
//                    }
//                }
                
                print("imageUrlString : \(Constants.baseURL + (SelectedinbodyitemModel?.testFile ?? ""))")
             
                // Create a UIImage object from your image file
                       let items = [imgShare.image]
                       // Initialize a UIActivityViewController with the items to share
                       let activityViewController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                       // Present the activity view controller
                       if let popoverController = activityViewController.popoverPresentationController {
                           popoverController.sourceView = self.view
                           popoverController.sourceRect = self.view.bounds
                       }
                       self.present(activityViewController, animated: true, completion: nil)
                
                // Example usage
//                let imageUrlString = filePath.absoluteString
//                print("imageUrlString : \(imageUrlString)")
//                RagabsaveImageFromURL(imageUrlString) { (success, error) in
//                    if success {
//                        print("Image saved successfully.")
//                        DispatchQueue.main.async { [weak self] in
//                            guard let self = self else { return }
//                            if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
//                                viewDone.title = "تم تحميل التقرير بنجاح"
//                                viewDone.imgStr = "downloadicon"
//                                viewDone.action = {
//                                    viewDone.removeFromSuperview()
//                                }
//                            }
//                        }
//
//                    } else {
//                        if let error = error {
//                            print("Error saving image: \(error)")
//                        } else {
//                            print("Unknown error saving image.")
//                        }
//                    }
//                }
                
              
                
                // It's an image file, save it to the photo library
//                PHPhotoLibrary.requestAuthorization { status in
//                    if status == .authorized {
//                        // Save the image to the photo library
//                        PHPhotoLibrary.shared().performChanges {
//                            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: destinationURL)
//                        } completionHandler: { success, error in
//                            if success {
//                                print("Image saved to photo library successfully.")
//                                DispatchQueue.main.async { [weak self] in
//                                    guard let self = self else { return }
//                                    if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
//                                        viewDone.title = "تم تحميل التقرير بنجاح"
//                                        viewDone.imgStr = "downloadicon"
//                                        viewDone.action = {
//                                            viewDone.removeFromSuperview()
//                                        }
//                                    }
//                                }
//                            } else {
//                                // Handle the case where saving the image fails
//                                print("Failed to save image to photo library. Error: \(error?.localizedDescription ?? "")")
//                            }
//                        }
//                    } else {
//                        // Handle the case where the app doesn't have permission to access the photo library
//                        print("App does not have access to the photo library.")
//                    }
//                }
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
    
    func RagabsaveImageFromURL(_ urlString: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(false, error)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                // Get the documents directory
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    completion(false, nil)
                    return
                }

                // Create a unique filename for the image
                let fileName = UUID().uuidString
                let fileURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("png")

                // Save the image data to a file
                do {
                    try data.write(to: fileURL)
                    completion(true, nil)
                } catch {
                    completion(false, error)
                }
            } else {
                completion(false, nil)
            }
        }

        task.resume()
    }

   
    
    func downloadAndSaveImage(from url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                let dataError = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                completion(.failure(dataError))
                return
            }

            // Save the image to the documents directory
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = url.lastPathComponent
                let fileURL = documentsDirectory.appendingPathComponent(fileName)

                do {
                    try image.jpegData(compressionQuality: 1.0)?.write(to: fileURL)
                    completion(.success(fileURL.path))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
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
