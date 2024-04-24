//
//  HomeTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 22.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        attributes?
            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                guard $1.representedElementCategory == .cell else { return $0 }
                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                }
            }
            .values.forEach { minY, line in
                line.forEach {
                    $0.frame = $0.frame.offsetBy(
                        dx: 0,
                        dy: minY - $0.frame.origin.y
                    )
                }
            }
        
        return attributes
    }
}

protocol MovieProtocol {
    func movieDidSelect (movie: Movie)
}

// MARK: Home TVCell
class HomeTableViewCell: UITableViewCell {
    
    var mainMovies = MainMovie()
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
    
    lazy var collectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
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
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    let categoryTitleLabel = {
        let lbl = UILabel()
        
        lbl.text = "Трендтегілер"
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        lbl.numberOfLines = 2
        
        return lbl
    }()
    let expandLabel = {
        let lbl = UILabel()
        
        lbl.text = "Барлығы"
        lbl.font = .appFont(ofSize: 14, weight: .semiBold)
        lbl.textColor = UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1)
        
        return lbl
    }()
    // MARK: Constraints
    func constraints() {
        contentView.addSubview(collectionView)
        contentView.addSubview(categoryTitleLabel)
        contentView.addSubview(expandLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(expandLabel.snp.left).inset(10)
        }
        expandLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.right.equalToSuperview().inset(24)
        }
    }
    
    func setData(mainMovie: MainMovie) {
        
        categoryTitleLabel.text = mainMovie.categoryName
        self.mainMovies = mainMovie
        
        collectionView.reloadData()
    }
}
    // MARK: Extension TVCell
    extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovies.movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.setData(movie: mainMovies.movies[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieDidSelect(movie: mainMovies.movies[indexPath.item])
    }
    
}

// MARK: Home CVCell
extension HomeTableViewCell {
    class HomeCollectionViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .clear
//            contentView.layer.borderWidth = 2
//            contentView.layer.borderColor = UIColor.green.cgColor
            constraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        private let posterImageView = {
            let iv = UIImageView()
            
            iv.image = UIImage(named: "poster")
            iv.layer.cornerRadius = 8
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            return iv
        }()
        private let nameLabel = {
            let lbl = UILabel()
            
            lbl.text = "Суперкөлік Самұрық"
            lbl.font = .appFont(ofSize: 12, weight: .semiBold)
            lbl.textColor = UIColor._2MainColor111827FFFFFF
            lbl.numberOfLines = 2
            lbl.textAlignment = .left
            
            return lbl
        }()
        private let categoryLabel = {
            let lbl = UILabel()
            
            lbl.text = "Мультсериал"
            lbl.font = .appFont(ofSize: 12, weight: .regular)
            lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
            lbl.textAlignment = .left
            
            return lbl
        }()
        
// MARK: Constraints
        func constraints() {
            contentView.addSubview(posterImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(categoryLabel)
            
            posterImageView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(112)
                make.height.equalTo(164)
            }
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(posterImageView.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview()
            }
            categoryLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        func setData(movie: Movie) {
            
            posterImageView.layer.cornerRadius = 8
            posterImageView.sd_setImage(with: URL(string: movie.poster_link))
            
            nameLabel.text = movie.name
            
            if let genre = movie.genres.first {
                categoryLabel.text = genre.name
            } else {
                categoryLabel.text = ""
            }
            
        }

        
    }
}
