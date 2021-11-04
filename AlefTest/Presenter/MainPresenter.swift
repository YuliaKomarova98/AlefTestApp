//
//  Presenter.swift
//  AlefTest
//
//  Created by Yulia on 03.11.2021.
//

import Foundation

protocol PresenterDelegate: AnyObject {
    func checkingChildCount()
    func updateUI()
}

class MainPresenter {
    
    var numberOfRows: Int = 0
    var childList: [ChildModel] = []
    weak var view: PresenterDelegate?
    
    func addChild() {
        guard numberOfRows < 5 else { return }
        
        let model = ChildModel(id: numberOfRows, name: "", age: "")
        childList.append(model)
        
        numberOfRows += 1
        
        view?.checkingChildCount()
        view?.updateUI()
    }
    
    func removeChild(id: Int) {
        guard numberOfRows > 0, childList.indices.contains(id) else { return }
        
        childList.remove(at: id)
        numberOfRows -= 1
        
        guard childList.count > 0 else {
            view?.updateUI()
            return
        }
        
        if childList.count == 1 && id == 0{
            childList[id].id -= 1
        }
        
        if childList.count > 1 && id != childList.count {
            for i in id...childList.count - 1 {
                childList[i].id -= 1
            }
        }
        
        view?.checkingChildCount()
        view?.updateUI()
    }
    
    func clearData() {
        numberOfRows = 0
        childList.removeAll()
        view?.updateUI()
    }
    
    func cellModelForRow(_ row: Int) -> ChildModel? {
        guard childList.indices.contains(row) else { return nil }
        return childList[row]
    }
    
    func updateChildsList(id: Int, text: String, textFieldName: String) {
        guard childList.indices.contains(id) else { return }
        
        switch textFieldName {
        case Constants.nameTextField:
            childList[id].name = text
        case Constants.ageTextField:
            childList[id].age = text
        default:
            return
        }
    }
}
