//
//  SeriesViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 27.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import Localize_Swift

class SeasonsSeriesViewController: UIViewController {
    
    var movie = Movie()
    var seasons: [Season] = []
    var series: [Series] = []
    var link = ""
    var video_link = ""
    
    var currentSeason = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor._1MainColorFFFFFF111827
        
        constraints()
        downloadSeasons()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        languageDidChange()
        seasonsCV.reloadData()
        seriesTV.reloadData()
    }
    private lazy var seasonsCV = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        cvFlowLayout.scrollDirection = .horizontal
//        cvFlowLayout.minimumLineSpacing = 8
        cvFlowLayout.minimumInteritemSpacing = 8
        cvFlowLayout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SeasonsCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor._1MainColorFFFFFF111827
        
        return cv
    }()
    lazy var seriesTV: UITableView = {
        let tv = UITableView()
        
        tv.backgroundColor = UIColor._1MainColorFFFFFF111827
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    func constraints(){
        view.addSubview(seasonsCV)
        view.addSubview(seriesTV)
        
        seasonsCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        seriesTV.snp.makeConstraints { make in
            make.top.equalTo(seasonsCV.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func downloadSeasons() {
        SVProgressHUD.show()
        
//        self.seasons.removeAll()
//        self.seriesTV.reloadData()
//        self.seasonsCV.reloadData()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.GET_SEASONS_URL + String(movie.id), method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    for item in array {
                        let season = Season(json: item)
                        self.seasons.append(season)
                    }
                    self.seriesTV.reloadData()
                    self.seasonsCV.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            
        }
    }
    
    
}
//MARK: Extension SeriesVC
extension SeasonsSeriesViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //CVCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! SeasonsCollectionViewCell
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        cell.setData(season: seasons[indexPath.row], currentSeason: currentSeason)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        currentSeason = seasons[indexPath.row].number - 1
        seriesTV.reloadData()
        seasonsCV.reloadData()
        }
    
    //TVCell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if seasons.isEmpty {
            return 0
        }
        return seasons[currentSeason].videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SeriesTableViewCell()
        
        cell.setData(series: seasons[currentSeason].videos[indexPath.row])
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = VideoPlayerViewController()
        
        playerVC.video_link = seasons[currentSeason].videos[indexPath.row].link
        navigationController?.show(playerVC, sender: self)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 240
//    }
    
}
//MARK: SeasonsCVCell
extension SeasonsSeriesViewController {
    class SeasonsCollectionViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            constraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        let numberOfSeasonsLabel = {
            let lbl = PaddingLabel(withInsets: 4, 4, 8, 8)
            
            lbl.text = "1 сезон"
            lbl.font = .appFont(ofSize: 12, weight: .semiBold)
            lbl.textColor = UIColor._2MainColor111827FFFFFF
            lbl.layer.cornerRadius = 8
            lbl.backgroundColor = UIColor.searchCellColorF3F4F6374151
            lbl.textAlignment = .center
            
            return lbl
        }()
        
        func constraints(){
            contentView.addSubview(numberOfSeasonsLabel)
            
            numberOfSeasonsLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(34)
            }
        }
        
        func setData(season: Season, currentSeason: Int) {
            numberOfSeasonsLabel.text = "\(season.number)" + "SEASON_IN_SERIES".localized()
            
            if currentSeason == season.number - 1 {
                numberOfSeasonsLabel.textColor = UIColor(displayP3Red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
                numberOfSeasonsLabel.backgroundColor = UIColor(displayP3Red: 151/255, green: 83/255, blue: 240/255, alpha: 1)
            } else {
                numberOfSeasonsLabel.textColor = UIColor._2MainColor111827FFFFFF
                numberOfSeasonsLabel.backgroundColor = UIColor.searchCellColorF3F4F6374151
            }
            
        }
        
    }
    
    //MARK: SeriesTVCell
    class SeriesTableViewCell: UITableViewCell{
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = UIColor._1MainColorFFFFFF111827
//            contentView.layer.borderWidth = 1
//            contentView.layer.borderColor = UIColor.blue.cgColor
            constraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder) hasnt been implement")
        }
        
        private let posterImageview = {
            let iv = UIImageView()
            
            iv.image = UIImage(named: "poster")
            iv.layer.cornerRadius = 8
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            return iv
        }()
        private let numberOfSeriesLabel = {
            let lbl = UILabel()
            
            lbl.text = "EPISODE".localized()
            lbl.font = .appFont(ofSize: 14, weight: .bold)
            lbl.textColor = UIColor._2MainColor111827FFFFFF
            lbl.layer.cornerRadius = 8
            
            return lbl
        }()
        
        func constraints() {
            contentView.addSubview(posterImageview)
            contentView.addSubview(numberOfSeriesLabel)
            
            posterImageview.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(16)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(178.35)
            }
            numberOfSeriesLabel.snp.makeConstraints { make in
                make.top.equalTo(posterImageview.snp.bottom).offset(8)
                make.horizontalEdges.equalTo(posterImageview)
                make.bottom.equalToSuperview().inset(16)
            }
        }
        
        func setData(series: Series) {
            numberOfSeriesLabel.text = "\(series.number)" + "EPISODE".localized()
            posterImageview.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(series.link)/hqdefault.jpg"))
        }
        
    }
}
