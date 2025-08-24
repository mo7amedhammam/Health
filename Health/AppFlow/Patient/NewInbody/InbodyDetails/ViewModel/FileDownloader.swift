//
//  FileDownloader.swift
//  Sehaty
//
//  Created by mohamed hammam on 06/08/2025.
//


//import Foundation
//import SwiftUI
//import Photos
//import UniformTypeIdentifiers

//class FileDownloader: NSObject, ObservableObject, UIDocumentPickerDelegate {
//    @Published var downloadProgress: Double = 0
//    @Published var isDownloading = false
//    @Published var showSuccess:Bool = false
//    @Published var errorMessage: String?
//
//    private var pdfURL: URL?
//
//    func download(from urlString: String) {
//        guard let url = URL(string:Constants.baseURL + urlString) else { return }
//        isDownloading = true
//        downloadProgress = 0
//
//        let fileExtension = url.pathExtension.lowercased()
//        let destination = FileManager.default
//            .temporaryDirectory
//            .appendingPathComponent("downloadedFile.\(fileExtension)")
//
//        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
//            DispatchQueue.main.async {
//                self.isDownloading = false
//            }
//
//            guard let tempURL = tempURL else {
//                DispatchQueue.main.async {
//                    self.errorMessage = error?.localizedDescription ?? "Download failed"
//                }
//                return
//            }
//
//            do {
//                if FileManager.default.fileExists(atPath: destination.path) {
//                    try FileManager.default.removeItem(at: destination)
//                }
//                try FileManager.default.moveItem(at: tempURL, to: destination)
//
//                DispatchQueue.main.async {
//                    self.handleDownloadedFile(destination, fileExtension: fileExtension)
//                }
//
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Failed to move downloaded file: \(error.localizedDescription)"
//                }
//            }
//        }
//
//        task.resume()
//    }
//
//    private func handleDownloadedFile(_ fileURL: URL, fileExtension: String) {
//        if ["jpg", "jpeg", "png", "webp"].contains(fileExtension) {
//            saveImageToPhotos(fileURL)
//        } else if fileExtension == "pdf" {
//            pdfURL = fileURL
//            showPDFPicker()
//        } else {
//            errorMessage = "Unsupported file type"
//        }
//    }
//
//    private func saveImageToPhotos(_ fileURL: URL) {
//        PHPhotoLibrary.requestAuthorization { status in
//            if status == .authorized {
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
//                }) { success, error in
//                    DispatchQueue.main.async {
//                        self.showSuccess = success
//                        if let error = error {
//                            self.errorMessage = error.localizedDescription
//                        }
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Photo access denied"
//                }
//            }
//        }
//    }
//
//    private func showPDFPicker() {
//        guard let pdfURL else { return }
//        DispatchQueue.main.async {
//            let picker = UIDocumentPickerViewController(forExporting: [pdfURL])
//            picker.delegate = self
//            UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
//        }
//    }
//
//    // UIDocumentPickerDelegate
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        errorMessage = "Export cancelled"
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        showSuccess = true
//    }
//}

import SwiftUI
import Photos
import UniformTypeIdentifiers

class FileDownloader: NSObject, ObservableObject, URLSessionDownloadDelegate, UIDocumentPickerDelegate {
    @Published var downloadProgress: Double = 0
    @Published var isDownloading = false
    @Published var showSuccess = false
    @Published var errorMessage: String?

    private var pdfURL: URL?

    private var downloadTask: URLSessionDownloadTask?
    private var session: URLSession!

    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }

    func download(from urlString: String) {
        guard let url = URL(string:Constants.baseURL + urlString) else { return }
        isDownloading = true
        downloadProgress = 0
        showSuccess = false
        errorMessage = nil

        let request = URLRequest(url: url)
        downloadTask = session.downloadTask(with: request)
        downloadTask?.resume()
    }

    // MARK: - URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        DispatchQueue.main.async {
            self.downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        isDownloading = false

        guard let originalURL = downloadTask.originalRequest?.url else { return }
        let fileExtension = originalURL.pathExtension.lowercased()
        let destinationURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("downloadedFile.\(fileExtension)")

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.moveItem(at: location, to: destinationURL)
            handleDownloadedFile(destinationURL, fileExtension: fileExtension)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to move file: \(error.localizedDescription)"
            }
        }
    }

    private func handleDownloadedFile(_ fileURL: URL, fileExtension: String) {
        if ["jpg", "jpeg", "png", "webp"].contains(fileExtension) {
            saveImageToPhotos(fileURL)
        } else if fileExtension == "pdf" {
            pdfURL = fileURL
            showPDFPicker()
        } else {
            errorMessage = "Unsupported file type: \(fileExtension)"
        }
    }

    private func saveImageToPhotos(_ fileURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    self.errorMessage = "Photo access denied"
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
            }) { success, error in
                DispatchQueue.main.async {
                    self.showSuccess = success
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func showPDFPicker() {
        guard let pdfURL else { return }
        DispatchQueue.main.async {
            let picker = UIDocumentPickerViewController(forExporting: [pdfURL])
            picker.delegate = self
            picker.modalPresentationStyle = .formSheet
            UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        errorMessage = "Export cancelled"
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        showSuccess = true
    }
}
