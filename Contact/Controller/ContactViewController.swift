//
//  ContactViewController.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import UIKit
import Combine

protocol ContactViewControllerDelegate {
    func passData(contact: Contact)
}

class ContactViewController: UIViewController {
    
    var viewModel: ContactViewModelProtocol?
    var delegate: ContactViewControllerDelegate?
    var contacts: [Contact] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let contactTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getObserve()
        loadData()
    }
    
    //    func getObserve() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(handleNewContactAdded), name: .addNewContact, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteContact), name: .deleteContact, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateContact), name: .updateContact, object: nil)
    //    }
    
    // Combine getObserve
    func getObserve() {
        NotificationCenter.default.publisher(for: .addNewContact)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .deleteContact)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .updateContact)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //    @objc func handleNewContactAdded() {
    //        reloadData()
    //    }
    //
    //    @objc func handleDeleteContact() {
    //        reloadData()
    //    }
    //
    //    @objc func handleUpdateContact() {
    //        reloadData()
    //    }
    
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
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.target = self
        editButtonItem.action = #selector(editButtonTapped)
    }
    
    //    func loadData() {
    //        viewModel?.importContact(completion: {
    //            self.viewModel?.getContact()
    //            DispatchQueue.main.async {
    //                self.contactTableView.reloadData()
    //            }
    //        })
    //    }
    
    //    func reloadData() {
    //        viewModel?.getContact()
    //        DispatchQueue.main.async {
    //            self.contactTableView.reloadData()
    //            print("Reload")
    //        }
    //    }
    
    // loadData Combine
    func loadData() {
        viewModel?.importContact()
        reloadData()
    }
    // reloadData Combine
    func reloadData() {
        viewModel?.getContact()
        contactTableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let inputContactViewController = InputContactViewController()
        inputContactViewController.contactViewModel = self.viewModel
        inputContactViewController.selector = .doneAddButton
        let navInputContactViewController = UINavigationController(rootViewController: inputContactViewController)
        self.present(navInputContactViewController, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        if navigationItem.leftBarButtonItem?.title == "Edit" {
            contactTableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            contactTableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
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
        contactDetailViewController.contactViewModel = viewModel
        contactDetailViewController.contact = viewModel?.sections[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(contactDetailViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") {
            [self] (action, view, handler) in
            let contactToUpdate = viewModel?.sections[indexPath.section][indexPath.row]
            
            let inputContactViewController = InputContactViewController()
            inputContactViewController.originalContact = contactToUpdate
            inputContactViewController.contactViewModel = viewModel
            inputContactViewController.selector = .doneEditButton
            let navInputContactViewController = UINavigationController(rootViewController: inputContactViewController)
            self.present(navInputContactViewController, animated: true, completion: nil)
            tableView.setEditing(false, animated: true)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { [self](action, view, handler) in
            let contactToDelete = viewModel?.sections[indexPath.section][indexPath.row]
            
            let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [self] (deleteAction) in
                viewModel?.deleteContact(contact: contactToDelete!)
            })
            
            present(alertController, animated: true, completion: nil)
            
            handler(true)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        return swipeAction
        
    }
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let sourceContact = viewModel?.sections[sourceIndexPath.section][sourceIndexPath.row], let destinationContact = viewModel?.sections[destinationIndexPath.section][destinationIndexPath.row] {
            //            if sourceIndexPath.section != destinationIndexPath.section {
            //                sou
            //            }
            viewModel?.swapContacts(sourceContact, destinationContact)
        }
    }
}
