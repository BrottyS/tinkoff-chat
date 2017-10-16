//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.09.17.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutMeTextField: UITextField!
    //@IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    private var dataManager: DataManagerProtocol!
    private let profileFileName = "Profile.plist"
    private var profile: ProfileModel!
    
    private var isSaving = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius = changeAvatarButton.frame.width / 2.0
        changeAvatarButton.layer.cornerRadius = cornerRadius
        avatarImageView.layer.cornerRadius = cornerRadius
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.text = ""
        aboutMeTextField.text = ""
        nameTextField.delegate = self
        aboutMeTextField.delegate = self
        
        readProfile()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            if !isSaving {
                makeControlsEnabled(true)
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didCloseBarButtonItemTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func saveProfile() {
        activityIndicatorView.startAnimating()
        makeControlsEnabled(false)
        isSaving = true
        
        dataManager.save(profile) { result in
            switch result {
            case .success:
                print("Успешно сохранено")
                let successAlert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                    successAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.makeControlsEnabled(true)
                    self.isSaving = false
                })
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)
                
            case .failure:
                print("Ошибка при сохранении")
                let failureAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                    failureAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.makeControlsEnabled(true)
                    self.isSaving = false
                })
                let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { action in
                    failureAlert.dismiss(animated: true, completion: nil)
                    self.saveProfile()
                })
                failureAlert.addAction(okAction)
                failureAlert.addAction(retryAction)
                self.present(failureAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func readProfile() {
        //dataManager = GCDDataManager(fileName: profileFileName)
        // or
        dataManager = OperationDataManager(fileName: profileFileName)
        dataManager.read() { profile in
            if let profile = profile {
                self.profile = profile
                //print(self.profile.toDictionary())
                self.nameTextField.text = self.profile.name
                self.aboutMeTextField.text = self.profile.aboutMe
                let data = self.profile.avatarImageData as Data?
                if let data = data, let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                } else {
                    self.avatarImageView.image = UIImage(named: "placeholder-user")
                }
            }
        }
    }
    
    private func collectProfileData() {
        profile = ProfileModel()
        profile.name = nameTextField.text
        profile.aboutMe = aboutMeTextField.text
        if let image = avatarImageView.image {
            profile.avatarImageData = UIImagePNGRepresentation(image) as NSData?
        }
    }
    
    @IBAction func didGCDButtonTap(_ sender: UIButton) {
        collectProfileData()
        dataManager = GCDDataManager(fileName: profileFileName)
        saveProfile()
    }
    
    @IBAction func didOperationButtonTap(_ sender: UIButton) {profile = ProfileModel()
        collectProfileData()
        dataManager = OperationDataManager(fileName: profileFileName)
        saveProfile()
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - buttonsView.frame.height, right: 0)
        scrollView.contentInset = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func makeControlsEnabled(_ enable: Bool) {
        gcdButton.isEnabled = enable
        operationButton.isEnabled = enable
    }
    
    // UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isSaving {
            makeControlsEnabled(true)
        }
    }
    
}

