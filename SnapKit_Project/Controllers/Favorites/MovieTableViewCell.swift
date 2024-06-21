//
//  MovieTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 07.11.2023.
//

import UIKit
import SnapKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor._1MainColorFFFFFF111827
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) hasnt been implement")
        
    }
    
    let posterImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "poster")
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 8
        
        return iv
    }()
    
    let titleLabel = {
        let label = UILabel()
        
        label.text = "Қызғалдақтар мекені"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor =  UIColor._2MainColor111827FFFFFF
        return label
    }()
    
    let subtitleLabel = {
        let label = UILabel()
        
        label.text = "2020 • Телехикая • Мультфильм мекені"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        label.textColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        return label
    }()
    
    let playLabel: UILabel = {
            let label = UILabel()
            label.text = "PLAY".localized()
            label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
            label.textColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1)
            return label
        }()
    lazy var playView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        
        view.addSubview(imageView)
        view.addSubview(playLabel)
        
        view.backgroundColor = UIColor.playBtnColor1C2431F8EEFF
        view.layer.cornerRadius = 8
        
        imageView.image = UIImage(named: "PlayIcon")
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(4)
            make.size.equalTo(16)
        }
        playLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(4)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview().inset(12)
        }
        
        return view
    }()
    func constraints() {
        contentView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(dynamicValue(for: 24))
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 104))
            make.width.equalTo(dynamicValue(for: 71))
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(dynamicValue(for: 17))
            make.top.equalToSuperview().inset(dynamicValue(for: 24))
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(dynamicValue(for: 8))
            make.left.equalTo(titleLabel)
        }
        contentView.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(dynamicValue(for: 17))
            make.top.equalTo(subtitleLabel.snp.bottom).offset(dynamicValue(for: 24))
        }
    }
// MARK: Functions
    func setData(movie: Movie) {
        titleLabel.text = movie.name
        subtitleLabel.text = "\(movie.year)"

        for item in movie.genres {
            subtitleLabel.text = subtitleLabel.text! + " • " + item.name
        }
        
        posterImageView.sd_setImage(with: URL(string: movie.poster_link))
    
    }
    
}
