//
//  FriendsTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 29.11.2023.
//

import UIKit
import SnapKit

class FriendsTableViewCell: UITableViewCell {
    
    let AvatarImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "DefaultAvatar")
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 8
        
        return iv
    }()
    
    let titleLabel1 = {
        let label = UILabel()
        
        label.text = "Досым"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor =  UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        return label
    }()
    
    let subtitleLabel1 = {
        let label = UILabel()
        
        label.text = "Last messgae"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        label.textColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        return label
    }()
    
    let WriteView = {
        let view = UIView()
        let imageView = UIImageView()
        let label = UILabel()
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.93, blue: 1, alpha: 1)
        view.layer.cornerRadius = 8
        
        imageView.image = UIImage(named: "Write")
        
        label.text = "Жазу"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        label.textColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(4)
            make.size.equalTo(20)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(4)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview().inset(12)
        }
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        UISettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) hasnt been implement")
    }
    
    func UISettings() {
        contentView.addSubview(AvatarImageView)
        
        AvatarImageView.snp.makeConstraints{ make in
//            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(22)
            make.size.equalTo(70)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(titleLabel1)
        titleLabel1.snp.makeConstraints { make in
            make.left.equalTo(AvatarImageView.snp.right).offset(17)
            make.top.equalToSuperview().inset(22)
        }
        
        contentView.addSubview(subtitleLabel1)
        subtitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(8)
            make.left.equalTo(titleLabel1)
        }
        contentView.addSubview(WriteView)
        WriteView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalToSuperview().inset(16)
//            make.top.equalTo(subtitleLabel1.snp.bottom).offset(24)
//            make.height
//            make.width
        }
    }
}
