//
//  DocumentRepository.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 05/05/21.
//

import UIKit
import CoreData

class DocumentRepository {
    
    static let shared = DocumentRepository()
    
    private init() {}
    
    func checkCardId(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return false
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Document")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {

            let fetchRequest = try managedContext.fetch(fetchRequest)
            if (fetchRequest.count > 0 ) {
                return false
            }
            return true
        }catch let err {
            print("err checkCardId = \(err.localizedDescription)")
            return false
        }
    }

    func save(doc: DocumentModel, completion: @escaping (_ status: Bool) -> ()) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let cardEntity = NSEntityDescription.entity(forEntityName: "Document", in: managedContext)!
        let cardData = NSManagedObject(entity: cardEntity, insertInto: managedContext)
        cardData.setValue(doc.id, forKeyPath: "id")
        cardData.setValue(doc.title, forKeyPath: "title")
        cardData.setValue(doc.desc, forKeyPath: "desc")
        cardData.setValue(doc.file, forKeyPath: "file")

        do {
            try managedContext.save()
            completion(true)
        } catch let error {
            print("failed get all save = \(error.localizedDescription)")
            completion(false)
        }
    }

    func update(doc: DocumentModel, completion: @escaping (_ status: Bool) -> ()) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Document")
        fetchRequest.predicate = NSPredicate(format: "id = %@", doc.id)
        do {
            let data = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            data.setValue(doc.title, forKeyPath: "title")
            data.setValue(doc.desc, forKeyPath: "desc")
            data.setValue(doc.file, forKeyPath: "file")
            try managedContext.save()
            completion(true)
        }catch let err {
            print("err = \(err.localizedDescription)")
            completion(false)
        }
    }

    func getAllDocument(completion: @escaping ([DocumentModel]) -> (), error: @escaping (String) -> ())  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Document")
        do {
            var docs: [DocumentModel] = []
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach { (doc) in
                docs.append(DocumentModel(
                    id: doc.value(forKey: "id") as! String,
                    title: doc.value(forKey: "title") as! String,
                    desc: doc.value(forKey: "desc") as! String,
                    file: doc.value(forKey: "file") as! String))
            }
            completion(docs)
        } catch let err {
            print("failed get all card = \(err.localizedDescription)")
            error("Gagal get")
        }
    }

    func deleteDocument(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("app delegate nil")
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Document")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
            try managedContext.save()
        }catch let err {
            print("err = \(err.localizedDescription)")
        }
    }
//
//    func removeAllCard(completion: @escaping (_ status: Bool) -> ()) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("app delegate nil")
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Card")
//        do {
//            let dataToDelete = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
//            dataToDelete.forEach { (card) in
//                managedContext.delete(card)
//            }
//            try managedContext.save()
//            completion(true)
//        }catch let err {
//            print("err = \(err.localizedDescription)")
//            completion(false)
//        }
//    }
    
}
