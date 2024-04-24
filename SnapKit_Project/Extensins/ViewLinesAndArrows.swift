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
    view.backgroundColor = UIColor(named: "D1D5DB-1C2431")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 1).isActive = true
    return view
}

