//
//  TextViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 07.09.2022.
//

import UIKit

class TextViewController: UIViewController {

    private var inset: CGFloat { return 30 }
    
    var fileName = ""
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textView.backgroundColor = .black
        textView.alpha = 0.5
        return textView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIU()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        let filepath1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//
//        let file: FileHandle? = FileHandle(forUpdatingAtPath: filepath1)
//
//        if file == nil {
//            print("File open failed")
//        } else {
//            let data = (textView.text as
//                            NSString).data(using: String.Encoding.utf8.rawValue)
//            file?.seek(toFileOffset: 10)
//            file?.write(data!)
//            file?.closeFile()
//        }
        let stringToSave = textView.text ?? ""
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent(fileName)
        if let stringData = stringToSave.data(using: .utf8) {
            do {
                try stringData.write(to: path)
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
   private func setupIU () {
        view.addSubview(backgroundView)
        view.addSubview(textView)
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: inset),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -inset),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: inset),
            textView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -inset)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
