//
//  ImageViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 06.09.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    private var inset: CGFloat { return 30 }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
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
        view.addSubview(imageView)
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -inset),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -inset)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
