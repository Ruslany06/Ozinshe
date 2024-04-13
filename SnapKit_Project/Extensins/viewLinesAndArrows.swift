//
//  viewLinesAndArrows.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 24.02.2024.
//

import UIKit


public let arrowImageFactory: () -> UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "Arrow")
    return image
}

public let lineViewFactory: () -> UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 1).isActive = true
    return view
}

