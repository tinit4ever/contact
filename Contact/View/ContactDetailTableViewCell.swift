//
//  ContactDetailTableViewCell.swift
//  Contact
//
//  Created by tinit on 31/10/2023.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {
    static let identifier: String = "ContactDetailTableViewCell"
    
//    private let textLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "TEST"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    private let cellContent: UIListContentConfiguration

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
//        contentView.addSubview(cellContent)
    }

}
