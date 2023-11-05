//
//  ContactDetailViewController.swift
//  Contact
//
//  Created by tinit on 31/10/2023.
//
//
import UIKit

class ContactDetailViewController: UIViewController {
    var contactViewModel: ContactViewModelProtocol?
    // Create UI
    
    enum ContactDetailSection: Int {
        case phone = 0
        case mail = 1
        case note = 2
    }
    
    var contact: Contact?
    
    private let topView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "lee-sin")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.cornerRadius = 50
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .systemFont(ofSize: 22.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "message"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14)
        configuration.image = UIImage(systemName: "message.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .top
        
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "phone"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14)
        configuration.image = UIImage(systemName: "phone.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .top
        
        button.configuration = configuration
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let videoButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "video"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14)
        configuration.image = UIImage(systemName: "video.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .top
        
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mailButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.gray()
        configuration.title = "mail"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14)
        configuration.image = UIImage(systemName: "mail.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .top
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contactDetailTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: ContactDetailTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        confiureUI()
        navConfig()
        addObserve()
        nameLabel.text = contact?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            contactDetailTableView.reloadData()
        }
        nameLabel.text = contact?.name
    }
    
    // Config UI
    func confiureUI() {
        view.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 225)
        ])
        view.addSubview(contactDetailTableView)
        contactDetailTableView.delegate = self
        contactDetailTableView.dataSource = self
        NSLayoutConstraint.activate([
            contactDetailTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            contactDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        confiureTopView()
    }
    
    func confiureTopView() {
        let name = contact?.name ?? ""
        let firstCharacter = name.prefix(1)
        let letter = String(firstCharacter)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 70),
            .foregroundColor: UIColor.black
        ]
        let letterImage = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).image { _ in
            let letterSize = letter.size(withAttributes: textAttributes)
            let rect = CGRect(x: (100 - letterSize.width) / 2, y: (100 - letterSize.height) / 2, width: letterSize.width, height: letterSize.height)
            let centeredOrigin = CGPoint(x: rect.origin.x, y: (100 - letterSize.height) / 2)
            letter.draw(at: centeredOrigin, withAttributes: textAttributes)
        }
        avatar.image = letterImage
        topView.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topView.topAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 100),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
        ])
        
        topView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor , constant: 110),
            nameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        buttonHorizontalStackView.addArrangedSubview(messageButton)
        buttonHorizontalStackView.addArrangedSubview(callButton)
        buttonHorizontalStackView.addArrangedSubview(videoButton)
        buttonHorizontalStackView.addArrangedSubview(mailButton)
        
        topView.addSubview(buttonHorizontalStackView)
        NSLayoutConstraint.activate([
            buttonHorizontalStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            buttonHorizontalStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 5),
            buttonHorizontalStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5),
            buttonHorizontalStackView.heightAnchor.constraint(equalToConstant: 70),
            buttonHorizontalStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
        ])
        
    }
    
    func navConfig() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    // Action UI
    func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateContactNotification(_:)), name: .updateContact, object: nil)
    }
    @objc func handleUpdateContactNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let updatedContact = userInfo["updatedContact"] as? Contact {
            self.contact = updatedContact
        }
    }
    @objc func deteteButtonTaped() {
        
    }
    
    @objc
    func editButtonTapped() {
        let inputContactViewController = InputContactViewController()
        inputContactViewController.contactViewModel = self.contactViewModel
        inputContactViewController.selector = .doneEditButton
        inputContactViewController.originalContact = contact
        self.navigationController?.pushViewController(inputContactViewController, animated: true)
    }
}

extension ContactDetailViewController: UITableViewDelegate {
    
}

extension ContactDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let number = ContactDetailSection(rawValue: section)
        switch number {
        case .phone:
            return "Phone"
        case .mail:
            return "Mail"
        case .note:
            return "Notes"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier, for: indexPath) as? ContactDetailTableViewCell else {
            return UITableViewCell()
        }
        
        var content = cell.defaultContentConfiguration()
        let number = ContactDetailSection(rawValue: indexPath.section)
        switch number {
        case .phone:
            content.text = contact?.phoneNumber
        case .mail:
            content.text = contact?.mail
        case .note:
            content.text = "This is some NOTE"
        default:
            content.text = ""
        }
        cell.contentConfiguration = content
        
//        cell.layer.cornerRadius = 10
        //        cell.layer.borderColor = cell.layer.borderColor  // set cell border color here
        //        cell.layer.borderWidth = 2 // set border width here
        cell.selectionStyle = .none
        return cell
    }
    
}
