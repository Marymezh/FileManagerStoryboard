//
//  TextViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 07.09.2022.
//

import UIKit

class TextViewController: UIViewController {

    private var inset: CGFloat { return 30 }
    
    var fileURL: URL
    
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
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIU()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
        let stringToSave = textView.text ?? ""
        let path = fileURL
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
