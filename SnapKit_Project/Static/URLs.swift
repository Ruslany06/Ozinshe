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
    static let ADD_FAVORITES_URL = BASE_URL + "favorite"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES_BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let SIGN_UP_URL = BASE_URL + "signup"
    static let MAIN_MOVIES_URL = BASE_URL + "movies/main"
    static let GENRES_URL = BASE_URL + "genres"
    static let CATEGORY_AGES_URL = BASE_URL + "category-ages"
    static let MAIN_BANNERS_URL = BASE_URL + "movies_main"
    static let HISTORY_URL = BASE_URL + "history/userHistory"
    static let SIMILAR_MOVIES = BASE_URL + "movies/similar/"
    static let GET_SEASONS_URL = BASE_URL + "seasons/"
}
