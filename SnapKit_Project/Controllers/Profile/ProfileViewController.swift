//
//  ProfileViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {
    
    var userData: Profile?
    
// MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_1_C_2431
        navigationItem.backButtonTitle = ""
        сonstraints()
        updateAvatarImage()
        logOutBtnNavbar()
        checkSwitchState()
        downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageDidChange()
    }
    override func viewDidAppear(_ animated: Bool) {
    }

// MARK: UIElements
    let avatarImageView: UIImageView = {
        let image = UIImageView()
        //        image.image = UIImage(named: "Avatar")
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 56
        image.clipsToBounds = true
        
        return image
    }()
    
    let deleteAvatarButton = {
        let button = UIButton()
        
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 9)!
        button.setTitleColor(UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(deleteAvatar), for: .touchUpInside)
        button.setImage(UIImage(named: "trash") , for: .normal)
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Менің профилім"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(named: "111827-FFFFFF")
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "@mail.ru"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return label
    }()
    
    let backgroundView = {
        let view = UIView()
        view.backgroundColor = UIColor.F_9_FAFB_111827
        
        return view
    }()
    
    let personalDataButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Жеке деректер", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(UIColor(named: "E5E7EB-1C2431"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(personalDataBtnTaped), for: .touchUpInside)
        
        return button
    }()
    lazy var arrowImage1 = arrowImageFactory()
    lazy var arrowImage2 = arrowImageFactory()
    lazy var arrowImage3 = arrowImageFactory()

    lazy var lineView1 = lineViewFactory()
    lazy var lineView2 = lineViewFactory()
    lazy var lineView3 = lineViewFactory()
    
    let personalDataLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Өңдеу"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return label
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Құпия сөзді өзгерту", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(UIColor(named: "E5E7EB-1C2431"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(changePasswordBtnTaped), for: .touchUpInside)
        
        return button
    }()
    
    let languageChangeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Тіл", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(UIColor(named: "E5E7EB-1C2431"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(languageButtonTaped), for: .touchUpInside)
        
        return button
    }()
    
    let languageLabel = {
        let label = UILabel()
        
        label.text = "Қазақша"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return label
    }()
    
    let darkModeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Қараңғы режим", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(UIColor(named: "E5E7EB-1C2431"), for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let darkModeSwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = UIColor(red: 0.7, green: 0.46, blue: 0.97, alpha: 1)
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        return switchControl
    }()
    
    private let changeAvatarButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        
        return button
    }()
    private func logOutBtnNavbar() {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(UIImage(named: "Logout"), for: .normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        logoutButton.addTarget(self, action: #selector(logOutBtnTapped), for: .touchUpInside)
        logoutButton.tintColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        
        let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    let imagePicker = ImagePicker()
    
//    let openApudioPlayer = {
//        let button = UIButton()
//        
//        button.setTitle("Audio Player!", for: .normal)
//        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
//        button.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
//        button.contentHorizontalAlignment = .left
//        button.addTarget(self, action: #selector(audioPlayerTaped), for: .touchUpInside)
//        return button
//    }()
// MARK: Constraints
    func сonstraints() {
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(dynamicValue(for: 112))
            make.top.equalTo(view.safeAreaLayoutGuide).inset(dynamicValue(for: 32))
            make.centerX.equalTo(view)
        }
        view.addSubview(deleteAvatarButton)
        deleteAvatarButton.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(dynamicValue(for: 16))
            make.bottom.equalTo(avatarImageView)
            make.size.equalTo(dynamicValue(for: 16))
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(dynamicValue(for: 32))
            make.centerX.equalTo(view)
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(dynamicValue(for: 8))
            make.centerX.equalTo(view)
        }
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(emailLabel.snp.bottom).offset(dynamicValue(for: 24))
        }
        view.addSubview(personalDataButton)
        personalDataButton.snp.makeConstraints {make in
            make.top.equalTo(emailLabel.snp.bottom).offset(dynamicValue(for: 24))
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 64))
        }
        view.addSubview(arrowImage1)
        arrowImage1.snp.makeConstraints { make in
            make.centerY.equalTo(personalDataButton)
            make.right.equalTo(personalDataButton.snp.right).inset(0)
            make.size.equalTo(dynamicValue(for: 16))
        }
        view.addSubview(lineView1)
        lineView1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(personalDataButton.snp.bottom).offset(0)
        }
        view.addSubview(personalDataLabel)
        personalDataLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personalDataButton)
            make.right.equalTo(arrowImage1.snp.left).offset(dynamicValue(for: -8))
        }
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(lineView1.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 64))
        }
        view.addSubview(arrowImage2)
        arrowImage2.snp.makeConstraints { make in
            make.centerY.equalTo(changePasswordButton)
            make.right.equalTo(changePasswordButton.snp.right).inset(0)
            make.size.equalTo(dynamicValue(for: 16))
        }
        view.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(changePasswordButton.snp.bottom).offset(0)
        }
        view.addSubview(languageChangeButton)
        languageChangeButton.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 64))
        }
        view.addSubview(arrowImage3)
        arrowImage3.snp.makeConstraints { make in
            make.centerY.equalTo(languageChangeButton)
            make.right.equalTo(languageChangeButton.snp.right).inset(0)
            make.size.equalTo(dynamicValue(for: 16))
        }
        view.addSubview(lineView3)
        lineView3.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.top.equalTo(languageChangeButton.snp.bottom).offset(0)
        }
        view.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(languageChangeButton)
            make.right.equalTo(arrowImage3.snp.left).offset(dynamicValue(for: -8))
        }
        view.addSubview(darkModeButton)
        darkModeButton.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
            make.height.equalTo(dynamicValue(for: 64))
        }
        view.addSubview(darkModeSwitch)
        darkModeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(darkModeButton)
            make.right.equalTo(darkModeButton.snp.right).inset(0)
        }
        view.addSubview(changeAvatarButton)
        changeAvatarButton.snp.makeConstraints { make in
            make.size.equalTo(104)
            make.centerX.equalTo(avatarImageView)
            make.centerY.equalTo(avatarImageView)
        }
