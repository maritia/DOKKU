//
//  ViewController.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 04/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var documents: [DocumentModel] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedDocument: DocumentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDocument()
        selectedDocument = nil
    }
    
    func fetchDocument() {
        DocumentRepository.shared.getAllDocument { [weak self] (documents) in
            self?.documents = documents
            self?.tableView.reloadData()
        } error: { (error) in
            print(error)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "AddDocument", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seguee = segue.identifier {
            if seguee.elementsEqual("AddDocument") , let controller = segue.destination as? UpdateViewController{
                controller.document = selectedDocument
            }
            else if seguee.elementsEqual("GoToDetailDocument") , let controller = segue.destination as? DocumentDetailViewController{
                controller.document = selectedDocument
            }
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = documents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentTableViewCell
        cell.setDocument(document: document)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDocument = self.documents[indexPath.row]
        performSegue(withIdentifier: "GoToDetailDocument", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action,view,completionHandler) in
//            let documentToRemove = self.documents[indexPath.row]
//            self.context.delete(documentToRemove)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        let editAction = UIContextualAction(style: .destructive, title: "EDIT") {
            (action,view,completionHandler) in
            self.selectedDocument = self.documents[indexPath.row]
            self.performSegue(withIdentifier: "AddDocument", sender: nil)
        }
        editAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
