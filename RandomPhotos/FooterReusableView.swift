//
//  FooterReusableView.swift
//  RandomPhotos
//
//  Created by Saurabh Agarwal on 13/10/22.
//

import UIKit

class FooterReusableView: UICollectionReusableView {
    static let identifier = "FooterReusableView"
    
    let spinner = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinner.center = center
        addSubview(spinner)
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.frame = bounds
    }
}
