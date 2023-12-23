//
//  DataModels.swift
//  spaarksTask
//
//  Created by Tirumala on 01/12/23.
//

import Foundation


struct ShopDataModels: Codable {
    
    let image: String?
       let price: Double
       let productName, productType: String
       let tax: Double

       enum CodingKeys: String, CodingKey {
           case image, price
           case productName = "product_name"
           case productType = "product_type"
           case tax
       }
   }
//    let id: Int
//    let title: String
//    let price: Double
//    let description: String
//    let category: Category
//    let image: String?
//    let rating: Rating
//}
//
//enum Category: String, Codable {
//    case electronics = "electronics"
//    case jewelery = "jewelery"
//    case menSClothing = "men's clothing"
//    case womenSClothing = "women's clothing"
//}
//
//// MARK: - Rating
//struct Rating: Codable {
//    let rate: Double
//    let count: Int
//}

typealias Welcome = [ShopDataModels]


struct ProductAdded:Codable{
    let message: String
      let productDetails: ProductDetails
      let productID: Int
      let success: Bool

      enum CodingKeys: String, CodingKey {
          case message
          case productDetails = "product_details"
          case productID = "product_id"
          case success
      }
  }

  // MARK: - ProductDetails
  struct ProductDetails: Codable {
      let image: String
      let price: Int
      let productName, productType: String
      let tax: Int

      enum CodingKeys: String, CodingKey {
          case image, price
          case productName = "product_name"
          case productType = "product_type"
          case tax
      }
  }


