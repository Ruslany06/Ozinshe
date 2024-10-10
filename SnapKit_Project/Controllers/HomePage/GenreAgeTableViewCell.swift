//
//  GenreAgeTableViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.02.2024.
//
import UIKit
import Localize_Swift

protocol SendTheIdDelegate: AnyObject {
    func sendID(categoryID: Int, cellType: CellType, categoryName: String)
}

// MARK: History TVCell
class GenreAgeTableViewCell: UITableViewCell {

    var mainMovies = MainMovie()
    var delegate: SendTheIdDelegate?
    
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
    private lazy var collectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(GenreAgeCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
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
    private let titleLabel = {
        let lbl = UILabel()
        
        lbl.text = "CHOOSE_GENRE".localized()
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        lbl.numberOfLines = 2
        
        return lbl
    }()
    // MARK: Constraints
    func constraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        // MARK: IN PROGRESS OF REPAIRING
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.left.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

    }
    
    func setData(mainMovie: MainMovie) {
        
        self.mainMovies = mainMovie
        
        titleLabel.text = self.mainMovies.categoryName
        
        collectionView.reloadData()
    }
    
    
}

// MARK: Extension TVCell
extension GenreAgeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if mainMovies.cellType == .ageCategory {
        return mainMovies.categoryAges.count
    }
    return mainMovies.genres.count
    
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! GenreAgeCollectionViewCell
    
    if mainMovies.cellType == .ageCategory {
        cell.setData(name: mainMovies.categoryAges[indexPath.row].name, link: mainMovies.categoryAges[indexPath.row].link)
    }
    if mainMovies.cellType == .genre {
        cell.setData(name: mainMovies.genres[indexPath.row].name, link: mainMovies.genres[indexPath.row].link)
    }
    
    return cell
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if mainMovies.cellType == .ageCategory {
        self.delegate?.sendID(categoryID: mainMovies.categoryAges[indexPath.row].id, cellType: .ageCategory, categoryName: mainMovies.categoryAges[indexPath.row].name)
        
    }
    if mainMovies.cellType == .genre {
        self.delegate?.sendID(categoryID: mainMovies.genres[indexPath.row].id, cellType: .genre, categoryName: mainMovies.genres[indexPath.row].name)
    }
}


}

// MARK: GenreAge CVCell
extension GenreAgeTableViewCell {
    class GenreAgeCollectionViewCell: UICollectionViewCell {
        
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
        private let genreAgeNameLabel = {
            let lbl = UILabel()
            
            lbl.text = "Мультфильм"
            lbl.font = .appFont(ofSize: 14, weight: .semiBold)
            lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            lbl.textAlignment = .center
            
            return lbl
        }()
        // MARK: Constraints
        func constraints() {
            contentView.addSubview(posterImageView)
            contentView.addSubview(genreAgeNameLabel)
            
            posterImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(184)
                make.height.equalTo(112)
            }
            genreAgeNameLabel.snp.makeConstraints { make in
                make.centerY.equalTo(posterImageView)
                make.horizontalEdges.equalToSuperview()
            }
        }
        
        func setData(name: String, link: String) {
            posterImageView.layer.cornerRadius = 8
            posterImageView.sd_setImage(with: URL(string: link))
            
            genreAgeNameLabel.text = name
        }

                
    }
}


