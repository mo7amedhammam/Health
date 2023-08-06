//
//  UITableView+Extensions.swift
//  Memoria
//
//  Created by mac on 07/04/2021.
//
import Foundation
import UIKit

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }


    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
        
}
extension String{    
    func openWhatsApp() {
        var fullMob = self
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let appURL = NSURL(string: "whatsapp://send?phone=\(fullMob)")!
        
        let webURL = NSURL(string: "https://web.whatsapp.com/send?phone=\(fullMob)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
            print(appURL)
        } else {
            // if GoogleMaps app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
}
