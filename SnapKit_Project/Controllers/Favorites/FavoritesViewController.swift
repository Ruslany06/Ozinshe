//
//  FavoritesViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class FavoritesViewController: UIViewController {
    
    var arrayFavorites:[Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor._1MainColorFFFFFF111827
        
        title = "LIST".localized()
        self.tabBarItem.title = nil
        
        constraints()
        
        
        //        for family in UIFont.familyNames {
        //            print("Family: \(family)")
        //            for name in UIFont.fontNames(forFamilyName: family) {
        //                print("       - \(name)")
        //            }
        //        }
        /*
         SF Pro Display
         - SFProDisplay-Regular
         - SFProDisplay-Semibold
         - SFProDisplay-Bold
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadFavorites()
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        
        return tv
    }()
    func constraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func downloadFavorites() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(URLs.FAVORITES_URL, method: .get, headers: headers) .responseData {
            response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.arrayFavorites.removeAll()
                    for item in array {
                        let movie = Movie(json: item)
                        self.arrayFavorites.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONENCTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONENCTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
        
    }
    
    
}
// MARK: UITableViewDataSource, UITableViewDelegate
    extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFavorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableViewCell()
        cell.setData(movie: arrayFavorites[indexPath.row])
    
        return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = DetailsMovieViewController()
        
        detailsViewController.movie = arrayFavorites[indexPath.row]
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
