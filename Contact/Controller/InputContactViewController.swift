//
//  AddContactViewController.swift
//  Contact
//
//  Created by tinit on 31/10/2023.
//

import UIKit

class InputContactViewController: UIViewController {
    var contactViewModel: ContactViewModelProtocol?
    
    var originalContact: Contact?
    
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var selector: Selector?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let nameTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.placeholder = "Name"
        return textField
    }()
    
    let emailTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.placeholder = "Mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let phoneTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.placeholder = "Phone Number"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        switch selector {
        case .doneEditButton:
            name = (originalContact?.name)!
            email = (originalContact?.mail)!
            phoneNumber = (originalContact?.phoneNumber)!
            nameTextField.text = (originalContact?.name)!
            emailTextField.text = (originalContact?.mail)!
            phoneTextField.text = (originalContact?.phoneNumber)!
        default:
            break
        }
        configureUI()
        observeAction()
    }
    
    func configureUI() {
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(phoneTextField)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 40)
        emailTextField.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 40)
        phoneTextField.frame = CGRect(x: 20, y: 200, width: view.frame.size.width - 40, height: 40)
        
        nameTextField.underline()
        emailTextField.underline()
        phoneTextField.underline()
        
        navBarConfigure()
    }
    
    func navBarConfigure() {
        switch selector {
        case .doneAddButton:
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(addCancelButtonTapped))
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAddButtonTapped))
            break
        case .doneEditButton:
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(editCancelButtonTapped))
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditButtonTapped))
            break
        default:
            break
        }
    }
    
    func observeAction() {
        nameTextField.addTarget(self, action: #selector(InputContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(InputContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        phoneTextField.addTarget(self, action: #selector(InputContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
    }
    
    @objc func addCancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editCancelButtonTapped() {
        if self.presentingViewController != nil {
            dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func doneAddButtonTapped() {
        view.endEditing(true)
        
        let alertController = UIAlertController(title: "Confirm Create", message: "Do you want to create new contact?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [self] (action) in
            contactViewModel?.addContact(name: name, mail: email, phoneNumber: phoneNumber)
            dismiss(animated: true, completion: nil)
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func doneEditButtonTapped() {
        view.endEditing(true)
        
        let alertController = UIAlertController(title: "Confirm Update", message: "Do you want to save the changes?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .destructive) { (action) in
            self.contactViewModel?.updateContact(oldName: (self.originalContact?.name)!, newName: self.name, newMail: self.email, newPhoneNumber: self.phoneNumber)
            if self.presentingViewController != nil {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func underlineTextField(textField: UITextField) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        let attributedString = NSAttributedString(string: textField.text ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        textField.attributedText = attributedString
    }
}

extension InputContactViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if textField === nameTextField {
            name = text
        } else if textField === emailTextField {
            email = text
        } else if textField === phoneTextField {
            phoneNumber = text
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
