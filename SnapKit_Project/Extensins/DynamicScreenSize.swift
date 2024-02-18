//
//  DynamicScreenSize.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.02.2024.
//

import UIKit

extension NSObject {
    /// Calculates and returns a dynamic value based on the provided size that scales proportionally to the current device's screen size.
    ///
    /// - Parameters:
    ///   - size: The initial size value to be dynamically adjusted.
    ///
    /// - Returns: A CGFloat value adjusted based on the current device's screen size.
    func dynamicValue(for size: CGFloat) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let baseScreenSize = CGSize(width: 375, height: 812)
        let scaleFactor = min(screenSize.width, screenSize.height) / min(baseScreenSize.width, baseScreenSize.height)

        return size * scaleFactor
    }
}
