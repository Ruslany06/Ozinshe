//
//  LanguageViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 11.11.2023.
//

import UIKit
import SnapKit
import Localize_Swift

protocol LanguageProtocol {
    func languageDidChange()
}

class LanguageViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var languageDelegate: LanguageProtocol?
    var viewTranslation = CGPoint (x: 0, y: 0)
    
    let languageArray = [["English", "en"], ["Қазақша","kk"], ["Русский", "ru"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//        navigationController?.navigationBar.backgroundColor = UIColor.FFFFFF_111827
        constraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()

        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor.clear

        return tv
    }()
    
    let backgroundView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.FFFFFF_1_C_2431
        return view
    }()

    let languageLabel = {
        let label = UILabel()
        label.text = "Тіл"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor._2MainColor111827FFFFFF
        return label
    }()

    let lineView = {
        let view = UIView()
        view.backgroundColor = UIColor.linevVewD1D5DB6B7280
        view.layer.cornerRadius = 100
        return view
    }()
    
    //MARK: UISettings and TableView
    func constraints() {
        
        view.addSubview(backgroundView)
        view.addSubview(languageLabel)
        view.addSubview(tableView)
        view.addSubview(lineView)
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(0)
            make.height.equalTo(dynamicValue(for: 303))
        }
        languageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(backgroundView.snp.top).inset(dynamicValue(for: 58))
        }
        tableView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.horizontalEdges.equalTo(backgroundView.snp.horizontalEdges).inset(dynamicValue(for: 24))
            make.bottom.equalTo(backgroundView.snp.bottom).inset(0)
            make.top.equalTo(languageLabel.snp.bottom).offset(dynamicValue(for: 12))
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).inset(dynamicValue(for: 21))
            make.height.equalTo(dynamicValue(for: 5))
            make.width.equalTo(dynamicValue(for: 64))
        }
    }
    // MARK: Functions
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))! {
            return false
        }
        return true
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
// MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LanguageTableViewCell()
        cell.languageLabel.text = languageArray[indexPath.row][0]
        
        if Localize.currentLanguage() == languageArray[indexPath.row][1] {
            cell.checkImageView.image = UIImage(named: "Check")
        } else {
            cell.checkImageView.image = nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Localize.setCurrentLanguage(languageArray[indexPath.row][1])
        languageDelegate?.languageDidChange()
        dismiss(animated: true)
    }
}
