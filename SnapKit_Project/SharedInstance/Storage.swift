//
//  Storage.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 19.11.2023.
//

import Foundation
import UIKit

class Storage {
    public var accessToken: String = ""
    
    static let sharedInstance = Storage()
    
    public var avatarImage: Data = Data()
    
    public var themeKey: String = ""

}
