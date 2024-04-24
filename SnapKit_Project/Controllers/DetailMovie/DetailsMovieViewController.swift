//
//  DetailMovieViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 24.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage

class DetailsMovieViewController: UIViewController {
    
    var movie = Movie()
    var similarMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraints()
        setData()
        configureViews()
        CVTopLayout()
        downloadSimilar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = ""
    }
    
    // MARK: UI Elements
    private let scrollView = {
        let scroll = UIScrollView()
        
//        scroll.backgroundColor = .cyan
        
        return scroll
    }()
    private let customContentView = {
        let view = UIView()
        
//        view.backgroundColor = .lightGray
        
        return view
    }()
    private let posterImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "poster")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    private let backButton = {
        let btn = UIButton()
//        btn.layer.borderWidth = 1
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn.layer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 0).cgColor
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    private let playMovieButton = {
        let btn = UIButton()
//        btn.layer.borderWidth = 1
        btn.setImage(UIImage(named: "PlayMovie"), for: .normal)
        btn.layer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 0).cgColor
        btn.addTarget(self, action: #selector(playMovie), for: .touchUpInside)
        
        return btn
    }()
    private let addFavoriteButton = {
        let btn = UIButton()
//        btn.layer.borderWidth = 1
        btn.setImage(UIImage(named: "AddFavorite"), for: .normal)
        btn.layer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 0).cgColor
        btn.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        return btn
    }()
    private let shareButton = {
        let btn = UIButton()
        
//        btn.layer.borderWidth = 1
        btn.setImage(UIImage(named: "Share"), for: .normal)
        btn.layer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 0).cgColor
        btn.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    private let addFavoriteLabel = {
        let lbl = UILabel()
        
        lbl.text = "Тізімге қосу"
        lbl.font = .appFont(ofSize: 12, weight: .semiBold)
        lbl.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        
        return lbl
    }()
    private let shareLabel = {
        let lbl = UILabel()
        
        lbl.text = "Бөлісу"
        lbl.font = .appFont(ofSize: 12, weight: .semiBold)
        lbl.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        
        return lbl
    }()
    private let backgroundView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.F_9_FAFB_111827
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    private let titleLabel = {
        let lbl = UILabel()
        
        lbl.text = "Айдар"
        lbl.font = .appFont(ofSize: 24, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        
        return lbl
    }()
    
    private let line1 = lineViewFactory()
    
    private let categoryYearLabel = {
        let lbl = UILabel()
        
        lbl.text = "2020, Телехикая 5 сезон, 46 серия, 7 мин."
        lbl.font = .appFont(ofSize: 12, weight: .semiBold)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private let descriptionLabel = {
        let lbl = UILabel()
//        Шытырман оқиғалы мультсериал Елбасының «Ұлы даланың жеті қыры» бағдарламасы аясында жүзеге асырылған. Мақалада қызғалдақтардың отаны Қазақстан екені айтылады. Ал, жоба қызғалдақтардың отаны – Алатау баурайы екенін анимация тілінде дәлелдей түседі.
        lbl.text = " "
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        lbl.numberOfLines = 4
//        lbl.layer.borderWidth = 1
        
        return lbl
    }()
    private let descriptionGradient: Gradient = {
        let view = Gradient()

//        view.startColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//        view.endColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.backgroundColor = .clear
        view.startColor = UIColor.gradientF9FAFB111827
        view.endColor = UIColor.F_9_FAFB_111827
//        view.layer.borderWidth = 1
        
        return view
    }()
    private let expandDescriptionButton = {
        let btn = UIButton()
        
        btn.setTitle("Толығырақ", for: .normal)
        btn.titleLabel?.font = .appFont(ofSize: 14, weight: .semiBold)
        btn.setTitleColor(UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1), for:.normal)
        btn.addTarget(self, action: #selector(expandDescription), for: .touchUpInside)
        
        return btn
    }()
    private let directorLabel = {
        let lbl = UILabel()
        
        lbl.text = "Режиссер:"
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1)
        
        return lbl
    }()
    private let producerLabel = {
        let lbl = UILabel()
        
        lbl.text = "Продюсер:"
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1)
        
        return lbl
    }()
    private let directorNameLabel = {
        let lbl = UILabel()
        
        lbl.text = "Бақдәулет Әлімбеков"
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private let producerNameLabel = {
        let lbl = UILabel()
        
        lbl.text = "Сандуғаш Кенжебаева"
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    
    private let line2 = lineViewFactory()
    
    private let seriesLabel = {
        let lbl = UILabel()
        
        lbl.text = "Бөлімдер:"
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        
        return lbl
    }()
    private let seasonAndSeriesButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 24)
        
        var container = AttributeContainer()
        container.font = .appFont(ofSize: 12, weight: .semiBold)
        container.foregroundColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        configuration.attributedTitle = AttributedString("5 сезон, 46 серия", attributes: container)
        let btn = UIButton(configuration: configuration)
        
        btn.addTarget(self, action: #selector(seasonAndSeriesButtonTapped), for: .touchUpInside)
//        let btn = UIButton()
//        btn.setTitle("5 сезон, 46 серия", for: .normal)
//        btn.titleLabel?.font = .appFont(ofSize: 12, weight: .semiBold)
//        btn.setTitleColor(UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1), for:.normal)
//        btn.layer.borderWidth = 1
        
        return btn
        
    }()
    private let arrowImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "Arrow")
