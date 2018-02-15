//
//  Bindings.swift
//  MVVM
//
//  Created by boris on 07/02/2018.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation
import UIKit

class Bindings: NSObject {
    
    fileprivate var _bindingTable : Array<UIBinding> = [UIBinding]()
    fileprivate static let shared : Bindings = Bindings()
    
    
    static func add(binding: UIBinding) {
        if !shared._bindingTable.contains(binding) {
            shared._bindingTable.append(binding)
        }
    }
    
    
    static func cleanAll(){
        shared._bindingTable.removeAll()
    }
    
    
    static func remove(binding :UIBinding) {
        if let idx = shared._bindingTable.index(of: binding) {
            shared._bindingTable.remove(at: idx)
        }
    }
}



extension NSObject {
    
    func bind(observedProperty : String, toProperty: String, ofObject: NSObject) {
        
       let binding = UIBinding(observedObject: self,
                             observedProperty: observedProperty,
                               observerObject: ofObject,
                             observerProperty: toProperty)
        
        Bindings.add(binding: binding)
    }
    
    
    
    
    func unbindAll(fromObject :AnyObject) -> Bool {
        let query  = Bindings.shared._bindingTable.filter({ (binding) -> Bool in
               return binding._observerObject.isEqual(fromObject)
        })
        if query.count > 0 {
            Bindings.remove(binding: query[0])
            return true
        }
        return false
    }
    
    
    
    
}












