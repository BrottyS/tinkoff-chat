//
//  ImageSelectorViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ImageSelectorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Constants
    
    private let kItemsByHorizontal: CGFloat = 3
    private let kItemPadding: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureCollectionView()
    }
    
    private func configureView() {
        navigationItem.title = ""
        
        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCloseBarButtonItemTap(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "\(ImageSelectorCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ImageSelectorCell.self)")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //flowLayout = UICollectionViewFlowLayout()
        //flowLayout.itemSize = CGSize(width: frame.width / CGFloat(columns), height: frame.height / CGFloat(rows))
        //flowLayout.itemSize = CGSize(width: 50, height: 50)
        //flowLayout.minimumInteritemSpacing = 0
        //flowLayout.minimumLineSpacing = 0
        
        //collectionView.flow
    }
    
    @IBAction func didCloseBarButtonItemTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension ImageSelectorViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageSelectorCell.self)", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    
}

extension ImageSelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - kItemPadding * (kItemsByHorizontal + 1)) / kItemsByHorizontal
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kItemPadding, left: kItemPadding, bottom: kItemPadding, right: kItemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kItemPadding
    }
    
    
}
