//
//  product.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 30/3/2022.
//

import Foundation

enum Currency: String, Codable {
    case Euro = "€"
    case Dollar = "$"
}

struct Product: Codable {
    let title: String
    let Description: String
    let brand: String
    let infos: ProductInfo
    let added: Date
}

// MARK: - Info
struct ProductInfo: Codable {
    let colors: [String]
    let images: [String]
    let price: String
    let currency: Currency
}

struct APIManager {
    
    init(){}
    static let shared = APIManager()
    
    func listProducts() -> [Product] {
        
        let products = [
            Product(title: "Work Lamp", Description: "Work lamp with LED bulb", brand: "NYFORS", infos:
                        ProductInfo( colors: [
                            "484745",
                            "7D7553",
                            "A26F0F",
                            "F1EBDB",
                        ], images: [
                            "s6",
                            "s6",
                            "s6",
                            "s6",
                        ], price: "120", currency: .Euro), added: Date()),
            
            Product(title: "Mini speaker", Description: "Work lamp with LED bulb", brand: "FORSA", infos:
                        ProductInfo(colors: [
                            "484745",
                            "7D7553",
                            "A26F0F",
                            "F1EBDB",
                        ], images: [
                            "s6",
                            "s6",
                            "s6",
                            "s6",
                        ], price: "230", currency: .Euro), added: Date())
        ]
        
        return products
    }

}



/*
 {
   "products": [
         {
           "title": "Work lamp",
           "description": "Work lamp width led buld",
           "brand": "Nyfors",
           "infos": {
             "color": "484745",
             "images": [
               "1.png",
               "2.png",
               "3.png"
             ],
             "price": "120",
             "currency": "euro"
           },
           "added": "2022-03-30T15:00:04.1370000"
         }
 ]
 */
