//
//  DataModels.swift
//  spaarksTask
//
//  Created by Tirumala on 01/12/23.
//

import Foundation


struct ShopDataModels: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String?
    let rating: Rating
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}

typealias Welcome = [ShopDataModels]
