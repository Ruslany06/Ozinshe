//
//  LanguageTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.11.2023.
//

import UIKit
import Localize_Swift

class LanguageTableViewCell: UITableViewCell {
    
    let languageLabel = {
        let label = UILabel()
        
        label.text = "English"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    
    let checkImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Check")
        
        return image
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        UISettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func UISettings() {
        
        contentView.addSubview(languageLabel)
        contentView.addSubview(checkImageView)
    
        languageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(contentView)
        }
        checkImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(contentView)
        }
    
    }
    
}

