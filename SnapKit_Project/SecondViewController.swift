//
//  SecondViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 02.11.2023.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        let image = UIImageView()
        
        view.addSubview(image)
        
        image.image = UIImage(named: "flower")
        image.contentMode = .scaleAspectFit
        
        image.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view).inset(0)
            make.horizontalEdges.equalTo(view).inset(0)
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
