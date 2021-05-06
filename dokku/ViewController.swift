//
//  ViewController.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 04/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchDocument: UISearchBar!
    
    var documents: [DocumentModel] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedDocument: DocumentModel?
    var filteredDocument = [DocumentModel]()
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchDocument.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchDocument.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredDocument = documents.filter { document in
          return document.title.lowercased().contains(searchText.lowercased())
        }
        if(filteredDocument.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDocument()
        selectedDocument = nil
    }
    
    private func filterDocuments(for searchText: String) {
      filteredDocument = documents.filter { document in
        return document.title.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterDocuments(for: searchDocument.text ?? "")
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
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredDocument.count
        }
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = documents[indexPath.row]
        var documentFilter: DocumentModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentTableViewCell
        if searchActive {
            documentFilter = filteredDocument[indexPath.row]
        } else {
            documentFilter = document
        }
        cell.setDocument(document: documentFilter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Called")
        self.selectedDocument = self.documents[indexPath.row]
        performSegue(withIdentifier: "GoToDetailDocument", sender: nil)
        print("Called")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action,view,completionHandler) in
            let documentToRemove = self.documents[indexPath.row]
            DocumentRepository.shared.deleteDocument(id: documentToRemove.id)
            self.fetchDocument()
            self.tableView.reloadData()
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
