//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.09.17.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // print(editButton.frame)
        // невозможно распечатать значение свойства frame на данном этапе,
        // потому что editButton еще не проинициализирована
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius = changeAvatarButton.frame.width / 2.0
        changeAvatarButton.layer.cornerRadius = cornerRadius
        avatarImageView.layer.cornerRadius = cornerRadius
        
        editButton.layer.borderWidth = 1.5
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 16.0
        
        print("\(#function), editButton.frame: \(editButton.frame)")
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(#function), editButton.frame: \(editButton.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(#function), editButton.frame: \(editButton.frame)")
        // значение frame, полученное в этом методе, отличается от значения frame,
        // полученного в методе viewDidLoad, потому, что в viewDidLoad значение frame
        // равно еще значению, установленному кнопке "Редактировать" при создании разметки
        // в storyboard, а в этом методе (viewDidAppear) frame равен уже значению,
        // вычисленному AutoLayout под экран конечного устройства.
    }
    
    @IBAction func didTapChangeAvatarButton(_ sender: UIButton) {
        print("Выбери изображение профиля")
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pickImageFromGalleryAction = UIAlertAction(title: "Установить из галереи", style: .default) { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(pickImageFromGalleryAction)
        alert.addAction(takePhotoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

