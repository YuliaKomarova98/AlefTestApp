//
//  ChildTableViewCell.swift
//  AlefTest
//
//  Created by Yulia on 03.11.2021.
//

import UIKit

protocol CellDelegate: AnyObject {
    func updateChildsList(id: Int ,text: String, textFieldName: String)
    func removeChild(id: Int)
}

class ChildTableViewCell: UITableViewCell {
    
    weak var delegate: CellDelegate?

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBAction func deletChild(_ sender: UIButton) {
        guard let model = model else { return }
        delegate?.removeChild(id: model.id)
    }
    
    var model: ChildModel? {
        didSet {
            guard let model = model else { return }

            nameTextField.text = model.name
            ageTextField.text = model.age
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewCell()
        
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    func setupViewCell() {
        let viewCornerRadius: CGFloat = 5
        let viewBorderWidth: CGFloat = 1
        
        nameView.layer.cornerRadius = viewCornerRadius
        nameView.layer.borderWidth = viewBorderWidth
        nameView.layer.borderColor = .some(UIColor.lightGray.cgColor)
        
        ageView.layer.cornerRadius = viewCornerRadius
        ageView.layer.borderWidth = viewBorderWidth
        ageView.layer.borderColor = .some(UIColor.lightGray.cgColor)
    }
}

extension ChildTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text), let model = model else { return false }

        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        switch textField {
        case nameTextField:
            delegate?.updateChildsList(id: model.id, text: updatedText, textFieldName: Constants.nameTextField)
        case ageTextField:
            delegate?.updateChildsList(id: model.id, text: updatedText, textFieldName: Constants.ageTextField)
        default:
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case nameTextField:
            text.isEmpty ? (self.nameLabel.text = "") : (self.nameLabel.text = Constants.name)
        case ageTextField:
            text.isEmpty ? (self.ageLabel.text = "") : (self.ageLabel.text = Constants.age)
        default:
            return
        }
    }
}
