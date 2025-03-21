//
//  HTBC.swift
//  Health
//
//  Created by Hamza on 01/08/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class HTBC: UITabBarController  , UITabBarControllerDelegate {
    
    var middleBtn = UIButton()
    let loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = tabBar.items {
            items[0].title = ""
            items[0].image = UIImage(named: "tab1")
            items[0].selectedImage = UIImage(named: "tab1selected")?.withRenderingMode(.alwaysOriginal)

            items[1].title = ""
            items[1].image = UIImage(named: "tab2")
            items[1].selectedImage = UIImage(named: "tab2selected")?.withRenderingMode(.alwaysOriginal)
            
            items[2].title = ""
            items[2].image = UIImage(named: "tab3")
            items[2].selectedImage = UIImage(named: "")
            
            items[3].title = ""
            items[3].image = UIImage(named: "tab4")
            items[3].selectedImage = UIImage(named: "tab4selected")?.withRenderingMode(.alwaysOriginal)
            
            items[4].title = ""
            items[4].image = UIImage(named: "tab5")
            items[4].selectedImage = UIImage(named: "tab5selected")?.withRenderingMode(.alwaysOriginal)
                  // Add more items as needed
              }
        
        self.delegate = self
        setupMiddleButton()
        selectedIndex = 4
        
        
//        if Shared.shared.NewFirebaseToken == true {
//            Shared.shared.NewFirebaseToken = false
            sendPostRequestWithToken(customerDeviceToken: Helper.shared.getFirebaseToken())
//        }
        
    }
    

    
    func sendPostRequestWithToken(customerDeviceToken: String) {
        // API endpoint URL
        let apiUrl = Constants.apiURL + "Customer/UpdateFirebaseDeviceToken?customerDeviceToken=\(customerDeviceToken)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Helper.shared.getUser()?.token ?? "")"]
        print("url : \(apiUrl)")
        print("headers : \(headers)")
        // Sending the POST request
        AF.request(apiUrl,
                   method: .post,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseDecodable(of: ModelResponseFirebase.self) { response in
                switch response.result {
                case .success(let value):
                    // Handle the success case with the decoded value
                    print("Response value: \(value)")
                case .failure(let error):
                    // Handle the failure case with the error
                    print("Error: \(error)")
                }
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame.size.height = UIDevice.current.hasNotch ? 90 : 65
        tabBar.frame.origin.y = view.frame.height - (UIDevice.current.hasNotch ? 75 : 65)
    }
 
    func setupMiddleButton() {
        middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
        //STYLE THE BUTTON YOUR OWN WAY
        middleBtn.backgroundColor = .blue
        middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
//        middleBtn.backgroundColor = UIColor(named: "second")
        middleBtn.setImage(UIImage(named: "btnCenter"), for: .normal)
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        middleBtn.setImage(UIImage(named: "btnCenterSelected"), for: .normal)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            print("Selected tab bar item at index \(index)")
            // Perform any actions you want in response to the selection
            Hud.dismiss(from: self.view)
            middleBtn.setImage(UIImage(named: "btnCenter"), for: .normal)
            if index == 2 {
                selectedIndex = 2
                middleBtn.setImage(UIImage(named: "btnCenterSelected"), for: .normal)
            }
        }
    }
    
}


@IBDesignable
class CustomTabBar: UITabBar {
    private var shapeLayer: CALayer?
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
