//
//  MainBannerTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.02.2024.
//

import UIKit
// MARK: MainBanner TVCell
class MainBannerTableViewCell: UITableViewCell {

    var mainMovie = MainMovie()
    var delegate: MovieProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ._1MainColorFFFFFF111827
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.blue.cgColor
        constraints()
        CVTopLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) hasnt been implement")
        
    }
    
    private lazy var collectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(MainBannerCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor._1MainColorFFFFFF111827

        return cv
    }()
    // MARK: CVCell configuration
    func CVTopLayout() {
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 300
        layout.estimatedItemSize.height = 240
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    // MARK: Constraints
    func constraints() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setData(mainMovie: MainMovie) {
        self.mainMovie = mainMovie
        
        collectionView.reloadData()
    }
    
}

// MARK: Extension TVCell
extension MainBannerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.bannerMovie.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! MainBannerCollectionViewCell
        
        cell.setData(bannerMovie: mainMovie.bannerMovie[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieDidSelect(movie: mainMovie.bannerMovie[indexPath.item].movie)
    }
    
}

// MARK: MainBanner CVCell
extension MainBannerTableViewCell {
    class MainBannerCollectionViewCell: UICollectionViewCell {
        
        var delegate: MovieProtocol?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .clear
//            contentView.layer.borderWidth = 2
//            contentView.layer.borderColor = UIColor.green.cgColor
            constraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let bannerImageView = {
            let iv = UIImageView()
            
            iv.image = UIImage(named: "poster")
            iv.layer.cornerRadius = 8
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            return iv
        }()
        private let titleLabel = {
            let lbl = UILabel()
            
            lbl.text = "Қызғалдақтар мекені"
            lbl.font = .appFont(ofSize: 14, weight: .bold)
            lbl.textColor = UIColor._2MainColor111827FFFFFF
            lbl.numberOfLines = 1
            lbl.textAlignment = .left
            
            return lbl
        }()
        private let descriptionLabel = {
            let lbl = UILabel()
            
            lbl.text = "Шытырман оқиғалы мультсериал Елбасының «Ұлы даланың жеті қыры» бағдарламасы аясында жүз...sdfsdfsd"
            lbl.font = .appFont(ofSize: 12, weight: .regular)
            lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
            lbl.numberOfLines = 2
            lbl.textAlignment = .left
            
            return lbl
        }()
        private let categoryLabel = {
            let lbl = PaddingLabel(withInsets: 4, 4, 8, 8)
            
            lbl.text = "Телехикая"
            lbl.font = .appFont(ofSize: 12, weight: .semiBold)
            lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            lbl.layer.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1).cgColor
            lbl.layer.cornerRadius = 8
            lbl.textAlignment = .center
            
            return lbl
        }()
        // MARK: Constraints
        func constraints() {
            contentView.addSubview(bannerImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(descriptionLabel)
            contentView.addSubview(categoryLabel)
            
            bannerImageView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(164)
            }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(bannerImageView.snp.bottom).offset(16)
                make.horizontalEdges.equalToSuperview()
            }
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            categoryLabel.snp.makeConstraints { make in
                make.top.equalTo(bannerImageView.snp.top).inset(8)
                make.left.equalTo(bannerImageView.snp.left).inset(8)
            }
        }
        
        func setData(bannerMovie: BannerMovie) {
            
            bannerImageView.sd_setImage(with: URL(string: bannerMovie.link))
            
            if let category = bannerMovie.movie.categories.first {
                categoryLabel.text = category.name
            }
            
            titleLabel.text = bannerMovie.movie.name
            descriptionLabel.text = bannerMovie.movie.description
        }
     
        
    }
}
