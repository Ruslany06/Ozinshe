//
//  OnboardingViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.02.2024.
//

import UIKit
import SnapKit
import AdvancedPageControl

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraints()
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
    
    var arraySlides = [["firstSlide", "ÖZINŞE-ге қош келдің!", "Фильмдер, телехикаялар, ситкомдар, анимациялық жобалар, телебағдарламалар мен реалити-шоулар, аниме және тағы басқалары"],
                       ["secondSlide", "ÖZINŞE-ге қош келдің!", "Кез келген құрылғыдан қара\nСүйікті фильміңді  қосымша төлемсіз телефоннан, планшеттен, ноутбуктан қара"],
                       ["thirdSlide", "ÖZINŞE-ге қош келдің!", "Тіркелу оңай. Қазір тіркел де қалаған фильміңе қол жеткіз"]]
    
    // MARK: UIElements
    lazy var collectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.scrollDirection = .horizontal
        cvFlowLayout.minimumLineSpacing = 0
        cvFlowLayout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.backgroundColor = .lightGray
        cv.contentInsetAdjustmentBehavior = .never
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
        
        return cv
    }()
    let continueButton = {
        let btn = UIButton()
        
        btn.setTitle("Әрі қарай", for: .normal)
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for:.normal)
        btn.titleLabel?.font = .appFont(ofSize: 16, weight: .semiBold)
        btn.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        btn.layer.opacity = 0
        return btn
    }()
    let skipButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
        
        let btn = UIButton(configuration: configuration)
        btn.setTitle("Өткізу", for: .normal)
        btn.setTitleColor(UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1), for:.normal)
        btn.titleLabel?.font = .appFont(ofSize: 12, weight: .semiBold)
        btn.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        btn.layer.opacity = 1
        return btn
    }()
    
    lazy var pageControl2: AdvancedPageControlView = {
        let pageControl = AdvancedPageControlView()
        
        pageControl.drawer = ExtendedDotDrawer(
            numberOfPages: arraySlides.count,
            height: 6,
            width: 6,
            space: 4,
            raduis: 3,
            indicatorColor: UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1),
            dotsColor: UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1),
            borderWidth: 0
        )
        
        return pageControl
    }()
    
    
    // MARK: Functions
    @objc func goToSignIn() {
        let vc = SignInViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Constraints
    func constraints() {
        view.addSubview(collectionView)
        view.addSubview(continueButton)
        view.addSubview(skipButton)
        view.addSubview(pageControl2)
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
        continueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(dynamicValue(for: 38))
            make.height.equalTo(56)
        }
        skipButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        pageControl2.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(dynamicValue(for: 118))
            make.horizontalEdges.equalToSuperview()
        }
    }
    
   
    
}
// MARK: Extension
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // CV
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySlides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setData(image: arraySlides[indexPath.item][0], title:  arraySlides[indexPath.item][1], description: arraySlides[indexPath.row][2],  index: indexPath.item)
        
//            if indexPath.item < 2 {
//                continueButton.isHidden = true
//                skipButton.isHidden = false
//            } else {
//                continueButton.isHidden = false
//                skipButton.isHidden = true
//            }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.alignment = .center
        
          if let labelText = arraySlides[indexPath.item][2] as? String {
              let attributedString = NSMutableAttributedString(string: labelText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
              
              attributedString.addAttribute(NSAttributedString.Key.kern, value: 0.5, range: NSRange(location: 0, length: attributedString.length))

              cell.descriptionLabel.attributedText = attributedString
          }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    // ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let index = Int(round(offSet/width))
        pageControl2.setPage(index)
        
        if index == arraySlides.count - 1 {
            UIView.animate(withDuration: 0.15) {
                self.skipButton.layer.opacity = 0
                self.continueButton.layer.opacity = 1
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.skipButton.layer.opacity = 1
                self.continueButton.layer.opacity = 0
            }
        }
                
      }
    
}
// MARK: OnboardingCVCell class
extension OnboardingViewController {
    class OnboardingCollectionViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            Constraints()
            
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        let slidesImageView = {
            let iv = UIImageView()
            
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            return iv
        }()
        let titleLabel = {
            let lbl = UILabel()
            
            lbl.font = .appFont(ofSize: 24, weight: .bold)
            lbl.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
            
            return lbl
        }()
        let descriptionLabel = {
            let lbl = UILabel()
            
            lbl.font = .appFont(ofSize: 14, weight: .semiBold)
            lbl.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.5, alpha: 1)
            lbl.numberOfLines = 5
            
            return lbl
        }()
        
        func Constraints() {
            contentView.addSubview(slidesImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(descriptionLabel)
            
            slidesImageView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(dynamicValue(for: 504))
            }
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(descriptionLabel.snp.top).offset(dynamicValue(for: -24))
            }
            descriptionLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 32))
                make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(dynamicValue(for: 208))
            }
        }
        
        func setData(image: String, title: String, description: String, index: Int) {
            slidesImageView.image = UIImage(named: image)
            titleLabel.text = title
            descriptionLabel.text = description
            
        }
        
        
    }
}
