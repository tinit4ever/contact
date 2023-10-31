//
//  AddContactViewController.swift
//  Contact
//
//  Created by tinit on 31/10/2023.
//

import UIKit

class AddContactViewController: UIViewController {
    var contactViewModel: ContactViewModelProtocol?
    
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    
    private let nameTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    let emailTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let phoneTextField: UITextField = {
        var textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.autocapitalizationType = .none
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(phoneTextField)
        
        nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 40)
        emailTextField.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 40)
        phoneTextField.frame = CGRect(x: 20, y: 200, width: view.frame.size.width - 40, height: 40)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
//        doneButton.isEnabled = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        nameTextField.addTarget(self, action: #selector(AddContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(AddContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        phoneTextField.addTarget(self, action: #selector(AddContactViewController.textFieldDidChange(_:)), for: .editingDidEnd)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
        contactViewModel?.addContact(name: name, mail: email, phoneNumber: phoneNumber)
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddContactViewController: UITextFieldDelegate {
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
}
