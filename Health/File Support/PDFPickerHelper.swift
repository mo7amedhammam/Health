//
//  PDFPickerHelper.swift
//  Health
//
//  Created by wecancity on 12/09/2023.
//

import UIKit

class PDFPickerHelper: NSObject, UIDocumentPickerDelegate {
    
    private var viewController: UIViewController
    private var pdfPickedCallback: ((URL?) -> Void)?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func showPDFPicker(completion: @escaping (URL?) -> Void) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        viewController.present(documentPicker, animated: true, completion: nil)
        
        // Set the callback to be executed when a PDF file is picked
        self.pdfPickedCallback = completion
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let pdfURL = urls.first
        pdfPickedCallback?(pdfURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        pdfPickedCallback?(nil)
    }
}
