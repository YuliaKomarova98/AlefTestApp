//
//  ViewController.swift
//  AlefTest
//
//  Created by Yulia on 03.11.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var addChildButton: UIButton!
    @IBOutlet weak var clearChildButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.view = self
        
        tableView.register(UINib(nibName: Constants.ChildTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.ChildTableViewCell)
        
        initializeHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
    }
    
    func setupView() {
        
        nameView.layer.cornerRadius = 5
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = .some(UIColor.lightGray.cgColor)
        
        ageView.layer.cornerRadius = 5
        ageView.layer.borderWidth = 1
        ageView.layer.borderColor = .some(UIColor.lightGray.cgColor)
        
        addChildButton.layer.cornerRadius = 25
        addChildButton.layer.borderWidth = 2
        addChildButton.layer.borderColor = .some(UIColor.systemBlue.cgColor)
        
        clearChildButton.layer.cornerRadius = 25
        clearChildButton.layer.borderWidth = 2
        clearChildButton.layer.borderColor = .some(UIColor.red.cgColor)
    }

    @IBAction func addChild(_ sender: UIButton) {
        presenter.addChild()
    }
    
    @IBAction func clearChild(_ sender: UIButton) {
        let alert = UIAlertController(title: "Сбросить данные?", message: nil, preferredStyle: .actionSheet)
        
        let clearButton = UIAlertAction(title: "Сбросить данные", style: .default) { _ in
            self.presenter.clearData()
        }
        alert.addAction(clearButton)
        
        let chanelButton = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(chanelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ChildTableViewCell, for: indexPath)
        (cell as? ChildTableViewCell)?.delegate = self
        (cell as? ChildTableViewCell)?.model = presenter.cellModelForRow(indexPath.row)
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case nameTextField:
            text.isEmpty ? (self.nameLabel.text = "") : (self.nameLabel.text = "Имя")
        case ageTextField:
            text.isEmpty ? (self.ageLabel.text = "") : (self.ageLabel.text = "Возраст")
        default:
            return
        }
    }
}

extension ViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

extension ViewController {
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        let keyboardOverlap = tableView.frame.maxY - endRect.origin.y + 150
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardOverlap, right: 0)
        tableView.verticalScrollIndicatorInsets.bottom = keyboardOverlap

        let duration = (durationValue as AnyObject).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ViewController: PresenterDelegate {
    func updateUI() {
        tableView.reloadData()
    }
}

extension ViewController: CellDelegate {
    func removeChild(id: Int) {
        presenter.removeChild(id: id)
    }
    
    func updateChildsList(id: Int, text: String, textFieldName: String) {
        presenter.updateChildsList(id: id, text: text, textFieldName: textFieldName)
    }
}
