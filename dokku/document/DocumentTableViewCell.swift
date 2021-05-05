//
//  DocumentTableViewCell.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 04/05/21.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var documentName: UILabel!
    
    func setDocument(document: DocumentModel) {
        documentName.text = document.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
