//
//  SinglePhoto.swift
//  RandomPhotos
//
//  Created by Saurabh Agarwal on 12/10/22.
//

import UIKit

class SinglePhoto: UIViewController, UIScrollViewDelegate {
    
    var selectedImage: Data?
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.delegate = self
//        scrollView.backgroundColor = .systemBlue
        scrollView.layer.cornerRadius = 5
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
//        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
        ])

        if let data = selectedImage {
            imageView.image = UIImage(data: data)
        }
        scrollView.addSubview(imageView)
        imageView.frame = scrollView.bounds
        imageView.center = scrollView.center
                                        
        addGesture()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? UIScrollView else { return }
        if view.zoomScale > view.minimumZoomScale {
            view.setZoomScale(view.minimumZoomScale, animated: true)
        }
    }
}
