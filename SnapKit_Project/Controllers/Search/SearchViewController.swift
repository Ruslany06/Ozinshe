//
//  SearchViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import ImageIO
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SearchViewController: UIViewController {
    
    var categories: [Categories] = []
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Іздеу"
        self.tabBarItem.title = nil
        
        Constraints()
        hideKeyboardWhenTapedAround()
        textFieldValueChanged()
        downloadCategories()
        CVLeftLayout()
        
    }
    
    // MARK: CollectionView Settings
    lazy var collectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        
        return cv
    }()
    func CVLeftLayout() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize.width = 100
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: TableView Settings
    lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    //MARK: UISettings
    let searchTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 56)
        //            textField.backgroundColor = .red
        textField.placeholder = "Іздеу"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.92, blue: 0.94, alpha: 1).cgColor
        textField.layer.cornerRadius = 12
        
        textField.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        
        return textField
    }()
    let searchButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SearchBtn"), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1).cgColor
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        return button
    }()
    let titleLabel = {
        let label = UILabel()
        label.text = "Санаттар"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    let clearButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ClearBtn"), for: .normal)
        button.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        button.isHidden = false
        
        return button
    }()
    
    var tableViewToCollectionViewConstraint: Constraint!
    var tableViewToTitleLabelConstraint: Constraint!
    
    func Constraints() {
        // MARK: Constraints
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(clearButton)
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(56)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(searchButton.snp.left).offset(-16)
            make.height.equalTo(56)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(29)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(222)
        }
        tableView.snp.makeConstraints { make in
            tableViewToCollectionViewConstraint = make.top.equalTo(collectionView.snp.bottom).offset(0).priority(1000).constraint
            tableViewToTitleLabelConstraint = make.top.equalTo(titleLabel.snp.bottom).offset(16).priority(900).constraint
            
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
        clearButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchTextField).inset(0)
            make.right.equalTo(searchTextField).inset(0)
            make.size.equalTo(56)
        }
    }
    
    // MARK: Functions
    func hideKeyboardWhenTapedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func searchButtonTapped() {
        textFieldValueChanged()
    }
    @objc func editingDidBeginTextField(_ sender: UITextField) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        searchButton.setImage(UIImage(named: "SearchBtnHighlited"), for: .normal)
    }
    @objc func editingDidEndTextField(_ sender: UITextField) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        searchButton.setImage(UIImage(named: "SearchBtn"), for: .normal)
    }
    
    @objc func clearSearch(_ sender: Any) {
        searchTextField.text = ""
        textFieldValueChanged()
    }
    
// MARK: DownloadSearchMovies
    @objc func textFieldValueChanged() {
        
        let searchText = searchTextField.text!
        
        if searchText.isEmpty {
            
            clearButton.isHidden = true
            titleLabel.text = "Санаттар"
            
            tableViewToCollectionViewConstraint.activate()
            view.layoutIfNeeded()
            
            movies.removeAll()
            tableView.reloadData()
            return
        } else {
            clearButton.isHidden = false
            titleLabel.text = "Іздеу нәтижелері"
            
            tableViewToCollectionViewConstraint.deactivate()
            view.layoutIfNeeded()
            
            SVProgressHUD.show(withStatus: "Жүктеу")
            
            let headers: HTTPHeaders = [
                "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
            ]
            
            let parameters = ["search": searchTextField.text!]
            
            AF.request(URLs.SEARCH_MOVIES_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
                
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    
                    if let array = json.array {
                        self.movies.removeAll()
                        self.tableView.reloadData()
                        for item in array {
                            let movie = Movie(json: item)
                            self.movies.append(movie)
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
// MARK: DownloadCategories
    func downloadCategories() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(URLs.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
            
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
                    for item in array {
                        let category = Categories(json: item)
                        self.categories.append(category)
                    }
                    self.collectionView.reloadData()
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

// MARK: Extensions
// CVC
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
//        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! SearchCollectionViewCell
       
        cell.setData(categories: categories[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryTVC = CategoryTableViewController()
        
        categoryTVC.categoryID = categories[indexPath.row].id
        categoryTVC.categoryName = categories[indexPath.row].name
        
        navigationController?.pushViewController(categoryTVC, animated: true)
    }
    
    
}
// TVC
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell()
        cell.setData(movie: movies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
}
