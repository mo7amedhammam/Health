//
//  SplashScreenVC.swift
//  Health
//
//  Created by Hamza on 28/07/2023.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    @IBOutlet weak var CollectionSplash: UICollectionView!
    @IBOutlet var pageControl: CustomPageControl!
    @IBOutlet var MoveButton: UIButton!
    
    var currentPage: Int = 0{
        didSet {
            pageControl.numberOfPages = 3
            pageControl.currentPage = currentPage
            MoveButton.setTitle(currentPage == 2 ? "تم":"التالى", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        CollectionSplash.dataSource = self
        CollectionSplash.delegate = self
        CollectionSplash.isPagingEnabled = true
        
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell1.self)
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell2.self)
        CollectionSplash.registerCell(cellClass: SplashScreenTVCell3.self)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        CollectionSplash.setCollectionViewLayout(layout, animated: true)
        
        CollectionSplash.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        CollectionSplash.reloadData()
//        CollectionSplash.isUserInteractionEnabled = false
        // Configure the page control
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        // Adjust the frame of the page control
        let pageControlWidth: CGFloat = 200
        let pageControlHeight: CGFloat = 20
        let pageControlX = (view.bounds.width - pageControlWidth) / 2
        let pageControlY = view.bounds.height - 100 // Adjust the vertical position as needed
        pageControl.frame = CGRect(x: pageControlX, y: pageControlY, width: pageControlWidth, height: pageControlHeight)
        pageControl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
    }
    
}


extension SplashScreenVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    
    func SkipSplash() {
        Helper.shared.onBoardOpened(opened: true)
        Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell1", for: indexPath) as! SplashScreenTVCell1
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell2", for: indexPath) as! SplashScreenTVCell2
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
            
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenTVCell3", for: indexPath) as! SplashScreenTVCell3
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //here your custom value for spacing
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / CollectionSplash.frame.size.width)
        currentPage = Int(pageIndex) // Update the currentPage property
    }
    
    
    // MARK: Actions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentPage == 2{
            SkipSplash()
        }else{
            let indexPath = IndexPath(item: currentPage+1, section: 0)
            CollectionSplash.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)
        }
        currentPage += 1 // Update the currentPage property

    }
    
    
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        SkipSplash()
    }
    
    
}


class CustomPageControl: UIView {
    let indicatorSize: CGSize = CGSize(width: 6.0, height: 6.0)
    let currentIndicatorWidth: CGFloat = 16.0
    let indicatorSpacing: CGFloat = 6.0
    let currentIndicatorColor: UIColor = UIColor(named: "main") ?? .red
    let indicatorColor: UIColor = UIColor.lightGray
    
    var numberOfPages: Int = 0 {
        didSet {
            setupIndicators()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }
    
    private var indicators: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndicators()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupIndicators()
    }
    
    private func setupIndicators() {
        // Remove existing indicators
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        
        // Create indicators
        for _ in 0..<numberOfPages {
            let indicatorView = UIView()
            indicatorView.backgroundColor = indicatorColor
            indicators.append(indicatorView)
            addSubview(indicatorView)
        }
        
        updateIndicators()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalWidth = CGFloat(numberOfPages - 1) * (indicatorSize.width + indicatorSpacing) + currentIndicatorWidth
        let startX = (bounds.width - totalWidth) / 2
        
        var xOffset = startX
        
        for (index, indicatorView) in indicators.enumerated() {
            let width = index == currentPage ? currentIndicatorWidth : indicatorSize.width
            indicatorView.frame = CGRect(x: xOffset, y: (bounds.height - indicatorSize.height) / 2, width: width, height: indicatorSize.height)
            indicatorView.layer.cornerRadius = indicatorSize.height / 2
            
            xOffset += width + indicatorSpacing
        }
    }
    
    private func updateIndicators() {
        for (index, indicatorView) in indicators.enumerated() {
            indicatorView.backgroundColor = indicatorColor
        }
        
        if currentPage < indicators.count {
            let currentIndicatorView = indicators[currentPage]
            currentIndicatorView.backgroundColor = currentIndicatorColor
        }
    }
}
