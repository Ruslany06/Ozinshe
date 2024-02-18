//
//  FriendsTableViewController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 28.11.2023.
//

import UIKit
import SnapKit

class FriendsViewController: UIViewController {
    
    lazy var tableView1: UITableView = {
        let tv = UITableView()
        
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureView()
        
    }
    
    func configureView() {
        view.addSubview(tableView1)
        
        tableView1.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
    extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendsTableViewCell()
        return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        }
    
}