//        iv.layer.borderWidth = 1
        return iv
    }()
    private let screenshotsLabel = {
        let lbl = UILabel()
        
        lbl.text = "Скриншоттар:"
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        
        return lbl
    }()
    private lazy var screenshotsCV = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor._1MainColorFFFFFF111827
        
        return cv
    }()
    private let similarMoviesLabel = {
        let lbl = UILabel()
        
        lbl.text = "Ұқсас телехикаялар:"
        lbl.font = .appFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor._2MainColor111827FFFFFF
        
        return lbl
    }()
    private lazy var similarMoviesCV = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SimilarMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor._1MainColorFFFFFF111827
        
        return cv
    }()
    func CVTopLayout() {
        let layout1 = TopAlignedCollectionViewFlowLayout()
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout1.minimumInteritemSpacing = 16
        layout1.minimumLineSpacing = 16
        layout1.estimatedItemSize.width = 112
        layout1.estimatedItemSize.height = 224
        layout1.scrollDirection = .horizontal
        similarMoviesCV.collectionViewLayout = layout1
        let layout2 = TopAlignedCollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout2.minimumInteritemSpacing = 16
        layout2.minimumLineSpacing = 16
        layout2.estimatedItemSize.width = 184
        layout2.estimatedItemSize.height = 112
        layout2.scrollDirection = .horizontal
        screenshotsCV.collectionViewLayout = layout2
    }
    var expandDescriptionButtonConstraint: Constraint!
    var seriesLabelConstraint: Constraint!
    
    // MARK: Constraints
    func constraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(customContentView)
        customContentView.addSubview(posterImageView)
        customContentView.addSubview(backButton)
        customContentView.addSubview(playMovieButton)
        customContentView.addSubview(addFavoriteButton)
        customContentView.addSubview(shareButton)
        customContentView.addSubview(addFavoriteLabel)
        customContentView.addSubview(shareLabel)
        customContentView.addSubview(backgroundView)
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(categoryYearLabel)
        customContentView.addSubview(line1)
        customContentView.addSubview(descriptionLabel)
        customContentView.addSubview(descriptionGradient)
        customContentView.addSubview(expandDescriptionButton)
        customContentView.addSubview(directorLabel)
        customContentView.addSubview(producerLabel)
        customContentView.addSubview(directorNameLabel)
        customContentView.addSubview(producerNameLabel)
        customContentView.addSubview(line2)
        customContentView.addSubview(seriesLabel)
        customContentView.addSubview(arrowImageView)
        customContentView.addSubview(seasonAndSeriesButton)
        customContentView.addSubview(screenshotsLabel)
        customContentView.addSubview(screenshotsCV)
        customContentView.addSubview(similarMoviesLabel)
        customContentView.addSubview(similarMoviesCV)
        
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        customContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(364)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).inset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.safeAreaLayoutGuide).inset(16)
            make.left.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
        playMovieButton.snp.makeConstraints { make in
            make.centerX.equalTo(posterImageView)
            make.bottom.equalTo(posterImageView.snp.bottom).inset(78)
            make.size.equalTo(132)
        }
        addFavoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(playMovieButton)
            make.right.equalTo(playMovieButton.snp.left).offset(-18)
            make.size.equalTo(40)
        }
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(playMovieButton)
            make.left.equalTo(playMovieButton.snp.right).offset(18)
            make.size.equalTo(40)
        }
        addFavoriteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(addFavoriteButton)
            make.top.equalTo(addFavoriteButton.snp.bottom).offset(0)
        }
        shareLabel.snp.makeConstraints { make in
            make.centerX.equalTo(shareButton)
            make.top.equalTo(shareButton.snp.bottom).offset(0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).inset(24)
            make.left.equalTo(backgroundView.snp.left).inset(24)
        }
        categoryYearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(backgroundView.snp.left).inset(24)
        }
        line1.snp.makeConstraints { make in
            make.top.equalTo(categoryYearLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        descriptionGradient.snp.makeConstraints { make in
            make.edges.equalTo(descriptionLabel)
        }
        expandDescriptionButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(24)
        }
        directorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            expandDescriptionButtonConstraint = make.top.equalTo(descriptionLabel.snp.bottom).offset(24).priority(.low).constraint
            make.top.equalTo(expandDescriptionButton.snp.bottom).offset(24).priority(.medium)
        }
        producerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(directorLabel.snp.bottom).offset(8)
        }
        directorNameLabel.snp.makeConstraints { make in
            make.left.equalTo(directorLabel.snp.right).offset(20)
            make.top.equalTo(directorLabel)
        }
        producerNameLabel.snp.makeConstraints { make in
            make.left.equalTo(directorNameLabel)
            make.top.equalTo(producerLabel)
        }
        line2.snp.makeConstraints { make in
            make.top.equalTo(producerNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        seriesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(line2.snp.bottom).offset(24)
        }
        arrowImageView.snp.makeConstraints { make in
            make.right.equalTo(seasonAndSeriesButton.snp.right).inset(0)
//            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(seasonAndSeriesButton)
            make.size.equalTo(16)
        }
        seasonAndSeriesButton.snp.makeConstraints { make in
            make.centerY.equalTo(seriesLabel)
            make.right.equalToSuperview().inset(24)
            make.left.equalTo(seriesLabel.snp.right).inset(0)
        }
        screenshotsLabel.snp.makeConstraints { make in
            seriesLabelConstraint = make.top.equalTo(line2.snp.bottom).offset(3).priority(.low).constraint
            make.top.equalTo(seriesLabel.snp.bottom).offset(32).priority(.medium)
            make.left.equalToSuperview().inset(24)
        }
        screenshotsCV.snp.makeConstraints { make in
            make.top.equalTo(screenshotsLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(112)
        }
        similarMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotsCV.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(24)
        }
        similarMoviesCV.snp.makeConstraints { make in
            make.top.equalTo(similarMoviesLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(224)
        }
    }
    
    // MARK: Functions
    func setData() {
        posterImageView.sd_setImage(with: URL(string: movie.poster_link))
        titleLabel.text = movie.name
        categoryYearLabel.text = "\(movie.year)"
        
        for item in movie.genres {
            categoryYearLabel.text = categoryYearLabel.text! + " • " + item.name
        }
        
        directorNameLabel.text = movie.director
        producerNameLabel.text = movie.producer
        
        var container = AttributeContainer()
        container.font = .appFont(ofSize: 12, weight: .semiBold)
        container.foregroundColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        seasonAndSeriesButton.configuration?.attributedTitle = AttributedString("\(movie.seasonCount) сезон" + ", " + "\(movie.seriesCount) серия", attributes: container)
        
//        seasonAndSeriesButton.setTitle("\(movie.seasonCount) сезон" + ", " + "\(movie.seriesCount) серия", for: .normal)
        
        descriptionLabel.text = movie.description
    }
    // MARK: AF request - DownloadSimilar
    func downloadSimilar() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(URLs.SIMILAR_MOVIES + String(movie.id), method: .get, headers: headers).responseData { response in
            
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
                        let movie = Movie(json: item)
                        self.similarMovies.append(movie)
                    }
                    self.similarMoviesCV.reloadData()
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
    
    func setupDescriptionLabelAttributes() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.alignment = .left
        
        if let labelText = descriptionLabel.text {
            let attributedString = NSMutableAttributedString(string: labelText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 0.5, range: NSRange(location: 0, length: attributedString.length))
            descriptionLabel.attributedText = attributedString
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func playMovie(_ sender: Any) {
        if movie.movieType == "MOVIE" {
            let playerVC = VideoPlayerViewController()
            
            playerVC.video_link = movie.video_link
            navigationController?.show(playerVC, sender: self)
            
        } else {
            let seasonVC =  SeasonsSeriesViewController()
            
            seasonVC.movie = movie
            seasonVC.video_link = movie.video_link
            navigationController?.show(seasonVC, sender: self)
        }
        
    }
    // MARK: AF request - AddToFavorite
    @objc func addToFavorite(_ sender: Any) {
        
        SVProgressHUD.show()
        
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        let parameters = ["movieId": movie.id] as [String: Any]
        
        AF.request(URLs.FAVORITES_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201  {
                
                self.movie.favorite.toggle()
                self.configureViews()
                
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
    @objc func shareButtonTapped(_ sender: Any) {
        let text = "\(movie.name) \n\(movie.description)"
                let image = posterImageView.image
                let shareAll = [text, image!] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
    }
    @objc func expandDescription(_ sender: Any) {
        if descriptionLabel.numberOfLines > 4 {
            descriptionLabel.numberOfLines = 4
            expandDescriptionButton.setTitle("Толығырақ", for: .normal)
            descriptionGradient.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 30
            expandDescriptionButton.setTitle("Жасыру", for: .normal)
            descriptionGradient.isHidden = true
        }
    }
    @objc func seasonAndSeriesButtonTapped() {
        let vc = SeasonsSeriesViewController()
        
        vc.movie = movie
        
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Configure Views
    func configureViews() {
        
        if movie.movieType == "MOVIE" {
            seriesLabel.isHidden = true
            seasonAndSeriesButton.isHidden = true
            arrowImageView.isHidden = true
            seriesLabelConstraint.update(priority: .high)
        }
        
        if movie.favorite {
            addFavoriteButton.setImage(UIImage(named: "AddFavoriteSelected"), for: .normal)
        } else {
            addFavoriteButton.setImage(UIImage(named: "AddFavorite"), for: .normal)
        }
        
        if descriptionLabel.maxNumberOfLines < 5 {
            expandDescriptionButton.isHidden = true
            descriptionGradient.isHidden = true
            expandDescriptionButtonConstraint.update(priority: .high)
        }
        
        setupDescriptionLabelAttributes()
    }
//    descriptionLabel.numberOfLines + 1
}
// MARK: Extension Screenshot CV
extension DetailsMovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == screenshotsCV {
            return movie.screenshots.count
        }
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == screenshotsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! ScreenshotCollectionViewCell
            
            cell.setData(link: movie.screenshots[indexPath.item].link)

            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! SimilarMoviesCollectionViewCell
        
        cell.setData(movie: similarMovies[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == similarMoviesCV {
            let detailsViewController = DetailsMovieViewController()
            
            detailsViewController.movie = similarMovies[indexPath.item]
            
            navigationController?.pushViewController(detailsViewController, animated: true)
            return
        }
        return
    }
}

// MARK: Screenshot CVCell
extension DetailsMovieViewController {
    class ScreenshotCollectionViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
//            backgroundColor = .red
            constraints()
            
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        // MARK: UIElements
        private let posterImageView = {
            let iv = UIImageView()
            
            iv.image = UIImage(named: "poster")
            iv.layer.cornerRadius = 8
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            return iv
        }()
        
        // MARK: constraints
        func constraints(){
            contentView.addSubview(posterImageView)
            
            posterImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(184)
                make.height.equalTo(112)
            }
        }
        
        func setData(link: String) {
            posterImageView.layer.cornerRadius = 8
            posterImageView.sd_setImage(with: URL(string: link))
        }
        
    }
}


// MARK: SimilarMovies CVCell
extension DetailsMovieViewController {
    class SimilarMoviesCollectionViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            constraints()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        // MARK: UIElements
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
            lbl.textAlignment = .left
            lbl.numberOfLines = 2
            
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
        
        // MARK: constraints
        func constraints(){
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
