//
//  DocumentDetailViewController.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 05/05/21.
//

import UIKit

class DocumentDetailViewController: UIViewController {

    @IBOutlet weak var documentFile: UIImageView!
    @IBOutlet weak var documentDesc: UILabel!
    
    var document: DocumentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentDesc.text = document?.desc
        self.title = document?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(playTapped))

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
//            do {
//                let imageUrlTemp = "file:///var/mobile/Containers/Data/Application/C39F6664-7E60-4600-AE2B-007AFC134A35/Documents/7267FF04-9AC7-41BB-9C26-84DC4AB14258.heic"
//                print(imageUrlTemp)
//                let url = URL.init(fileURLWithPath: imageUrlTemp)
//                let imageData:NSData = try NSData(contentsOf: url)
//                self.documentFile.image = UIImage(data: imageData as Data)
//            } catch {
//                print("Something wrong")
//            }

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
    @objc
    func playTapped() {
        let items = [self.documentFile.image]
        
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

//file:///Users/maritiapangaribuan/Library/Developer/CoreSimulator/Devices/1EF07895-649A-4144-B59E-9B2F50437BB3/data/Containers/Data/Application/91EB72E4-7C27-4CAA-B2F6-C42CB871017A/Documents/636EF424-24E9-4582-9D24-EF817198C639.jpeg

extension DocumentDetailViewController: FetchableImage {
    
}
