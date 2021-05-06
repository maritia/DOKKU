//
//  UpdateViewController.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 04/05/21.
//

import UIKit
import CoreData

enum ImageSource {
    case photoLibrary
    case camera
}

class UpdateViewController: UIViewController {

    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputDesc: UITextField!
    @IBOutlet weak var imageDocument: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imagePicker: UIImagePickerController!
    var imageName = ""
    var document: DocumentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTitle.text = document?.title
        inputDesc.text = document?.desc
        addImageButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func saveDocument(_ sender: Any) {
        var newDocument = DocumentModel(id: AppHelper.shared.randomString(length: 8), title: inputTitle.text ?? "", desc: inputDesc.text ?? "" , file: imageName)
        
        if document != nil {
            newDocument.id = document?.id ?? AppHelper.shared.randomString(length: 8)
            DocumentRepository.shared.update(doc: newDocument) { (result) in
                if result {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("error update")
                }
            }
        } else {
            var id = ""
            repeat {
                id = AppHelper.shared.randomString(length: 8)
            } while !DocumentRepository.shared.checkCardId(id: id)
            newDocument.id = id
            DocumentRepository.shared.save(doc: newDocument) { (result) in
                if result {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("error save")
                }
            }
        }
        
    }
    
    @IBAction func getImage(_ sender: Any) {
        selectImageFrom(.photoLibrary)
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension UpdateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imageName = url.lastPathComponent
            print("imageName = \(imageName)")
        }

        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let imageData = selectedImage.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)


        //Retrieving the image
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths2               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths2.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            if let imageRetrieved = UIImage(contentsOfFile: imageURL.path) {
                //do whatever you want with this image
                print(imageRetrieved)
            }
        }
        imageDocument.image = selectedImage
    }
    
}
