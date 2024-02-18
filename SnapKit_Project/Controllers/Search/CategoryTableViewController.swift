//
//  CategoryTableViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.02.2024.
//

import UIKit
import SnapKit
import ImageIO
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CategoryTableViewController: UITableViewController {
    
    var categoryID = 0 // parameter (filter movies by categoryID)
    var categoryName = ""
    var movies: [Movie] = [] // list of movies
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = categoryName
        downloadMovieByCategoryId()
    }
    
    func downloadMovieByCategoryId() {
        
        SVProgressHUD.show(withStatus: "Жүктеу")
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
//        , "name" :categoryName
        let parameters = ["categoryId": categoryID, "name" :categoryName] as [String : Any]
        
        AF.request(URLs.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if json["content"].exists() {
                    if let array = json["content"].array {
                        for item in array {
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                    }
                    self.tableView.reloadData()
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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryTableViewCell()
        
        cell.setData(movie: movies[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 152
    }

}

// MARK: Class TVCell

import SDWebImage

class CategoryTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        UISettings()
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
        label.textColor =  UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        return label
    }()
    
    let subtitleLabel = {
        let label = UILabel()
        
        label.text = "2020 • Телехикая • Мультфильм мекені"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        label.textColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        return label
    }()
    
    let playView = {
        let view = UIView()
        let imageView = UIImageView()
        let label = UILabel()
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.93, blue: 1, alpha: 1)
        view.layer.cornerRadius = 8
        
        imageView.image = UIImage(named: "PlayIcon")
        
        label.text = "Қарау"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        label.textColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(4)
            make.size.equalTo(16)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(4)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview().inset(12)
        }
        return view
    }()
    
    func UISettings() {
        contentView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(104)
            make.width.equalTo(71)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(17)
            make.top.equalToSuperview().inset(24)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        contentView.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(17)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
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
