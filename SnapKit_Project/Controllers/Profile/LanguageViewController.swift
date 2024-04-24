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
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
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
            make.height.equalTo(303)
        }
        languageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(backgroundView.snp.top).inset(58)
        }
        tableView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.horizontalEdges.equalTo(backgroundView.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(backgroundView.snp.bottom).inset(0)
            make.top.equalTo(languageLabel.snp.bottom).offset(12)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).inset(21)
            make.height.equalTo(5)
            make.width.equalTo(64)
        }
    }
    // MARK: Functions
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))! {
            return false
        }
        return true
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case.changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                self.languageLabel.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                self.tableView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 100 { UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { self.backgroundView.transform = .identity
                self.languageLabel.transform = .identity
                self.tableView.transform = .identity
                self.lineView.transform = .identity
            })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default : break
        }
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