//        view.addSubview(openApudioPlayer)
//        openApudioPlayer.snp.makeConstraints { make in
//            make.top.equalTo(darkModeButton.snp.bottom).offset(0)
//            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 24))
//            make.height.equalTo(dynamicValue(for: 64))
//        }
    }
    
    // MARK: Localize
    func configureLanguage() {
        
        titleLabel.text = "MY_PROFILE".localized()
        personalDataButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        personalDataLabel.text = "EDIT".localized()
        changePasswordButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        languageChangeButton.setTitle("LANGUAGE".localized(), for: .normal)
        languageLabel.text = "CURRENT_LANGUAGE".localized()
        darkModeButton.setTitle("DARK_MODE".localized(), for: .normal)
        
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
            personalDataLabel.text = "Изменить"
            navigationItem.title = "Профиль"
        }
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
            personalDataLabel.text = "Өңдеу"
            navigationItem.title = "Профиль"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
            personalDataLabel.text = "Edit"
            navigationItem.title = "Profile"
        }
    }
    
// MARK: Functions
    let defaults = UserDefaults.standard
    let themeKey = "appKey"
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            defaults.set(true, forKey: themeKey)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        } else {
            defaults.set(false, forKey: themeKey)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
    func checkSwitchState() {
        if defaults.bool(forKey: themeKey) {
            darkModeSwitch.setOn(true, animated: true)
        } else {
            darkModeSwitch.setOn(false, animated: true)
        }
            
    }

    @objc func languageButtonTaped() {
        let languageVC = LanguageViewController()
        
        languageVC.modalPresentationStyle = .overFullScreen
        languageVC.languageDelegate = self
        present(languageVC, animated: true)
        
    }
    func languageDidChange() {
        configureLanguage()
        print(Localize.currentLanguage())
    }
    @objc func showImagePicker() {
        imagePicker.showImagePicker(in: self) { image in
            self.avatarImageView.image = image
        }
    }
    func updateAvatarImage() {
        if let imageData = UserDefaults.standard.data(forKey: "avatarImage"),
           let savedImage = UIImage(data: imageData) {
            avatarImageView.image = savedImage
        } else {
            avatarImageView.image = UIImage(named: "DefaultAvatar")
        }
    }
    @objc func deleteAvatar() {
        UserDefaults.standard.removeObject(forKey: "avatarImage")
        updateAvatarImage()
    }
    @objc func logOutBtnTapped() {
        let vc = LogOutViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
//    @objc func audioPlayerTaped() {
//        let VC = ToothlessDancing()
//        navigationController?.pushViewController(VC, animated: true)
//    }
    @objc func personalDataBtnTaped() {
        let VC = PersonalDataViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    @objc func changePasswordBtnTaped() {
        let VC = ChangePasswordViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // MARK: API request - downloadData: email
    func setData() {
        guard let userData = userData else { return }
        emailLabel.text = userData.user_email
    }
    func downloadData() {
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request("http://api.ozinshe.com/core/V1/user/profile", method: .get, headers: headers).responseData { response in
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                self.userData = Profile(json: json)
                self.setData()
                
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
} // Profile class


// MARK: ImagePickerClass
    class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: UIImagePickerController?
        var completion: ((UIImage) -> ())?
        
        func showImagePicker(in ViewController: ProfileViewController, avatarImage: ((UIImage) -> ())?){
            self.completion = avatarImage
            imagePickerController = UIImagePickerController()
            imagePickerController?.delegate = self
            ViewController.present(imagePickerController!, animated: true)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Извлечение изображения из галереи ↓
            if let image = info[.originalImage] as? UIImage {
                self.completion?(image)
                // Изображения сохраняется но отображается не сразу ↓
                if let imageData = image.pngData() {
                    UserDefaults.standard.set(imageData, forKey: "avatarImage")
                    Storage.sharedInstance.avatarImage = imageData
                    print("Saved")
                }
                picker.dismiss(animated: true)
            }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

}
