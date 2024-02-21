//
//  SignInViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 18.11.2023.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Gifu

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Авторизация"
        
        Constraints()
        hideKeyboardWhenTapedAround()
    }
    
    // MARK: UISettings
    let titleLabel = {
        let label = UILabel()
        
        label.text = "Сәлем"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    
    let subTitleLabel = {
        let label = UILabel()
        
        label.text = "Аккаунтқа кіріңіз"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.5, alpha: 1)
        
        return label
    }()
    
    let emailLabel = {
        let label = UILabel()
        
        label.text = "Email"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    
    lazy var emailTextField: TextFieldWithPadding! = {
        let textField = TextFieldWithPadding()
        
        textField.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 16)
        textField.placeholder = "Сіздің email"
        textField.layer.cornerRadius = 12.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textField
    }()
    
    let passwordLabel = {
        let label = UILabel()
        
        label.text = "Құпия сөз"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    
    lazy var passwordTextField: TextFieldWithPadding! = {
        let textField = TextFieldWithPadding()
        
        textField.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        textField.placeholder = "Сіздің құпия сөзіңіз"
        textField.layer.cornerRadius = 12.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textField
    }()
    
    let emailImage = {
        let image = UIImageView()
        
        image.image = UIImage(named: "Email")
        
        return image
    }()
    
    let passwordImage = {
        let image = UIImageView()
        
        image.image = UIImage(named: "Password")
        
        return image
    }()
    
    lazy var showPasswordButton = {
//        var configuration = UIButton.Configuration.plain()
//        configuration.contentInsets.top.
//        
//        let button = UIButton(configuration: configuration)
        let button = UIButton()
        
        button.setImage(UIImage(named: "ShowPassword"), for: .normal)
        button.addTarget(self, action: #selector(touchDownShowPassword), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideHidePassword), for: .touchUpInside)
        
        
        return button
    }()
    
    lazy var recoverPasswordButton = {
        let button = UIButton()
        
        button.setTitle("Құпия сөзді ұмыттыңыз ба?", for: .normal)
        button.setTitleColor(UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1), for:.normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        
        return button
    }()
    
    lazy var signInButton = {
        let button = UIButton()
        
        button.setTitle("Кіру", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for:.normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
//         signInRquest
        return button
    }()
    
    let registrationButton = {
        let view = UIView()
        let label = UILabel()
        let button = UIButton()
        
        view.addSubview(label)
        view.addSubview(button)
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        label.text = "Аккаунтыныз жоқ па?"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.5, alpha: 1)
        
        button.setTitle("Тіркелу", for: .normal)
        button.setTitleColor(UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1), for:.normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.verticalEdges.equalToSuperview().inset(0)
            make.left.equalToSuperview().inset(0)
        }
        button.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.verticalEdges.equalToSuperview().inset(0)
            make.left.equalTo(label.snp.right).offset(4)
            make.right.equalToSuperview().inset(0)
        }
        return view
    }()
    // add GIF
    lazy var gifImageView: GIFImageView = {
        let imageView = GIFImageView()
        
        imageView.animate(withGIFNamed: "PandaGIF")
//        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    let validationEmailLabel = {
        let label = UILabel()
        
        label.text = "Қате формат"
        label.font = .appFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        label.isHidden = true
        
        return label
    }()
    let validationPasswordLabel = {
        let label = UILabel()
        
        label.text = "Қате құпия сөз"
        label.font = .appFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        label.isHidden = true
        
        return label
    }()
    
    var validationEmailConstraint: Constraint!
    var passwordToEmailConstraint: Constraint!
    var validationPasswordConstraint: Constraint!
    var recoverBtnToPasswordConstraint: Constraint!
    
    // MARK: Constraints
    func Constraints() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(emailImage)
        view.addSubview(passwordImage)
        view.addSubview(showPasswordButton)
        view.addSubview(recoverPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(registrationButton)
        view.addSubview(gifImageView)
        view.addSubview(validationEmailLabel)
        view.addSubview(validationPasswordLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
        }
        emailLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(29)
        }
        emailTextField.snp.makeConstraints {make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.height.equalTo(56)
        }
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            passwordToEmailConstraint = make.top.equalTo(emailTextField.snp.bottom).offset(16).priority(1000).constraint
            validationEmailConstraint = make.top.equalTo(validationEmailLabel.snp.bottom).offset(16).priority(500).constraint
        }
        passwordTextField.snp.makeConstraints {make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.height.equalTo(56)
        }
        emailImage.snp.makeConstraints {make in
            make.left.equalTo(emailTextField.snp.left).inset(16)
            make.centerY.equalTo(emailTextField)
            make.size.equalTo(20)
        }
        passwordImage.snp.makeConstraints {make in
            make.left.equalTo(passwordTextField.snp.left).inset(16)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(20)
        }
        showPasswordButton.snp.makeConstraints { make in
            make.right.equalTo(passwordTextField.snp.right).inset(0)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(56)
        }
        recoverPasswordButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            recoverBtnToPasswordConstraint = make.top.equalTo(passwordTextField.snp.bottom).offset(16).priority(1000).constraint
            validationPasswordConstraint = make.top.equalTo(validationPasswordLabel.snp.bottom).offset(16).priority(500).constraint
        }
        signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(recoverPasswordButton.snp.bottom).offset(40)
            make.height.equalTo(56)
        }
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(24)
            make.height.equalTo(22)
            make.centerX.equalTo(view)
        }
        gifImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.bottom.equalTo(emailLabel.snp.bottom)
            make.size.equalTo(130)
        }
        validationEmailLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(emailTextField.snp.bottom).inset(-16)
        }
        validationPasswordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-16)
        }
    }
    
    // MARK: Functions
    func hideKeyboardWhenTapedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func touchDownShowPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = false
    }
    @objc func touchUpInsideHidePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func editingDidBeginTextField(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        validationEmailLabel.isHidden = true
        passwordToEmailConstraint.activate()
        validationPasswordLabel.isHidden = true
        recoverBtnToPasswordConstraint.activate()
        
        view.layoutIfNeeded()
    }
    @objc func editingDidEndTextField(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    @objc func registrationButtonTapped() {
        let vc = SignUpViewController()
        
        navigationController?.show(vc, sender: self)
    }
    @objc func signInButtonTapped() {
        
        let validator = Validation()
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if (email.isEmpty || password.isEmpty) {
            
            let alert = UIAlertController(title: "Енгізу қатесі", message: "Барлық өрістерді толтырыңыз", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            
            emailTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            
            print("Some fields are empty")
            
            return
        }
        
        if validator.isValidMail(email: email) == false {
            
            validationEmailLabel.isHidden = false
            
            passwordToEmailConstraint.deactivate()
            view.layoutIfNeeded()
            
            emailTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            
            print("Mistake with email format")
            
            return
        }
        print("All good")
        signInRquest()
    }

    // MARK: SignIn
    @objc func signInRquest() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show()
        
        let parameters = ["email": email,
                          "password": password]
        
        AF.request(URLs.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")

                if let token = json["accessToken"].string {
//                    response.data
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    
                    Storage.sharedInstance.accessToken = token
                    
                    self.startApp()
                    
                } else {
                    SVProgressHUD.showError(withStatus: "CONENCTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONENCTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
//                SVProgressHUD.showError(withStatus: "\(ErrorString)")
//                self.validationPasswordLabel.text = resultString
                self.validationPasswordLabel.isHidden = false
                self.recoverBtnToPasswordConstraint.deactivate()
                self.view.layoutIfNeeded()
                self.passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
                
            }
        }
    }
    
    func startApp() {
        let tabBarVC = TabBarController()

        tabBarVC.modalPresentationStyle = .fullScreen
        
        present(tabBarVC, animated: true, completion: nil)
    }
    
}
