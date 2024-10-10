//
//  SignUpViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 16.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class SignUpViewController: UIViewController, LanguageProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor._1MainColorFFFFFF111827
        navigationItem.title = nil
        
        constraints()
        hideKeyboardWhenTapedAround()
        scrollingAreaWithKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        languageDidChange()
    }
    // MARK: UISettings
    private let scrollView = {
        let scroll = UIScrollView()
        
//        scroll.backgroundColor = .cyan
        scroll.showsVerticalScrollIndicator = false
        if #available(iOS 17.4, *) {
            scroll.bouncesVertically = false
        }
        
        return scroll
    }()
    private let customContentView = {
        let view = UIView()
        
//        view.backgroundColor = .lightGray
        
        return view
    }()
    let titleLabel = {
        let label = UILabel()
       
        label.text = "SIGN_UP".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor._2MainColor111827FFFFFF
        
        return label
    }()
    
    let subTitleLabel = {
        let label = UILabel()
        
        label.text = "FILL_IN_DATA".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.5, alpha: 1)
        
        return label
    }()
    
    let emailLabel = {
        let label = UILabel()
        
        label.text = "Email"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor._2MainColor111827FFFFFF
        
        return label
    }()
    
    lazy var emailTextField: TextFieldWithPadding! = {
        let textfield = TextFieldWithPadding()
        
        textfield.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 16)
        textfield.placeholder = "YOUR_EMAIL".localized()
        textfield.layer.cornerRadius = 12.0
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
        textfield.layer.backgroundColor = UIColor.FFFFFF_1_C_2431.cgColor
        textfield.textContentType = .emailAddress
        textfield.keyboardType = .emailAddress
        textfield.autocapitalizationType = .none
        textfield.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textfield
    }()
    
    let passwordLabel = {
        let label = UILabel()
        
        label.text = "PASSWORD".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor._2MainColor111827FFFFFF
        
        return label
    }()
    
    lazy var passwordTextField: TextFieldWithPadding! = {
        let textfield = TextFieldWithPadding()
   
        textfield.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        textfield.placeholder = "YOUR_PASSWORD".localized()
        textfield.layer.cornerRadius = 12.0
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
        textfield.layer.backgroundColor = UIColor.FFFFFF_1_C_2431.cgColor
        textfield.textContentType = .newPassword
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textfield
    }()
    let passwordConfirmLabel = {
        let label = UILabel()
        
        label.text = "REPEAT_PASSWORD".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor._2MainColor111827FFFFFF
        
        return label
    }()
    lazy var passwordConfirmTextField: TextFieldWithPadding! = {
        let textfield = TextFieldWithPadding()
      
        textfield.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        textfield.placeholder = "YOUR_PASSWORD".localized()
        textfield.layer.cornerRadius = 12.0
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
        textfield.layer.backgroundColor = UIColor.FFFFFF_1_C_2431.cgColor
        textfield.textContentType = .newPassword
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textfield
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
        let button = UIButton()
        
        button.setImage(UIImage(named: "ShowPassword"), for: .normal)
        button.addTarget(self, action: #selector(touchDownShowPassword), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideHidePassword), for: .touchUpInside)
        
        return button
    }()
    let passwordImage2 = {
        let image = UIImageView()
        
        image.image = UIImage(named: "Password")
        
        return image
    }()
    
    lazy var showPasswordButton2 = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "ShowPassword"), for: .normal)
        button.addTarget(self, action: #selector(touchDownShowPassword2), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideHidePassword2), for: .touchUpInside)
        
        return button
    }()
    lazy var signUpButton = {
        let button = UIButton()
        
        button.setTitle("REGISTRATION".localized(), for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for:.normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return button
    }()
    let gotAccountLabel = {
        let label = UILabel()
       
        label.text = "GOT_ACCOUNT".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label.textColor = UIColor._6_B_7280_FFFFFF
        
        return label
    }()
    let signInRecommendsButton = {
        let button = UIButton()
   
        button.setTitle("LOGIN".localized(), for: .normal)
        button.setTitleColor(UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1), for:.normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    lazy var signInButtonView = {
        let view = UIView()
        let label = UILabel()
        let button = UIButton()
        
        view.addSubview(gotAccountLabel)
        view.addSubview(signInRecommendsButton)
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        gotAccountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.verticalEdges.equalToSuperview().inset(0)
            make.left.equalToSuperview().inset(0)
        }
        signInRecommendsButton.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.verticalEdges.equalToSuperview().inset(0)
            make.left.equalTo(gotAccountLabel.snp.right).offset(4)
            make.right.equalToSuperview().inset(0)
        }
        return view
    }()
    let validationEmailLabel = {
        let label = UILabel()
        
        label.text = "WRONG_EMAIL".localized()
        label.font = .appFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        label.isHidden = true
        
        return label
    }()
    let validationPasswordsLabel: () -> UILabel = {
        let label = UILabel()
        
        label.text = ""
        label.font = .appFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        label.isHidden = true
        
        return label
    }
   
    lazy var validationPassword1 = validationPasswordsLabel()
    lazy var validationPassword2 = validationPasswordsLabel()
    
    var validEmailInactiveConstraint: Constraint!
    var validEmailActiveConstraint: Constraint!
    var validPasswordInactiveConstraint: Constraint!
    var validPasswordActiveConstraint: Constraint!
