//
//  ExtentionLocalize.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//

import UIKit
import AVFoundation

extension String {
    
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self , tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}


