//
//  UIBinding.swift
//  MVVM
//
//  Created by boris on 07/02/2018.
//  Copyright © 2018 SmartSeed. All rights reserved.
//

import Foundation
import UIKit

class UIBinding: NSObject {
    @objc dynamic var _observerObject : NSObject!
    @objc dynamic fileprivate var _observedObject : NSObject!
    @objc dynamic fileprivate var _observerProperty : String!

    private static var observerContext = 0

    init(observedObject :NSObject, observedProperty: String,
         observerObject: NSObject, observerProperty: String)
    {
        _observerObject = observerObject
        _observedObject = observedObject
        _observerProperty = observerProperty
        
        super.init()
        defer {
            _observedObject.addObserver(self, forKeyPath: observedProperty, options: .new, context: &UIBinding.observerContext)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context ==  &UIBinding.observerContext{
            if (change!.keys.contains(.newKey)) {
                let nValue = change![.newKey]!
                print("Property \(keyPath!) changed to : \(nValue)")

                let selector = Selector((_observerProperty))
                if (_observerObject.responds(to: selector)) {
                    _observerObject.setValue(nValue, forKey: _observerProperty)
                }else {
                    print("Object <_observerObject> does not implement \(_observerProperty!) \n")
                    print("\n Object tree :")
                    let m = Mirror(reflecting: _observerObject)
                    for (name, value) in  m.children {
                        guard let name = name else { continue }
                        print("\(name): \(type(of: value)) = '\(value)'")
                    }
                }
            }
        }
    }
    
    

    
    
    deinit {
        print("deinit....\(self)")
        if _observerObject.observationInfo != nil {
            print("deinit..removing \(_observerProperty) from self KVO table..")
            _observerObject.removeObserver(self, forKeyPath: _observerProperty)
        }
    }
    
}



