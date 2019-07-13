//
//  NSManagedObject+SiF.swift
//  Pods
//
//  Created by FOLY on 9/13/17.
//
//

import Foundation
import CoreData

extension NSManagedObject {
    // all keys = entity properties
    open func updateAttributes<T: ValueTransformer>(dictionary: [String: Any],
                          ignoreKeys: [String] = [],
                          mapKeys: [String: String] = [:],
                          transformers: [String: T] = [:]) {
        let dictProperties = self.entity.propertiesByName
        let properties = Array(dictProperties.keys)
        
        for property in properties {
            
            if(ignoreKeys.contains(property)) {
                continue
            }
            
            var key = property
            if let mapKey = mapKeys[property] {
                key = mapKey
            }
            
            var destinationValue: Any? = dictionary[key]
            
            if let transfomer = transformers[property] {
                destinationValue = transfomer.transformedValue(destinationValue)
            }
            
            self.setValue(destinationValue, forKey: property)
            
            /*
            let value = dictProperties[property]
            if let attribute = value as? NSAttributeDescription {
                let className = attribute.attributeValueClassName
                print("Property class \(String(describing: className))")
            }
            else if let relation = value as? NSRelationshipDescription {
                let relationClassName = relation.destinationEntity?.managedObjectClassName
                print("Relationship class \(String(describing: relationClassName))")
            } else {
                print("Unknown attribute \(property)")
            }
             */
            
        }
    }
    
    // all keys = entity properties
    open func dictionary<T: ValueTransformer>(ignoreKeys: [String] = [],
                    mapKeys: [String: String] = [:],
                    reverseTransformers: [String: T] = [:]) -> [String: Any] {
        let dictProperties = self.entity.propertiesByName
        let properties = Array(dictProperties.keys)
        
        var dict: [String: Any] = [:]
        
        for property in properties {
            
            if(ignoreKeys.contains(property)) {
                continue
            }
            
            var key = property
            if let mapKey = mapKeys[property] {
                key = mapKey
            }
            
            var destinationValue: Any? = self.value(forKey: property)
            if let transfomer = reverseTransformers[property] {
                destinationValue = transfomer.reverseTransformedValue(destinationValue)
            }
            
            dict[key] = destinationValue
        }
        
        return  dict
    }
}
