//
//  UIFont.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 19.02.2024.
//

import UIKit

extension UIFont {
    public enum FontWeights: String {
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case bold = "Bold"
    }
    
    private static let appFontName = "SFProDisplay"
    
    public static func appFont(ofSize size: Double, weight: FontWeights) -> UIFont {
        guard let font = UIFont(name: "\(appFontName)-\(weight.rawValue)", size: size) else {
            fatalError("Font not found!")
        }
        
        return font
    }
}
