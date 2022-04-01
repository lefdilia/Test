//
//  BagViewerListCell.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 31/3/2022.
//

import UIKit

class BagViewerListCell: UITableViewCell {
    
    static var cellId = "bagCellId"

    var product: Product? {
        didSet{
            //
            guard let product = product else {
                return
            }

            productTile.attributedText = NSAttributedString(string: product.title, attributes: [
                .font: UIFont(name: Theme.keplerBold, size: 26) as Any,
                .foregroundColor: UIColor.black
            ])
            
            productBrand.attributedText = NSAttributedString(string: product.brand, attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor.black
            ])
                    
            let price = "\(product.infos.currency.rawValue) \(product.infos.price)"
            productPrice.attributedText = NSAttributedString(string: price, attributes: [
                .font: UIFont(name: Theme.AldusRoman, size: 20) as Any,
                .foregroundColor: UIColor.black
            ])
            
            if let image = product.infos.images.first {
                productImageView.image = UIImage(named: image)
            }
        }
    }

    let productImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red.withAlphaComponent(0.3)
        
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productTile: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productBrand: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addSubview(productImageView)
        addSubview(productTile)
        addSubview(productBrand)
        addSubview(productPrice)
        
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            productImageView.widthAnchor.constraint(equalToConstant: 60),

            productTile.topAnchor.constraint(equalTo: productImageView.topAnchor),
            productTile.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),

            productBrand.topAnchor.constraint(equalTo: productTile.bottomAnchor, constant: 10),
            productBrand.leadingAnchor.constraint(equalTo: productTile.leadingAnchor),
            
            productPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            productPrice.centerYAnchor.constraint(equalTo: productTile.centerYAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
