//
//  ViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 02.11.2023.
//

import UIKit
import SnapKit


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        let label2 = UILabel()
        let button = UIButton()
        
        
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(button)
        
        
        label.text = "Salam bro!"
        
        label2.text = "Aleikum bro!"
        
        button.setTitle("Lets go bro", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.equalToSuperview().inset(24)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(24)
        }
        button.snp.makeConstraints {make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.horizontalEdges.equalToSuperview().inset(44)
            make.height.equalTo(44)
        }
        
    }
  
    @objc func buttonTaped() {
        let secondVC = SecondViewController()
        
        navigationController?.show(secondVC, sender: self)
    }
    
}

    