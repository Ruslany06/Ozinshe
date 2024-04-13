//
//  HomeViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD
// MARK: HomeViewConrtoller
class HomeViewController: UIViewController, MovieProtocol, SendTheIdDelegate {

    var mainMovies: [MainMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addNavBarImage()
        constraints()
        downloadMainBanners()
    }
    
    func addNavBarImage() {
        let image = UIImage(named: "logoMainPage")!
        
        let logoImageView = UIImageView(image: image)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        navigationItem.leftBarButtonItem = imageItem
        
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        
//        tv.backgroundColor = .lightGray
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()

    // MARK: Constraints
    func constraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    // MARK: API requests
    func downloadMainBanners() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.MAIN_BANNERS_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    
                    var newMainMovie = MainMovie()
                    newMainMovie.cellType = .mainBanner
                    
                    for item in array {
                        let bannerMovie = BannerMovie(json: item)
                        newMainMovie.bannerMovie.append(bannerMovie)
                    }
                    self.mainMovies.append(newMainMovie)
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
            self.downloadHistory()
            
        }
    }
    
    func downloadHistory() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.HISTORY_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    
                    var mainMovie = MainMovie()
                    mainMovie.cellType = .userHistory
                    
                    for item in array {
                        let movie = Movie(json: item)
                        mainMovie.movies.append(movie)
                     
                    }
                    if array.count > 0 {
                        self.mainMovies.append(mainMovie)
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
            
            self.downloadMainMovies()
        }
    }
    
    func downloadMainMovies() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.MAIN_MOVIES_URL, method: .get, headers: headers).responseData { response in
            
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
                        let mainMovie = MainMovie(json: item)
                        self.mainMovies.append(mainMovie)
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
            self.downloadGenres()
        }
    }
    
    func downloadGenres() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.GENRES_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    var newmainMovie1 = MainMovie()
                    newmainMovie1.categoryName = "Жанрды таңдаңыз"
                    newmainMovie1.cellType = .genre
                    
                    for item in array {
                        let genres = Genre(json: item)
                        newmainMovie1.genres.append(genres)
                    }
                    
                    if self.mainMovies.count > 4 {
                        if self.mainMovies[1].cellType == .userHistory {
                            self.mainMovies.insert(newmainMovie1, at: 4)
                        } else {
                            self.mainMovies.insert(newmainMovie1, at: 3)
                        }
                    } else {
                        self.mainMovies.append(newmainMovie1)
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
            self.downloadCategoryAges()
            
        }
    }
    
    func downloadCategoryAges() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.CATEGORY_AGES_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    var newmainMovie1 = MainMovie()
                    newmainMovie1.categoryName = "Жасына сәйкес"
                    newmainMovie1.cellType = .ageCategory
                    
                    for item in array {
                        let genres = CategoryAge(json: item)
                        newmainMovie1.categoryAges.append(genres)
                    }
                    
                    if self.mainMovies.count > 8 {
                        if self.mainMovies[1].cellType == .userHistory {
                            self.mainMovies.insert(newmainMovie1, at: 8)
                        } else {
                            self.mainMovies.insert(newmainMovie1, at: 7)
                        }
                    } else {
                        self.mainMovies.append(newmainMovie1)
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
    
    
}
// MARK: Extension HomeTVCell configuration
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if mainMovies[indexPath.row].cellType == .mainBanner {
            let cell = MainBannerTableViewCell()
            cell.delegate = self
            cell.setData(mainMovie: mainMovies[indexPath.row])
            
            return cell
        }
        
        if mainMovies[indexPath.row].cellType == .userHistory {
            let cell = HistoryTableViewCell()
            cell.delegate = self
            cell.setData(mainMovie: mainMovies[indexPath.row])
            
            return cell
        }
        
        if mainMovies[indexPath.row].cellType == .genre {
            let cell = GenreAgeTableViewCell()
            cell.delegate = self
            cell.setData(mainMovie: mainMovies[indexPath.row])
            
            return cell
        }
        
        if mainMovies[indexPath.row].cellType == .ageCategory {
            let cell = GenreAgeTableViewCell()
            cell.delegate = self
            cell.setData(mainMovie: mainMovies[indexPath.row])
            
            return cell
        }

        let cell = HomeTableViewCell()
        
        cell.setData(mainMovie: mainMovies[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if mainMovies[indexPath.row].cellType == .ageCategory {
            return 184
        }
        if mainMovies[indexPath.row].cellType == .genre {
            return 184
        }
        if mainMovies[indexPath.row].cellType == .mainBanner {
            return 272
        }
        if mainMovies[indexPath.row].cellType == .userHistory {
            return 228
        }
        
        return 292
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainMovies[indexPath.row].cellType != .mainMovie {
            return
        }
        
        let categoryMoviesVC = CategoryTableViewController()
        
        categoryMoviesVC.categoryID = mainMovies[indexPath.row].categoryId
        categoryMoviesVC.categoryName = mainMovies[indexPath.row].categoryName
        
        navigationController?.pushViewController(categoryMoviesVC, animated: true)
        
    }
    func sendID(categoryID: Int, cellType: CellType, categoryName: String) {
        let categoryMoviesVC = CategoryTableViewController()
        
        categoryMoviesVC.categoryID = categoryID
        categoryMoviesVC.categoryName = categoryName
        
        if cellType == .ageCategory {
            categoryMoviesVC.categoryType = .ageCategoryId
        } else {
            categoryMoviesVC.categoryType = .genreId
        }
        
        navigationController?.pushViewController(categoryMoviesVC, animated: true)
        
    }
    func movieDidSelect(movie: Movie) {
        let DetailsMovieVC = DetailsMovieViewController()
        
        DetailsMovieVC.movie = movie
        navigationController?.pushViewController(DetailsMovieVC, animated: true)
        
    }
}
    
    
    

