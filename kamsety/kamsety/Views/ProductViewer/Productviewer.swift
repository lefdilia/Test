//
//  Productviewer.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 30/3/2022.
//

import UIKit

class Productviewer: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var product: Product? = APIManager.shared.listProducts().first
    lazy var productImages: [UIImage] = product?.infos.images.map({ UIImage(named: $0) }) as! [UIImage]
    lazy var productAvailableColors: [UIColor] = product?.infos.colors.map({ UIColor($0) }) as! [UIColor]
    
    //MARK: - Top Header (StackView)
    let brandLogoLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let logoAttributedText = NSAttributedString(string: "Kamsety", attributes: [
            .font: UIFont(name: Theme.keplerBold, size: 30) as Any,
            .foregroundColor: UIColor.black,
            .kern: 0.3
        ])
        
        let logoTradeMarkAttributedText = NSAttributedString(string: "®", attributes: [
            .font: UIFont(name: Theme.registredTradeMark, size: 30) as Any,
            .foregroundColor: UIColor.black
        ])
        
        attributedString.append(logoAttributedText)
        attributedString.append(logoTradeMarkAttributedText)
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .custom)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.baseForegroundColor = .black
            configuration.imagePlacement = .leading
            button.configuration = configuration
        }else{
            button.tintColor = .black
            button.contentHorizontalAlignment = .leading
            button.contentEdgeInsets.left = 10
        }
        
        button.tintColor = .clear
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.setImage(UIImage(named: "close"), for: .selected)
        
        button.addTarget(self, action: #selector(didTapCollapsedMenu), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "shopping-cart-trimed")
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = image
            configuration.titleAlignment = .center
            configuration.imagePlacement = .trailing
            button.configuration = configuration
        }else{
            button.setImage(image, for: .normal)
            button.tintColor = .black
            button.contentHorizontalAlignment = .trailing
            button.contentEdgeInsets.right = 10
        }
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapShoppingCart), for: .touchUpInside)
        return button
    }()
    
    lazy var topViews: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [menuButton, brandLogoLabel, cartButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Top Header: Product Images (CollectionView)
    lazy var productImageList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    //MARK: - PageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = productImages.count

        if #available(iOS 14.0, *) {
            pageControl.currentPageIndicatorTintColor = .black.withAlphaComponent(0.8)
            pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.6)
            pageControl.setIndicatorImage(UIImage(named: "CurrentPage"), forPage: 0)
            pageControl.preferredIndicatorImage = UIImage(named: "Page-Line")
            pageControl.transform = CGAffineTransform(rotationAngle: .pi/2).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
        }else{
            pageControl.transform = CGAffineTransform(rotationAngle: .pi/2)
        }
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let pageControleHolder: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    //MARK: - Description
    let productBrand: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var saveProductToFavorite: UIButton = {
        let button = UIButton(type: .custom)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.titleAlignment = .center
            configuration.imagePlacement = .trailing
            button.configuration = configuration
        }else{
            button.tintColor = .black
            button.contentHorizontalAlignment = .trailing
            button.contentEdgeInsets.right = 10
        }
        
        button.tintColor = .clear
        button.addTarget(self, action: #selector(didTapSaveToFavorite(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart-selected"), for: .selected)
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var listOfButtons: [UIButton] = []
    var selectedColor: Int = 0
    
    lazy var productColors: UIStackView = { [weak self] in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 10
        
        let HWSize = 40.0
        
        for (index, color) in productAvailableColors.enumerated() {
            let _button = UIButton(type: .custom)
            
            _button.accessibilityLabel = "productColor"
            _button.translatesAutoresizingMaskIntoConstraints = false
            
            _button.heightAnchor.constraint(equalToConstant: HWSize).isActive = true
            _button.widthAnchor.constraint(equalToConstant: HWSize).isActive = true
            
            _button.clipsToBounds = true
            _button.backgroundColor = color
            _button.layer.cornerRadius = HWSize/2
            _button.layer.masksToBounds = true
            _button.layer.borderWidth = 2
            _button.layer.borderColor = UIColor.productColorBorder.cgColor
            
            
            if index == selectedColor {
                _button.layer.borderWidth = 2
                _button.setImage(UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            }
            
            _button.tag = index
            _button.addTarget(self, action: #selector(self?.didChangeColor(_:)), for: .touchUpInside)
            
            self?.listOfButtons.append(_button)
            stack.addArrangedSubview(_button)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var addToBagButton: UIButton = { [weak self] in
        let button = UIButton(type: .custom)
        
        let title = "Add to bag"
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .buttonBackgroundColor
            
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.CenturyGothicBold, size: 17)
            configuration.attributedTitle = AttributedString("\(title)", attributes: container)
            configuration.buttonSize = .large
            button.configuration = configuration
        }else{
            let attributedText = NSAttributedString(string: "\(title)", attributes: [
                .font : UIFont(name: Theme.CenturyGothicBold, size: 17) as Any,
                .foregroundColor : UIColor.white
            ])
            button.backgroundColor = .buttonBackgroundColor
            button.setAttributedTitle(attributedText, for: .normal)
            button.layer.cornerRadius = 8
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        }
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self?.didTapAddToBag), for: .touchUpInside)
        return button
    }()
    
    let cartBadge: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        label.backgroundColor = .black
        label.layer.cornerRadius = 9
        
        label.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        label.layer.borderWidth = 1
        
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "1"
        label.textColor = .white
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Functions
    var inProgress: Bool = false
    @objc func didTapAddToBag(){
        
        if inProgress == true {  return }
        
        inProgress = true
        if #available(iOS 15.0, *) {
            var configuration = addToBagButton.configuration
            configuration?.showsActivityIndicator = true
            configuration?.attributedTitle = nil
            
            addToBagButton.configuration = configuration
            addToBagButton.setNeedsUpdateConfiguration()
        }else{
            let attributedText = NSAttributedString(string: "Please wait...", attributes: [
                .font : UIFont(name: Theme.CenturyGothicBold, size: 17) as Any,
                .foregroundColor : UIColor.white
            ])
            addToBagButton.setAttributedTitle(attributedText, for: .normal)
            addToBagButton.layoutIfNeeded()
        }
        
        
        //MARK: - Update Cart Items
        if let text = cartBadge.text, let number = Int(text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.cartBadge.text = "\(number+1)"
                self.cartBadge.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            } completion: { _ in
                self.cartBadge.transform = .identity
            }
        }
        
        //MARK: - Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.inProgress = false
            
            if #available(iOS 15.0, *) {
                var configuration = self?.addToBagButton.configuration
                var container = AttributeContainer()
                container.font = UIFont(name: Theme.CenturyGothicBold, size: 17)
                configuration?.attributedTitle = AttributedString("Add to bag", attributes: container)
                configuration?.showsActivityIndicator = false
                
                self?.addToBagButton.configuration = configuration
                self?.addToBagButton.setNeedsUpdateConfiguration()
            }else{
                let attributedText = NSAttributedString(string: "Add to bag", attributes: [
                    .font : UIFont(name: Theme.CenturyGothicBold, size: 17) as Any,
                    .foregroundColor : UIColor.white
                ])
                self?.addToBagButton.setAttributedTitle(attributedText, for: .normal)
                self?.addToBagButton.layoutIfNeeded()
            }
            
            let bagModal = BagViewer()
            bagModal.modalPresentationStyle = .overFullScreen
            bagModal.modalTransitionStyle = .coverVertical
            
            self?.present(bagModal, animated: true, completion: nil)
        }
    }
    
    @objc func didChangeColor(_  sender: UIButton){
        
        for button in listOfButtons { button.setImage(nil, for: .normal) }
        
        selectedColor = sender.tag
        sender.setImage(UIImage(systemName: "checkmark")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.white), for: .normal)
    }
    
    //MARK: - Setup Views
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let product = product else {
            return
        }
        
        productBrand.attributedText = NSAttributedString(string: product.brand, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),.foregroundColor: UIColor.black
        ])
        
        productDescription.attributedText = NSAttributedString(string: product.Description, attributes: [
            .font: UIFont(name: Theme.keplerBold, size: 28) as Any,
            .foregroundColor: UIColor.black,
            .kern: 1
        ])
        
        let price = "\(product.infos.currency.rawValue)\(product.infos.price)"
        productPrice.attributedText = NSAttributedString(string: price, attributes: [
            .font: UIFont(name: Theme.AldusRoman, size: 20) as Any,
            .foregroundColor: UIColor.black
        ])
        
        cartButton.addSubview(cartBadge)
        NSLayoutConstraint.activate([
            cartBadge.bottomAnchor.constraint(equalTo: cartButton.topAnchor, constant: 18),
            cartBadge.leadingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: -14),
            cartBadge.heightAnchor.constraint(equalToConstant: 18),
            cartBadge.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(productImageList)
        view.addSubview(topViews)
        
        view.addSubview(pageControleHolder)
        pageControleHolder.addSubview(pageControl)
        
        view.addSubview(productBrand)
        view.addSubview(productDescription)
        view.addSubview(productPrice)
        view.addSubview(saveProductToFavorite)
        
        view.addSubview(productColors)
        view.addSubview(addToBagButton)

        NSLayoutConstraint.activate([
            
            productImageList.topAnchor.constraint(equalTo: view.topAnchor),
            productImageList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageList.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            topViews.topAnchor.constraint(equalTo: productImageList.topAnchor),
            topViews.leadingAnchor.constraint(equalTo: productImageList.leadingAnchor),
            topViews.trailingAnchor.constraint(equalTo: productImageList.trailingAnchor),
            topViews.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: pageControleHolder.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: pageControleHolder.centerYAnchor),
            pageControleHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
            pageControleHolder.centerYAnchor.constraint(equalTo: productImageList.centerYAnchor, constant: 0.0),
            pageControleHolder.widthAnchor.constraint(equalTo: pageControl.heightAnchor),
            pageControleHolder.heightAnchor.constraint(equalTo: pageControl.widthAnchor),
            
            productBrand.topAnchor.constraint(equalTo: productImageList.bottomAnchor, constant: 20),
            productBrand.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            saveProductToFavorite.centerYAnchor.constraint(equalTo: productBrand.centerYAnchor),
            saveProductToFavorite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            productDescription.topAnchor.constraint(equalTo: productBrand.bottomAnchor, constant: 15),
            productDescription.leadingAnchor.constraint(equalTo: productBrand.leadingAnchor),
            
            productPrice.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 10),
            productPrice.leadingAnchor.constraint(equalTo: productBrand.leadingAnchor),
            
            productColors.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 22),
            productColors.leadingAnchor.constraint(equalTo: productPrice.leadingAnchor),
            productColors.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            addToBagButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToBagButton.leadingAnchor.constraint(equalTo: productColors.leadingAnchor),
            addToBagButton.trailingAnchor.constraint(equalTo: saveProductToFavorite.trailingAnchor),
            addToBagButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }

}

