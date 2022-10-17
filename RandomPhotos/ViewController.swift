//
//  ViewController.swift
//  RandomPhotos
//
//  Created by Saurabh Agarwal on 11/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://picsum.photos/400/600"
    
    private var collectionView: UICollectionView?
    private var photos: [Data] = []
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: AutoInvalidatingLayout())
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(
            FooterReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterReusableView.identifier
        )
        
        collectionView.frame = view.bounds
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else { return }
        for _ in 1...20 {
            URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                self?.photos.append(data)
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }.resume()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if contentHeight > 0 && offsetY > contentHeight - 100 - scrollView.frame.height {
            if !isLoading {
                fetchMore()
            }
        }
    }
    
    func fetchMore() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
            guard let url = URL(string: self?.urlString ?? "") else { return }
            for _ in 1...20 {
                URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    self?.photos.append(data)
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }.resume()
            }
            self?.isLoading = false
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextScreen = SinglePhoto()
        nextScreen.selectedImage = photos[indexPath.row]
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        for indexPath in indexPaths {
            return configureContextMenu(index: indexPath.row)
        }
        return UIContextMenuConfiguration()
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration? {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let edit = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                guard let image = UIImage(data: self.photos[index]) else { return }
                let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
                self.present(vc, animated: true)
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit])
        }
        return context
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.config(data: photos[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterReusableView.identifier, for: indexPath)
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 100)
    }
}

class AutoInvalidatingLayout: UICollectionViewFlowLayout {
    
    func widestCellWidth(bounds: CGRect) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        let width = bounds.width - insets.left - insets.right
        
        if width < 0 { return 0 }
        return width / 2 - 5
    }
    
    func updateEstimatedItemSize(bounds: CGRect) {
        estimatedItemSize =  CGSize(width: widestCellWidth(bounds: bounds), height: widestCellWidth(bounds: bounds))
    }
    
    override func prepare() {
        super.prepare()
        
        let bounds = collectionView?.bounds ?? .zero
        updateEstimatedItemSize(bounds: bounds)
        minimumInteritemSpacing = 3
        minimumLineSpacing = 4
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        let oldSize = collectionView.bounds.size
        guard oldSize != newBounds.size else {
            return false
        }
        updateEstimatedItemSize(bounds: newBounds)
        return true
    }
}

