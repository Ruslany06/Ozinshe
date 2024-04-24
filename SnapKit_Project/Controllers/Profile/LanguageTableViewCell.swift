//
//  LanguageTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.11.2023.
//

import UIKit
import Localize_Swift

class LanguageTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.FFFFFF_1_C_2431
        constraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let languageLabel = {
        let label = UILabel()
        
        label.text = "English"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        label.textColor = UIColor._2MainColor111827FFFFFF
        
        return label
    }()
    
    let checkImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Check")
        
        return image
        
    }()
    
    func constraints() {
        
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

