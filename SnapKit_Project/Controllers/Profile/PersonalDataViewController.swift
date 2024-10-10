//
//  PersonalDataViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 21.03.2024.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import Localize_Swift

class PersonalDataViewController: UIViewController, UITextFieldDelegate {

    var userData: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor._1MainColorFFFFFF111827
        navigationItem.title = "PERSONAL_DATA".localized()
        
        constraints()
        hideKeyboardWhenTapedAround()
        scrollingAreaWithKeyboard()
        setData()
        downloadData()
        
    }
    
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
    private let nameLabel = {
        let lbl = UILabel()
        
        lbl.text = "YOUR_NAME".localized()
        lbl.font = .appFont(ofSize: 14, weight: .bold)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private lazy var userNameTextField = {
        let textfield = UITextField()
        
        textfield.font = .appFont(ofSize: 16, weight: .semiBold)
        textfield.textColor = UIColor(named: "111827-FFFFFF")
        textfield.textContentType = .name
        textfield.autocapitalizationType = .none
        
        return textfield
    }()
    
    private let line1 = lineViewFactory()
    
    private let emailLabel = {
        let lbl = UILabel()
        
        lbl.text = "Email"
        lbl.font = .appFont(ofSize: 14, weight: .bold)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private let emailAdressLabel = {
        let lbl = UILabel()
        
        lbl.text = "xxxx@mail.ru"
        lbl.font = .appFont(ofSize: 16, weight: .semiBold)
        lbl.textColor = UIColor(named: "111827-FFFFFF")
        
        return lbl
    }()
    
    private let line2 = lineViewFactory()
    
    private let phoneNumberLabel = {
        let lbl = UILabel()
        
        lbl.text = "TELEPHONE".localized()
        lbl.font = .appFont(ofSize: 14, weight: .bold)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private lazy var phoneNumberTextField = {
        let textfield = UITextField()
        
        textfield.font = .appFont(ofSize: 16, weight: .semiBold)
        textfield.textColor = UIColor(named: "111827-FFFFFF")
        textfield.textContentType = .telephoneNumber
        textfield.keyboardType = .phonePad
        textfield.delegate = self
        
        return textfield
    }()
    
    private let line3 = lineViewFactory()
    
    private let dateOfBirthLabel = {
        let lbl = UILabel()
        
        lbl.text = "DATE_OF_BIRTH".localized()
        lbl.font = .appFont(ofSize: 14, weight: .bold)
        lbl.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return lbl
    }()
    private lazy var dateOfBirthTextField = {
        let textfield = UITextField()
        
        textfield.font = .appFont(ofSize: 16, weight: .semiBold)
        textfield.textColor = UIColor(named: "111827-FFFFFF")
        textfield.inputView = datePicker
        
        return textfield
    }()
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private let line4 = lineViewFactory()
    
    private let saveChangesButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.5, green: 0.18, blue: 0.99, alpha: 1)
        button.setTitle("SAVE_CHANGES".localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveChangesBtnTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = dynamicValue(for: 68)
        
        return stackView
    }()
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = dynamicValue(for: 65)
        
        return stackView
    }()
    private lazy var linesStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = dynamicValue(for: 88)
        
        return stackView
    }()
    
    // MARK: Constraints
    func constraints() {
//        view.addSubview(nameLabel)
//        view.addSubview(nameTextField)
//        view.addSubview(line1)
//        view.addSubview(emailLabel)
//        view.addSubview(emailTextField)
//        view.addSubview(line2)
//        view.addSubview(phoneNumberLabel)
//        view.addSubview(phoneNumberTextField)
//        view.addSubview(line3)
//        view.addSubview(datebirthLabel)
//        view.addSubview(dateBirthTextField)
//        view.addSubview(line4)
        
        view.addSubview(scrollView)
        scrollView.addSubview(customContentView)
        customContentView.addSubview(labelsStackView)
        customContentView.addSubview(linesStackView)
        // Стек текстовых полей на самом вверху, так как его могут перекрывать другие стеки или элементы и открытие клавиатуры может быть невозможным
        customContentView.addSubview(textFieldsStackView)
        customContentView.addSubview(saveChangesButton)
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(emailLabel)
        labelsStackView.addArrangedSubview(phoneNumberLabel)
        labelsStackView.addArrangedSubview(dateOfBirthLabel)
        
        linesStackView.addArrangedSubview(line1)
        linesStackView.addArrangedSubview(line2)
        linesStackView.addArrangedSubview(line3)
        linesStackView.addArrangedSubview(line4)
        
        textFieldsStackView.addArrangedSubview(userNameTextField)
        textFieldsStackView.addArrangedSubview(emailAdressLabel)
        textFieldsStackView.addArrangedSubview(phoneNumberTextField)
        textFieldsStackView.addArrangedSubview(dateOfBirthTextField)
        
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
        
        labelsStackView.snp.makeConstraints { make in
            
            nameLabel.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 21)) }
            emailLabel.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 21)) }
            phoneNumberLabel.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 21)) }
            dateOfBirthLabel.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 21)) }
            
            make.top.equalToSuperview().inset(dynamicValue(for: 24))
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
        }
        
        textFieldsStackView.snp.makeConstraints { make in
            
            userNameTextField.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 24)) }
            emailAdressLabel.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 24)) }
            phoneNumberTextField.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 24)) }
            dateOfBirthTextField.snp.makeConstraints { make in make.height.equalTo(dynamicValue(for: 24)) }
            
            make.top.equalToSuperview().inset(dynamicValue(for: 53))
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
        }
        
        linesStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(dynamicValue(for: 88))
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
        }
        
        saveChangesButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(dynamicValue(for: 8))
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 56))
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
    
    private var selectedDate: Date?
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        if Localize.currentLanguage() == "kk" {
            formatter.locale = Locale(identifier: "kk_KZ")
        }
        if Localize.currentLanguage() == "ru" {
            formatter.locale = Locale(identifier: "ru_RU")
        }
        if Localize.currentLanguage() == "en" {
            formatter.locale = Locale(identifier: "en_ENG")
        }
        
        formatter.dateFormat = "dd MMMM yyyy"
        let dateString = formatter.string(from: sender.date)
        dateOfBirthTextField.text = dateString
        
        // Сохраняем выбранную дату для последующей отправки на сервер
        selectedDate = sender.date
    }
    
    func updateDateOfBirthDisplay() {
        guard let birthDateString = userData?.birthDate else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Формат даты от сервера
        if let birthDate = formatter.date(from: birthDateString) {
            
            // Форматируем дату для отображения
            formatter.dateFormat = "dd MMMM yyyy"
            
            if Localize.currentLanguage() == "kk" {
                formatter.locale = Locale(identifier: "kk_KZ")
            }
            if Localize.currentLanguage() == "ru" {
                formatter.locale = Locale(identifier: "ru_RU")
            }
            if Localize.currentLanguage() == "en" {
                formatter.locale = Locale(identifier: "en_ENG")
            }
            
            let displayDateString = formatter.string(from: birthDate)
            dateOfBirthTextField.text = displayDateString // Обновляем текстовое поле
        }
    }

    @objc func saveChangesBtnTapped() {
        
        if validationOfAllTextfields() {
            saveChanges(self)
        }
    }
