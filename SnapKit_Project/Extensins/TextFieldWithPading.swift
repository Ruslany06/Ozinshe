//
//  TextFieldWithPading.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 22.11.2023.
//

import UIKit

class TextFieldWithPadding: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
//    var padding: UIEdgeInsets
        
//        init(padding: UIEdgeInsets) {
//            self.padding = padding
//            super.init(frame: .zero)
//            
//        }
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
