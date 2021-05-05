//
//  DocumentDetailViewController.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 05/05/21.
//

import UIKit

class DocumentDetailViewController: UIViewController {

    @IBOutlet weak var documentDescription: UITextView!
    @IBOutlet weak var documentFile: UIImageView!
    
    var document: DocumentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentDescription.text = document?.desc
        self.title = document?.title
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print("docDir = \(docDir)")
            print("file = \(document?.file)")
            var imageURL = docDir.appendingPathComponent(document?.file ?? "")
//            print("imageurl = \(imageURL.path)")
            
//            var resourceValues = URLResourceValues()
//            resourceValues.isExcludedFromBackup = true
//            do {
//                try imageURL.setResourceValues (resourceValues)
//            } catch {
//                print("error resources")
//            }
//
//            print("lastpath = \(imageURL.lastPathComponent)")
//                let newImage = UIImage(contentsOfFile: imageURL.path)
//                self.documentFile.image = newImage

            self.fetchImage(from: nil, options: FetchableImageOptions(storeInCachesDirectory: false, allowLocalStorage: true, customFileName: document?.file)) { (data) in
                if let img = data {
                    let image = UIImage(data: img)
                    self.documentFile.image = image
                } else {
                    print("data nil")
                }
            }
//            self.localFileURL(for: nil, options: FetchableImageOptions(storeInCachesDirectory: true, allowLocalStorage: true, customFileName: document?.file))
//                self.fetchImage(from: imageURL.path) { (data) in
//                    DispatchQueue.main.async {
//                        guard let data = data else { return }
//                        let newImage = UIImage(data: data)
//                        self.documentFile.image = newImage
//                    }
//                }
//            }
        } catch {
            print("error load docdir")
        }
    }
    
}

//file:///Users/maritiapangaribuan/Library/Developer/CoreSimulator/Devices/1EF07895-649A-4144-B59E-9B2F50437BB3/data/Containers/Data/Application/91EB72E4-7C27-4CAA-B2F6-C42CB871017A/Documents/636EF424-24E9-4582-9D24-EF817198C639.jpeg

extension DocumentDetailViewController: FetchableImage {
    
}
