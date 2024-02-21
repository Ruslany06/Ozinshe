//
//  URLs.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.11.2023.
//

import Foundation

class URLs {
    
    static let BASE_URL = "http://api.ozinshe.com/core/V1/"
    
    static let SIGN_IN_URL = "http://api.ozinshe.com/auth/V1/signin"
    static let FAVORITES_URL = BASE_URL + "favorite/"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES_BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let SIGN_UP_URL = BASE_URL + "signup"
    
}
