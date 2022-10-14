//
//  ImageCell.swift
//  RandomPhotos
//
//  Created by Saurabh Agarwal on 11/10/22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let identifier = "image"
    static let urlString = "https://picsum.photos/200/300"
    private var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
    }
    
    func config(data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
