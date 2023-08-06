//
//  TextField.swift
//  Tracker
//
//  Created by Антон Кашников on 04.08.2023.
//

import UIKit

final class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    var newHabitViewController: NewHabitViewController?
    var newCategoryViewController: NewCategoryViewController?
    var identifier: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textField = textField as? TextField else {
            return false
        }
        
        if textField.identifier == "newHabit" {
            let maxLength = 38
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if newString.length > maxLength {
                newHabitViewController?.showRestrictionLabel()
            } else {
                newHabitViewController?.hideRestrictionLabel()
            }
            
            return newString.length <= maxLength
        } else if textField.identifier == "newCategory" {
            let currentString = (textField.text ?? "") as NSString
            let newText = currentString.replacingCharacters(in: range, with: string)
            print(newText)
            print("Пустой текст ? \(newText.isEmpty)")
//            newCategoryViewController?.button.isEnabled = !newText.isEmpty
    //        print("Кнопка включена ? \(newCategoryViewController?.button.isEnabled)")
            newCategoryViewController?.button.backgroundColor = !newText.isEmpty ? .ypBlack : .ypGray
            print(newCategoryViewController?.button.backgroundColor)
        }
        
//        return newString.length <= maxLength
        return true
    }
}