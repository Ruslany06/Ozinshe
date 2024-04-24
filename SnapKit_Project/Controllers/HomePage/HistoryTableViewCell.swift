//
//  HistoryTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.02.2024.
//

import UIKit
// MARK: History TVCell
class HistoryTableViewCell: UITableViewCell {

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
        cv.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
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
        layout.estimatedItemSize.width = 184
        layout.estimatedItemSize.height = 156
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    private let categoryTitleLabel = {
        let lbl = UILabel()
        
        lbl.text = "Қарауды жалғастырыңыз"
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        lbl.numberOfLines = 2
        
        return lbl
    }()
    // MARK: Constraints
    func constraints() {
        contentView.addSubview(collectionView)
        contentView.addSubview(categoryTitleLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.left.equalToSuperview().inset(24)
        }
    }
    
    func setData(mainMovie: MainMovie) {
   
        self.mainMovie = mainMovie
        
        collectionView.reloadData()
    }
    
    
}

// MARK: Extension TVCell
extension HistoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mainMovie.movies.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! HistoryCollectionViewCell
    
    cell.setData(movie: mainMovie.movies[indexPath.row])
    
    return cell
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieDidSelect(movie: mainMovie.movies[indexPath.item])
    }

}

// MARK: History CVCell
extension HistoryTableViewCell {
    class HistoryCollectionViewCell: UICollectionViewCell {
        
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
            
            lbl.text = "Глобус"
            lbl.font = .appFont(ofSize: 12, weight: .semiBold)
            lbl.textColor = UIColor._2MainColor111827FFFFFF
            lbl.textAlignment = .left
            
            return lbl
        }()
        private let categoryLabel = {
            let lbl = UILabel()
            
            lbl.text = "2-бөлім"
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
                make.width.equalTo(184)
                make.height.equalTo(112)
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

