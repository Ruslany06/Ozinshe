//
//  ChangePasswordViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 21.03.2024.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Құпия сөзді өзгерту"
        
        hideKeyboardWhenTapedAround()
        constraints()
    }
    
    private let passwordLabel = {
        let label = UILabel()
        
        label.text = "Құпия сөз"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    
    private lazy var passwordTextField: TextFieldWithPadding! = {
        let textField = TextFieldWithPadding()
        
        textField.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        textField.placeholder = "Сіздің құпия сөзіңіз"
        textField.layer.cornerRadius = 12.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textField
    }()
    private let passwordConfirmLabel = {
        let label = UILabel()
        
        label.text = "Құпия сөзді қайталаңыз"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
        return label
    }()
    private lazy var passwordConfirmTextField: TextFieldWithPadding! = {
        let textField = TextFieldWithPadding()
        
        textField.padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        textField.placeholder = "Сіздің құпия сөзіңіз"
        textField.layer.cornerRadius = 12.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(editingDidBeginTextField), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField), for: .editingDidEnd)
        
        return textField
    }()
    
    private let passwordImage = {
        let image = UIImageView()
        
        image.image = UIImage(named: "Password")
        
        return image
    }()
    
    private lazy var showPasswordButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "ShowPassword"), for: .normal)
        button.addTarget(self, action: #selector(touchDownShowPassword), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideHidePassword), for: .touchUpInside)
        
        return button
    }()
    private let passwordImage2 = {
        let image = UIImageView()
        
        image.image = UIImage(named: "Password")
        
        return image
    }()
    
    private lazy var showPasswordButton2 = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "ShowPassword"), for: .normal)
        button.addTarget(self, action: #selector(touchDownShowPassword2), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideHidePassword2), for: .touchUpInside)
        
        return button
    }()
    
    private let saveChangesButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        button.setTitle("Өзгерістерді сақтау", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveChangesBtnTapped), for: .touchUpInside)
        
        return button
    }()
    private let validationLabel = {
        let lbl = UILabel()
        
        lbl.text = "Құпия сөздер сәйкес келмеді"
        lbl.font = .appFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        lbl.isHidden = true
        
        return lbl
    }()
    
    var validLabelConstraint: Constraint!
    
    // MARK: Constraints
    private func constraints() {
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmLabel)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(passwordImage)
        view.addSubview(showPasswordButton)
        view.addSubview(passwordImage2)
        view.addSubview(showPasswordButton2)
        view.addSubview(saveChangesButton)
        view.addSubview(validationLabel)
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordImage.snp.makeConstraints {make in
            make.left.equalTo(passwordTextField.snp.left).inset(16)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(20)
        }
        showPasswordButton.snp.makeConstraints { make in
            make.right.equalTo(passwordTextField.snp.right).inset(16)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(56)
        }
        passwordConfirmLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        passwordConfirmTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordImage2.snp.makeConstraints {make in
            make.left.equalTo(passwordConfirmTextField.snp.left).inset(16)
            make.centerY.equalTo(passwordConfirmTextField)
            make.size.equalTo(20)
        }
        showPasswordButton2.snp.makeConstraints { make in
            make.right.equalTo(passwordConfirmTextField.snp.right).inset(16)
            make.centerY.equalTo(passwordConfirmTextField)
            make.size.equalTo(56)
        }
        saveChangesButton.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(24).priority(.medium)
            validLabelConstraint = make.top.equalTo(validationLabel.snp.bottom).offset(16).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    //MARK: Functions
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
        validationLabel.isHidden = true
        validLabelConstraint.update(priority: .low)
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    @objc func editingDidEndTextField(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    func validationTextFields() -> Bool {
        let validator = Validation()
        let password = passwordTextField.text!
        let confirmPassword = passwordConfirmTextField.text!
        
        if password.isEmpty || confirmPassword.isEmpty {
            print("Some fields are empty")
            return false
        }
        if (password != confirmPassword) {
//            validationLabel.text = "Құпия сөз сәйкес келмеді"
            validationLabel.isHidden = false
            validLabelConstraint.update(priority: .high)
            view.layoutIfNeeded()
            
            passwordTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            passwordConfirmTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            print("Passwords are not the same")
            
            return false
        }
        print("All good")
        return true
    }
    @objc func saveChangesBtnTapped() {
        if validationTextFields(){
            saveChanges()
        }
    }
    //MARK: AF request - saveChanges
    func saveChanges(){
         
            SVProgressHUD.show()
            
            let password = passwordTextField.text!
            let confirmPassword = passwordConfirmTextField.text!
            
            let parameters = ["password" : password]
                    
            let headers: HTTPHeaders = [
                "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
            ]
            
            AF.request("http://api.ozinshe.com/core/V1/user/profile/changePassword", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                
                SVProgressHUD.dismiss()
                
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                }
                
                if response.response?.statusCode == 200 {
                    SVProgressHUD.showSuccess(withStatus: "Password changed")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                } else {
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }
        
    }
    

}
