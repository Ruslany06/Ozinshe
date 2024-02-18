//
//  LogOutViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 25.11.2023.
//

import UIKit

class LogOutViewController: UIViewController, UIGestureRecognizerDelegate {

    var viewTranslation = CGPoint (x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        UISettings()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    let backgroundView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()

    let titleLabel = {
        let label = UILabel()
        label.text = "Шығу"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        return label
    }()

    let lineView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        return view
    }()
    
    let subTitleLabel = {
        let label = UILabel()
        
        label.text = "Сіз шынымен аккаунтыныздан"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return label
    }()
    
    lazy var yesButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        button.setTitle("Иә, шығу", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(yesLogOut), for: .touchUpInside)
        button.setTitleColor(UIColor.red, for: .highlighted)
        return button
    }()
    
    lazy var noButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.white
        button.setTitle("Жоқ", for: .normal)
        button.setTitleColor(UIColor(red: 0.33, green: 0.08, blue: 0.78, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.setTitleColor(UIColor.red, for: .highlighted)
        return button
    }()
    
    func UISettings() {
        
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        view.addSubview(subTitleLabel)
        view.addSubview(yesButton)
        view.addSubview(noButton)
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(0)
            make.height.equalTo(303)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(backgroundView.snp.top).inset(58)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).inset(21)
            make.height.equalTo(5)
            make.width.equalTo(64)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundView).inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        yesButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(backgroundView).inset(24)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(56)
        }
        noButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(backgroundView).inset(24)
            make.top.equalTo(yesButton.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
    }
   
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
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 100 { UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { self.backgroundView.transform = .identity
                self.titleLabel.transform = .identity
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
    
    @objc func yesLogOut() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let signInVC = SignInViewController()
//        let signInNavController = UINavigationController(rootViewController: signInVC)
//        navigationController?.show(signInVC, sender: self)
        navigationController?.pushViewController(signInVC, animated: true)
        
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = signInNavController
//        appDelegate.window?.makeKeyAndVisible()
        
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
        

    }
}
