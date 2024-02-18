//
//  ProfileViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {
    
// MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Constraints()
        updateAvatarImage()
        logOutBtnNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageDidChange()
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
        
        button.setTitle("Удалить фото профиля", for: .normal)
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
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1)
        
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
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        
        return view
    }()
    
    let privateInfoButton: UIButton = {
        let button = UIButton()
        let colorBlack = UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1)
        
        button.setTitle("Жеке деректер", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(colorBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let arrowImageFactory: () -> UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Arrow")
        return image
    }
    lazy var arrowImage1 = arrowImageFactory()
    lazy var arrowImage2 = arrowImageFactory()
    lazy var arrowImage3 = arrowImageFactory()
    
    let lineViewFactory: () -> UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    lazy var line1 = lineViewFactory()
    lazy var line2 = lineViewFactory()
    lazy var line3 = lineViewFactory()
    
    let privateInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Өңдеу"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        
        return label
    }()
    
    let passwordChangeButton: UIButton = {
        let button = UIButton()
        let colorBlack = UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1)
        
        button.setTitle("Құпия сөзді өзгерту", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(colorBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let languageChangeButton: UIButton = {
        let button = UIButton()
        let colorBlack = UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1)
        
        button.setTitle("Тіл", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(colorBlack, for: .normal)
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
    
    let darkmodeButton: UIButton = {
        let button = UIButton()
        let colorBlack = UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1)
        
        button.setTitle("Қараңғы режим", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(colorBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let darkmodeSwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        return switchControl
    }()
    
    let changeAvatarButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        
        return button
    }()
    func logOutBtnNavbar() {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(UIImage(named: "Logout"), for: .normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        logoutButton.addTarget(self, action: #selector(logOutBtnTapped), for: .touchUpInside)
        logoutButton.tintColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        
        let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    let imagePicker = ImagePicker()
    
    let secretBtn = {
        let button = UIButton()
        
        button.setTitle("DONT CLICK!", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)!
        button.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(secretBtnTaped), for: .touchUpInside)
        return button
    }()
// MARK: Constraints
    func Constraints() {
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(112)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalTo(view)
        }
        view.addSubview(deleteAvatarButton)
        deleteAvatarButton.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.bottom.equalTo(avatarImageView)
            make.size.equalTo(16)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(32)
            make.centerX.equalTo(view)
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(view)
        }
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
        }
        view.addSubview(privateInfoButton)
        privateInfoButton.snp.makeConstraints {make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        view.addSubview(arrowImage1)
        arrowImage1.snp.makeConstraints { make in
            make.centerY.equalTo(privateInfoButton)
            make.right.equalTo(privateInfoButton.snp.right).inset(0)
            make.size.equalTo(16)
        }
        view.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(privateInfoButton.snp.bottom).offset(0)
        }
        view.addSubview(privateInfoLabel)
        privateInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privateInfoButton)
            make.right.equalTo(arrowImage1.snp.left).offset(-8)
        }
        view.addSubview(passwordChangeButton)
        passwordChangeButton.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        view.addSubview(arrowImage2)
        arrowImage2.snp.makeConstraints { make in
            make.centerY.equalTo(passwordChangeButton)
            make.right.equalTo(passwordChangeButton.snp.right).inset(0)
            make.size.equalTo(16)
        }
        view.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(passwordChangeButton.snp.bottom).offset(0)
        }
        view.addSubview(languageChangeButton)
        languageChangeButton.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        view.addSubview(arrowImage3)
        arrowImage3.snp.makeConstraints { make in
            make.centerY.equalTo(languageChangeButton)
            make.right.equalTo(languageChangeButton.snp.right).inset(0)
            make.size.equalTo(16)
        }
        view.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(languageChangeButton.snp.bottom).offset(0)
        }
        view.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(languageChangeButton)
            make.right.equalTo(arrowImage3.snp.left).offset(-8)
        }
        view.addSubview(darkmodeButton)
        darkmodeButton.snp.makeConstraints { make in
            make.top.equalTo(line3.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        view.addSubview(darkmodeSwitch)
        darkmodeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(darkmodeButton)
            make.right.equalTo(darkmodeButton.snp.right).inset(0)
        }
        view.addSubview(changeAvatarButton)
        changeAvatarButton.snp.makeConstraints { make in
            make.size.equalTo(104)
            make.centerX.equalTo(avatarImageView)
            make.centerY.equalTo(avatarImageView)
        }
        view.addSubview(secretBtn)
        secretBtn.snp.makeConstraints { make in
            make.top.equalTo(darkmodeButton.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
    }
    
    // MARK: Localize
    func configureLanguage() {
        
        titleLabel.text = "MY_PROFILE".localized()
        privateInfoButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        privateInfoLabel.text = "EDIT".localized()
        passwordChangeButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        languageChangeButton.setTitle("LANGUAGE".localized(), for: .normal)
        languageLabel.text = "CURRENT_LANGUAGE".localized()
        darkmodeButton.setTitle("DARK_MODE".localized(), for: .normal)
        
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
            privateInfoLabel.text = "Изменить"
            navigationItem.title = "Профиль"
        }
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
            privateInfoLabel.text = "Өңдеу"
            navigationItem.title = "Профиль"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
            privateInfoLabel.text = "Edit"
            navigationItem.title = "Profile"
        }
    }
// MARK: Functions
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Switch is ON")
        } else {
            print("Switch is OFF")
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
    @objc func secretBtnTaped() {
        let VC = ToothlessDancing()
        navigationController?.show(VC, sender: self)
    }
    
}

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
