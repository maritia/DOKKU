//
//  Document+CoreDateProperties.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 04/05/21.
//
import Foundation
import CoreData

extension Document {
    
    @nonobjc public class func fetchRequest() ->NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var file: String?
    
}
