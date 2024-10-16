//
//  SearchCollectionViewCell.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 17.01.2024.
//

import UIKit
import SnapKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

// MARK: SearchCVC
class SearchCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.searchCellColorF3F4F6374151
        contentView.layer.cornerRadius = 8
        constraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
  
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? UIColor.highlitedSearchCellColorE5E7EB1C2431 : UIColor.searchCellColorF3F4F6374151
        }
    }
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.highlitedSearchCellColorE5E7EB1C2431 : UIColor.searchCellColorF3F4F6374151
        }
    }
    
    let cellView = {
        let view = UIView()

        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        
        return view
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.text = "label text in cell"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        label.textColor = UIColor._2MainColor111827FFFFFF
//        label.layer.borderWidth = 1
        
        return label
    }()
    
    func constraints() {
        
        contentView.addSubview(cellView)
        contentView.addSubview(categoryLabel)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(dynamicValue(for: 16))
            make.verticalEdges.equalToSuperview().inset(0)
            make.height.equalTo(dynamicValue(for: 34))
        }
    }
    
    // Functions
    func setData(categories: Categories) {
        categoryLabel.text = categories.name
    }
    
}


