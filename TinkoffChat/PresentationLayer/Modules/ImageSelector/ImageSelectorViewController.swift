//
//  ImageSelectorViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ImageSelectorViewController: UIViewController, IImageSelectorInteractorDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Constants
    
    private let interactor: IImageSelectorInteractor
    
    private let kItemsByHorizontal: CGFloat = 3
    private let kItemPadding: CGFloat = 8
    
    private var dataSource: [PixabayDisplayModel] = []
    
    init(interactor: IImageSelectorInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    @IBAction func didCloseBarButtonItemTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IImageSelectorInteractorDelegate
    
    func setup(dataSource: [PixabayDisplayModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        
    }

}

extension ImageSelectorViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return dataSource.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageSelectorCell.self)", for: indexPath) as! ImageSelectorCell
        
        cell.backgroundColor = .red
        //cell.imageView.image = UIImage()
        
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
