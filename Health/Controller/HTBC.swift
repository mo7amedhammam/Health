//
//  HTBC.swift
//  Health
//
//  Created by Hamza on 01/08/2023.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class HTBC: UITabBarController , UITabBarControllerDelegate {
    
    var middleBtn = UIButton()
//    let loginViewModel = LoginViewModel()

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
//            items[2].image = UIImage(named: "tab3")?.withRenderingMode(.alwaysOriginal)
//            items[2].selectedImage = UIImage(named: "tab3selected")?.withRenderingMode(.alwaysOriginal)
                
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
//            sendPostRequestWithToken(customerDeviceToken: Helper.shared.getFirebaseToken())
//        }
        
    }
    

    
//    func sendPostRequestWithToken(customerDeviceToken: String) {
//        // API endpoint URL
//        let apiUrl = Constants.apiURL + "Customer/UpdateFirebaseDeviceToken?customerDeviceToken=\(customerDeviceToken)"
//        let headers: HTTPHeaders = ["Authorization": "Bearer \(Helper.shared.getUser()?.token ?? "")"]
//        print("url : \(apiUrl)")
//        print("headers : \(headers)")
//        // Sending the POST request
//        AF.request(apiUrl,
//                   method: .post,
//                   parameters: nil,
//                   encoding: JSONEncoding.default,
//                   headers: headers)
//            .responseDecodable(of: ModelResponseFirebase.self) { response in
//                switch response.result {
//                case .success(let value):
//                    // Handle the success case with the decoded value
//                    print("Response value: \(value)")
//                case .failure(let error):
//                    // Handle the failure case with the error
//                    print("Error: \(error)")
//                }
//            }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.appearance().semanticContentAttribute = Helper.shared.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        UIView.appearance().semanticContentAttribute = Helper.shared.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

    }
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame.size.height = UIDevice.current.hasNotch ? 90 : 65
        tabBar.frame.origin.y = view.frame.height - (UIDevice.current.hasNotch ? 75 : 65)
    }
   
}
extension HTBC{
    func setupMiddleButton() {
        middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -25, width: 50, height: 50))
        //STYLE THE BUTTON YOUR OWN WAY
//        middleBtn.backgroundColor = .blue
        middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
//        middleBtn.backgroundColor = UIColor(named: "second")
        middleBtn.setImage(UIImage(named: "tab3"), for: .normal)
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        middleBtn.setImage(UIImage(named: "tab3selected"), for: .normal)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            print("Selected tab bar item at index \(index)")
            // Perform any actions you want in response to the selection
            Hud.dismiss(from: self.view)
            middleBtn.setImage(UIImage(named: "tab3"), for: .normal)
            if index == 2 {
                selectedIndex = 2
                middleBtn.setImage(UIImage(named: "tab3selected"), for: .normal)
            }
        }
    }
}


//@IBDesignable
//class CustomTabBar: UITabBar {
//    private var shapeLayer: CALayer?
//    private func addShape() {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = createPath()
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.lineWidth = 0.5
//        
//        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
//        shapeLayer.shadowOffset = CGSize(width:0, height:0)
//        shapeLayer.shadowRadius = 10
//        shapeLayer.shadowColor = UIColor.gray.cgColor
//        shapeLayer.shadowOpacity = 0.1
//        
//        if let oldShapeLayer = self.shapeLayer {
//            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
//        } else {
//            self.layer.insertSublayer(shapeLayer, at: 0)
//        }
//        self.shapeLayer = shapeLayer
//    }
//    override func draw(_ rect: CGRect) {
//        self.addShape()
//    }
//    func createPath() -> CGPath {
//        let height: CGFloat = 37.0
//        let path = UIBezierPath()
//        let centerWidth = self.frame.width / 2
//        path.move(to: CGPoint(x: 0, y: 0)) // start top left
//        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
//        
//        path.addCurve(to: CGPoint(x: centerWidth, y: height),
//                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
//        
//        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
//        
//        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
//        path.close()
//        
//        return path.cgPath
//    }
//    
//}



@IBDesignable
class CustomTabBar: UITabBar {
    private var shapeLayer: CALayer?
    private let cornerradius: CGFloat = 20.0
//    private let centerCurveHeight: CGFloat = 55
    private let centerButtonWidth: CGFloat = 70
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor.lightGray
        self.tintColor = UIColor(named: "second") // Your selected color
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        
        // Shadow settings
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
        shapeLayer.shadowRadius = 8
        shapeLayer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        shapeLayer.shadowOpacity = 0.5
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        // Start from top-left with corner radius
        path.move(to: CGPoint(x: 0, y: cornerradius))
        path.addArc(withCenter: CGPoint(x: cornerradius, y: cornerradius),
                    radius: cornerradius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)
        
        // Left straight line to the beginning of the center curve
        path.addLine(to: CGPoint(x: centerWidth - centerButtonWidth/2, y: 0))
        
        // Create a perfect semicircle for the center curve
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0),
                    radius: centerButtonWidth/2,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)
        
        // Right straight line to top-right corner
        path.addLine(to: CGPoint(x: self.frame.width - cornerradius, y: 0))
        
        // Top-right corner radius
        path.addArc(withCenter: CGPoint(x: self.frame.width - cornerradius, y: cornerradius),
                    radius: cornerradius,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: true)
        
        // Bottom right
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        
        // Bottom left
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        path.close()
        
        return path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame = self.frame
        tabFrame.size.height = UIDevice.current.hasNotch ? 90 : 70
        tabFrame.origin.y = self.frame.origin.y + (self.frame.height - tabFrame.size.height)
        self.frame = tabFrame
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5) })
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

import SwiftUI
struct MainViewController_Previews: PreviewProvider {

static var previews: some View {
        return ContentView()
    }
    
    struct ContentView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> HTBC {
            return HTBC()
        }
        
        func updateUIViewController(_ uiViewController: HTBC, context: Context) {
            //
        }
    }
}