extension Productviewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.cellId, for: indexPath) as! ProductListCell
        
        let productImage = productImages[indexPath.item]
        cell.productImage = productImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let currentPage = Int(x /  view.frame.width)
        
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "dot"), forPage: pageControl.currentPage)
        }
        
        pageControl.currentPage = currentPage
        
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "CurrentPage"), forPage: currentPage)
        }
    }
}

//MARK: - Functions
extension Productviewer {
    @objc func didTapSaveToFavorite(_ sender: UIButton){
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            sender.isSelected.toggle()
            if sender.isSelected == true {
                sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        } completion: { _ in
            sender.transform = .identity
        }
        
        //Save (Userdefaults || Coredata)
    }
    
    @objc func didTapShoppingCart(){
        //Check Cart Items
        
        let bagModal = BagViewer()
        bagModal.modalPresentationStyle = .overFullScreen
        bagModal.modalTransitionStyle = .coverVertical
        self.present(bagModal, animated: true, completion: nil)
    }
    
    @objc func didTapCollapsedMenu(_ sender: UIButton){
        //Animated Collapsed Menu
        if #available(iOS 14.0, *) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                sender.isSelected.toggle()
                if sender.isSelected == true {
                    sender.transform = CGAffineTransform(rotationAngle: .pi)
                }
            } completion: { _ in
                sender.transform = .identity
            }
        }
    }
}