// MARK: Validation and format
    // mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X (XXX) XXX-XX-XX", phone: newString)
        return false
    }
    
    private func validationOfAllTextfields() -> Bool {
        let validator = Validation()
        let phoneNumber = phoneNumberTextField.text!
        let userName = userNameTextField.text!
        
        if userName.isEmpty {
            
            userNameTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            let alert = UIAlertController(title: "INPUT_ERROR".localized(), message: "FILL_ALL_FIELDS".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print("Username is empty")
            return false
        }
        if phoneNumber.isEmpty {
            
            phoneNumberTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            let alert = UIAlertController(title: "INPUT_ERROR".localized(), message: "FILL_ALL_FIELDS".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print("Phone number is empty")
            return false
        }
        
        if validator.isValid(name: userName) == false {
            
            userNameTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            let alert = UIAlertController(title: "WRONG_FORMAT".localized(), message: "WRONG_FORMAT_TEXT".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print("Wrong name format!!")
            
            return false
        }
        
        if validator.isValidPhoneNumber(phoneNumber) == false {
            
            phoneNumberTextField.layer.borderColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1).cgColor
            let alert = UIAlertController(title: "INPUT_ERROR".localized(), message: "FILL_ALL_FIELDS".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print("Wrong number format!!!")
            
            return false
        }
        
        print("All good")
        return true
    }

// MARK: Scroll Screen for visibility keyboard
    func scrollingAreaWithKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let saveButtonFrame = saveChangesButton.superview?.convert(saveChangesButton.frame, to: view) else {
            return
        }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        
        if saveButtonFrame.maxY > keyboardFrameInView.origin.y {
            let scrollOffset = saveButtonFrame.maxY - keyboardFrameInView.origin.y + 20 // отступ
                
            scrollView.contentInset.bottom = scrollOffset
            scrollView.verticalScrollIndicatorInsets.bottom = scrollOffset
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        // Сбрасываем contentInset, когда клавиатура скрывается
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: AF request - DownloadData
    func setData() {
        
        guard let userData = userData else {
            return
        }
        userNameTextField.text = userData.name
        phoneNumberTextField.text = userData.phoneNumber
//        dateOfBirthTextField.text = userData.birthDate
        emailAdressLabel.text = userData.user_email
        
        updateDateOfBirthDisplay()
    }
    
    func downloadData() {
//        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request("http://api.ozinshe.com/core/V1/user/profile", method: .get, headers: headers).responseData { response in
            
//            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                self.userData = Profile(json: json)
                self.setData()
                self.updateDateOfBirthDisplay()
                
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
    // MARK: API request - Save changes
    func saveChanges(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd" // Формат для сервера
           
           // Преобразуем выбранную дату (из UIDatePicker), если она есть
           var birthDate = ""
           if let selectedDate = selectedDate {
               birthDate = formatter.string(from: selectedDate)
           } else {
               // Можно обработать случай, если дата не выбрана, и сделать валидный запрос
               birthDate = userData?.birthDate ?? "" // Либо используйте старую дату
           }
        
       
        let email = userNameTextField.text!
//        let birthDate = dateOfBirthTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let language = userData?.language
        
        let parameters = ["name" : email, "birthDate" : birthDate, "phoneNumber" : phoneNumber, "language" : language]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request("http://api.ozinshe.com/core/V1/user/profile/", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
            }
            
            if response.response?.statusCode == 200 {
                self.downloadData()
                
                SVProgressHUD.showSuccess(withStatus: "CHANGES_APPLIED".localized())
                SVProgressHUD.dismiss(withDelay: 1.5)
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
                SVProgressHUD.dismiss(withDelay: 2.5)
            }
        }
    }
    
    
}

