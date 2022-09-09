//
//  Text2ViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 09.09.2022.
//
//

import UIKit

class Text2ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    var fileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupUI()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
        saveData()
    }
    
    private func setupUI () {
        if let url = fileURL {
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
            textView.text = content
            nameLabel.text = url.lastPathComponent
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
    private func saveData () {
        let stringToSave = textView.text ?? ""
        guard let path = fileURL else { return }
        if let stringData = stringToSave.data(using: .utf8) {
            do {
                try stringData.write(to: path)
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}
