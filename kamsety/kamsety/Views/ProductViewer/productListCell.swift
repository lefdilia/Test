//
//  productListCell.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 30/3/2022.
//

import UIKit


class ProductListCell: UICollectionViewCell {
    
    static var cellId = "ProductCellId"

    var productImage: UIImage? {
        didSet {
            guard let productImage = productImage else {
                return
            }
            productImageView.image = productImage
        }
    }
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var productImageViewLayout: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubview(productImageView)
    
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
          
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
