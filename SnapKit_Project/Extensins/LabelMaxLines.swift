//
//  LabelMaxLines.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 08.03.2024.
//

import UIKit

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        let result = Int(ceil(textHeight / lineHeight))
        
        return Int(ceil(textHeight / lineHeight))
    }
}
