//
//  Image2ViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 09.09.2022.
//

import UIKit

class ImageViewController: UIViewController {
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var fileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupUI()
    }
    
    private func setupUI() {
        if let url = fileURL {
            nameLabel.text = url.lastPathComponent
            imageView.image = UIImage(contentsOfFile: url.path)
        } else {
            showErrorAlert(text: "Image is not available")
        }

    }
    
    private func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
