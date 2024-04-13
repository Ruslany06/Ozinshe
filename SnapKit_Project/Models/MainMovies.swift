//
//  MainMovies.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 22.02.2024.
//

import Foundation
import SwiftyJSON

enum CellType {
    case mainBanner
    case mainMovie
    case userHistory
    case genre
    case ageCategory
}

class MainMovie {
    
    var cellType: CellType = .mainMovie
    
    var categoryId = 0
    var categoryName = ""
    var movies: [Movie] = []
    var bannerMovie: [BannerMovie] = []
    var genres: [Genre] = []
    var categoryAges: [CategoryAge] = []
    
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["categoryId"].int {
            categoryId = temp
        }
        if let temp = json["categoryName"].string {
            categoryName = temp
        }
        if let array = json["movies"].array {
            for item in array {
                let temp = Movie(json: item)
                movies.append(temp)
            }
        }
    }
}
