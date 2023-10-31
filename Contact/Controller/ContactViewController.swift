//
//  ContactViewController.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import UIKit

protocol ContactViewControllerDelegate {
    func passData(contact: Contact)
}

class ContactViewController: UIViewController {
    
    var viewModel: ContactViewModelProtocol?
    var delegate: ContactViewControllerDelegate?
    var contacts: [Contact] = []
    
    private let contactTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadData()
        getObserve()
    }
    
    func getObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewContactAdded), name: .addNewContact, object: nil)
        NotificationCenter.default.addObserver(self
                                               , selector: #selector(handleDeleteContact), name: .deleteContact, object: nil)
    }
    
    @objc func handleNewContactAdded() {
        reloadData()
    }
    
    @objc func handleDeleteContact() {
        reloadData()
    }
    
    func setViewModel(viewModel: ContactViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func configureUI() {
        navConfig()
        configureContactTableView()
    }
    
    func navConfig() {
        title = "Contact"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func loadData() {
        viewModel?.importContact(completion: {
            self.viewModel?.getContact()
            DispatchQueue.main.async {
                self.contactTableView.reloadData()
            }
        })
    }
    
    func reloadData() {
        viewModel?.getContact()
        DispatchQueue.main.async {
            self.contactTableView.reloadData()
        }
    }
    
    @objc
    func addButtonTapped() {
        let addContactViewController = AddContactViewController()
        addContactViewController.contactViewModel = self.viewModel
        let navAddContactViewController = UINavigationController(rootViewController: addContactViewController)
        self.present(navAddContactViewController, animated: true, completion: nil)
    }
    
    func configureContactTableView() {
        view.addSubview(contactTableView)
        contactTableView.delegate = self
        contactTableView.dataSource = self
        let contactTableViewContrains = [
            contactTableView.topAnchor.constraint(equalTo: view.topAnchor),
            contactTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(contactTableViewContrains)
    }
    
}

extension ContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel?.deleteContact(contact: (viewModel?.sections[indexPath.section][indexPath.row])!)
        
        let contactDetailViewController = ContactDetailViewController()
        contactDetailViewController.contact = viewModel?.sections[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(contactDetailViewController, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        <#code#>
//    }
}

extension ContactViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let contact = viewModel?.sections[section].first {
            if contact.isMain {
                return " "
            }
        }
        
        let firstCharacter = String(viewModel?.sections[section].first?.name!.prefix(1) ?? "")
        return firstCharacter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactTableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        var contact: Contact
        
        contact = (viewModel?.sections[indexPath.section][indexPath.row])!
        cell.nameLabel.text = contact.name
        
        return cell
    }
}
