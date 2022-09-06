//
//  TextViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 07.09.2022.
//

import UIKit

class TextViewController: UIViewController {

    private var inset: CGFloat { return 30 }
    
    let textlabel: UILabel = {
        let textlabel = UILabel()
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        textlabel.textColor = .white
        textlabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textlabel.textAlignment = .left
        textlabel.numberOfLines = 0
        textlabel.sizeToFit()
        return textlabel
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
    
   private func setupIU () {
        view.addSubview(backgroundView)
        view.addSubview(textlabel)
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textlabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: inset),
            textlabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -inset),
            textlabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: inset),
            textlabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -inset)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