//    var validConfirmPasswordInactiveConstraint: Constraint!
//    var validConfirmPasswordActiveConstraint: Constraint!
    
    // MARK: Constraints
    func constraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(customContentView)
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(subTitleLabel)
        customContentView.addSubview(emailLabel)
        customContentView.addSubview(emailTextField)
        customContentView.addSubview(passwordLabel)
        customContentView.addSubview(passwordTextField)
        customContentView.addSubview(passwordConfirmLabel)
        customContentView.addSubview(passwordConfirmTextField)
        customContentView.addSubview(emailImage)
        customContentView.addSubview(passwordImage)
        customContentView.addSubview(showPasswordButton)
        customContentView.addSubview(passwordImage2)
        customContentView.addSubview(showPasswordButton2)
        customContentView.addSubview(signUpButton)
        customContentView.addSubview(signInButtonView)
        customContentView.addSubview(validationPassword1)
        customContentView.addSubview(validationPassword2)
        customContentView.addSubview(validationEmailLabel)
        
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        customContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView) // ширина должна быть зафиксирована
            make.bottom.equalToSuperview() // чтобы контент не пропадал и расширялся дальше
            // Ограничение по минимальной высоте, чтобы scrollView не схлопывался
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.height).priority(.low)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalToSuperview().inset(dynamicValue(for: 16))
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
        }
        emailLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(subTitleLabel.snp.bottom).offset(dynamicValue(for: 29))
        }
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(emailLabel.snp.bottom).offset(dynamicValue(for: 4))
            make.height.equalTo(56)
        }
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            validEmailInactiveConstraint = make.top.equalTo(emailTextField.snp.bottom).offset(dynamicValue(for: 16)).priority(1000).constraint
            validEmailActiveConstraint = make.top.equalTo(validationEmailLabel.snp.bottom).offset(dynamicValue(for: 16)).priority(500).constraint
        }
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(passwordLabel.snp.bottom).offset(dynamicValue(for: 4))
            make.height.equalTo(56)
        }
        passwordConfirmLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            validPasswordInactiveConstraint = make.top.equalTo(passwordTextField.snp.bottom).offset(dynamicValue(for: 16)).priority(1000).constraint
            validPasswordActiveConstraint = make.top.equalTo(validationPassword1.snp.bottom).offset(dynamicValue(for: 16)).priority(500).constraint
        }
        passwordConfirmTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(passwordConfirmLabel.snp.bottom).offset(dynamicValue(for: 4))
            make.height.equalTo(56)
        }
        emailImage.snp.makeConstraints { make in
            make.left.equalTo(emailTextField.snp.left).inset(dynamicValue(for: 16))
            make.centerY.equalTo(emailTextField)
            make.size.equalTo(20)
        }
        passwordImage.snp.makeConstraints { make in
            make.left.equalTo(passwordTextField.snp.left).inset(dynamicValue(for: 16))
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(20)
        }
        showPasswordButton.snp.makeConstraints { make in
            make.right.equalTo(passwordTextField.snp.right).inset(dynamicValue(for: 0))
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(56)
        }
        passwordImage2.snp.makeConstraints { make in
            make.left.equalTo(passwordConfirmTextField.snp.left).inset(dynamicValue(for: 16))
            make.centerY.equalTo(passwordConfirmTextField)
            make.size.equalTo(20)
        }
        showPasswordButton2.snp.makeConstraints { make in
            make.right.equalTo(passwordConfirmTextField.snp.right).inset(dynamicValue(for: 0))
            make.centerY.equalTo(passwordConfirmTextField)
            make.size.equalTo(56)
        }
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
//            validConfirmPasswordInactiveConstraint = make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(dynamicValue(for: 40)).priority(1000).constraint
//            validConfirmPasswordActiveConstraint = make.top.equalTo(validationPassword2.snp.bottom).offset(dynamicValue(for: 40)).priority(500).constraint
            //            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(40)
            make.bottom.equalTo(signInButtonView.snp.top).offset(dynamicValue(for: -24))
            make.height.equalTo(56)
        }
        signInButtonView.snp.makeConstraints { make in
//            make.top.equalTo(signUpButton.snp.bottom).offset(dynamicValue(for: 24))
            make.bottom.equalToSuperview().offset(dynamicValue(for: -12))
            make.height.equalTo(22)
            make.centerX.equalTo(customContentView)
        }
        validationEmailLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(emailTextField.snp.bottom).offset(dynamicValue(for: 16))
        }
        validationPassword1.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(passwordTextField.snp.bottom).offset(dynamicValue(for: 16))
        }
        validationPassword2.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(dynamicValue(for: 16))
        }
    }
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateTextFieldBackground()
    }
    func updateTextFieldBackground() {
        if traitCollection.userInterfaceStyle == .dark {
            emailTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            emailTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
            passwordTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            passwordTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
            passwordConfirmTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            passwordConfirmTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
        } else {
            emailTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            emailTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
            passwordTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            passwordTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
            passwordConfirmTextField.backgroundColor = UIColor.FFFFFF_1_C_2431
            passwordConfirmTextField.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
        }
    }
    func hideKeyboardWhenTapedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func touchDownShowPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    @objc func touchUpInsideHidePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    @objc func touchDownShowPassword2(_ sender: UIButton) {
        passwordConfirmTextField.isSecureTextEntry.toggle()
    }
    @objc func touchUpInsideHidePassword2(_ sender: UIButton) {
        passwordConfirmTextField.isSecureTextEntry.toggle()
    }
    @objc func editingDidBeginTextField(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        validationPassword1.isHidden = true
        validationPassword2.isHidden = true
        validationEmailLabel.isHidden = true
        validPasswordInactiveConstraint.activate()
//        validConfirmPasswordInactiveConstraint.activate()
        validEmailInactiveConstraint.activate()
        view.layoutIfNeeded()
    }
    @objc func editingDidEndTextField(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor.E_5_EBF_0_374151.cgColor
    }
    @objc func signInButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func signUpButtonTapped() {
        if validaitonAllTextFields() {
            signUpRequest()
        }
    }
    // MARK: Scroll Screen for visibility keyboard
    func scrollingAreaWithKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        
        // Получаем фреймы кнопки signInButton и вью registrationButtonView относительно superview
        let signUpButtonFrame = signUpButton.superview?.convert(signUpButton.frame, to: view)
        let signInButtonViewFrame = signInButtonView.superview?.convert(signInButtonView.frame, to: view)
        
        // Находим максимальную Y-координату между двумя элементами
        if let signUpButtonFrame = signUpButtonFrame, let signInButtonViewFrame = signInButtonViewFrame {
            let maxY = max(signUpButtonFrame.maxY, signInButtonViewFrame.maxY)
            
            // Если максимальная Y-координата выше клавиатуры, добавляем отступ
            if maxY > keyboardFrameInView.origin.y {
                let scrollOffset = maxY - keyboardFrameInView.origin.y + 20 // Учитываем дополнительный отступ
                
                scrollView.contentInset.bottom = scrollOffset
                scrollView.verticalScrollIndicatorInsets.bottom = scrollOffset
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        // Сбрасываем contentInset, когда клавиатура скрывается
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    // MARK: Validation
        func validaitonAllTextFields() -> Bool {
        let validator = Validation()
        let userName = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = passwordConfirmTextField.text!
        
        if (userName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            
            let alert = UIAlertController(title: "INPUT_ERROR".localized(), message: "FILL_ALL_FIELDS".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            emailTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordConfirmTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            print("Fields are empty!")
            
            return false
        }
        if (password != confirmPassword) {
            validationPassword1.text = "PASS_NOT_MATCH".localized()
            validationPassword2.text = "PASS_NOT_MATCH".localized()
            validationPassword1.isHidden = false
            validationPassword2.isHidden = false
            validPasswordInactiveConstraint.deactivate()
//            validConfirmPasswordInactiveConstraint.deactivate()
            view.layoutIfNeeded()
            passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordConfirmTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            print("Passwords are not the same")
            
            return false
        }
        if validator.isValidMail(email: userName) == false {
            validationEmailLabel.isHidden = false
            validEmailInactiveConstraint.deactivate()
            view.layoutIfNeeded()
            emailTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            print("Mistake with email format")
            
            return false
        }
        if validator.isValidPassword(password: password) == false || validator.isValidPassword(password: confirmPassword) == false {
            
            let alert = UIAlertController(title: "INPUT_ERROR".localized(), message: "WRONG_PASSWORD_TEXT".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            validationPassword1.text = "WRONG_PASSWORD".localized()
            validationPassword2.text = "WRONG_PASSWORD".localized()
            validationPassword1.isHidden = false
            validationPassword2.isHidden = false
            validPasswordInactiveConstraint.deactivate()
//            validConfirmPasswordInactiveConstraint.deactivate()
            view.layoutIfNeeded()
            
            passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordConfirmTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            
            print("Mistake with password format")
            
            return false
        }
            print("All good")
            return true
    }

    // MARK: SignUp request
    @objc func signUpRequest() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show()
        
        let parameters = ["email": email,
                          "password": password]
        
        AF.request(URLs.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
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
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func startApp() {
        let tabBarVC = TabBarController()

        tabBarVC.modalPresentationStyle = .fullScreen
        
        present(tabBarVC, animated: true, completion: nil)
    }
    //MARK: Localization
    func languageDidChange() {
        titleLabel.text = "SIGN_UP".localized()
        subTitleLabel.text = "FILL_IN_DATA".localized()
        emailTextField.placeholder = "YOUR_EMAIL".localized()
        passwordLabel.text = "PASSWORD".localized()
        passwordTextField.placeholder = "YOUR_PASSWORD".localized()
        passwordConfirmLabel.text = "REPEAT_PASSWORD".localized()
        passwordConfirmTextField.placeholder = "YOUR_PASSWORD".localized()
        gotAccountLabel.text = "GOT_ACCOUNT".localized()
        signInRecommendsButton.setTitle("LOGIN".localized(), for: .normal)
    }
}
