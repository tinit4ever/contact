//
//  ContactTableViewCell.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    var nameLabel: UILabel!
    
    static let identifier: String = "ContactTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        applyContrains()
    }
    
    func applyContrains() {
        let nameLabelContrains = [
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelContrains)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
