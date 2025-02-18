//
//  SimpleTableViewCell.swift
//  RxPractice
//
//  Created by 박준우 on 2/18/25.
//

import UIKit

final class SimpleTableViewCell: UITableViewCell {
    static let id: String = "SimpleTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .detailButton
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
