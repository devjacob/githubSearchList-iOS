//
//  RepositoryCell.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import UIKit

class RepositoryCell: UICollectionViewCell {
    // fullname
    // Owner name
    // itemPrivate
    // itemDescription

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func bind(_ item: Item) {
        print(item)
        fullnameLabel.text = item.fullName
        descriptionLabel.text = item.itemDescription
    }

    func heightFor(_ width: CGFloat) -> CGFloat {
        frame.size = CGSize(width: width, height: frame.size.height)
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(frame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return size.height
    }
}
