//
//  SinglePhoto.swift
//  RandomPhotos
//
//  Created by Saurabh Agarwal on 12/10/22.
//

import UIKit

class SinglePhoto: UIViewController, UIScrollViewDelegate {
    
    var selectedImage: Data?
    var imageView = UIImageView()
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save)
        view.backgroundColor = .systemBackground
        
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1.0
        scrollView.layer.cornerRadius = 5
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
           scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
           scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
        ])
        
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        if let data = selectedImage {
            imageView.image = UIImage(data: data)
        }
        scrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
    
    func addGesture() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
    }
    
    @objc func didPinch(gesture: UIPinchGestureRecognizer) {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
