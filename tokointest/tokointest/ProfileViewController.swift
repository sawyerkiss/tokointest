//
//  ProfileViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

protocol ShowsAlert {}

extension ShowsAlert where Self: UIViewController {
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ShowsAlert {
    
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var pickerData: UIPickerView!
    
    var pickerDataSource: [String] = [String]()
    
    var keyword: String = "bitcoin"
    
    var userName: String = ""
    
    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.initViewModel()
    }
    
    func initView() {
        self.pickerData.delegate = self
        self.pickerData.dataSource = self
        
        // Input the data into the array
        pickerDataSource = ["bitcoin", "apple", "earthquake", "animal"]
    }
    
    func initViewModel() {
        viewModel.loadProfileData = { [weak self] () in
            DispatchQueue.main.async {
                    self?.loadUserProfile()
            }
        }
        
        viewModel.saveProfileData = { [weak self] () in
            DispatchQueue.main.async {
                if let user = self?.viewModel.userProfile {
                    self?.saveUserProfile(user: user)
                }
            }
        }
        viewModel.loadUserProfile()
    }
    
    func loadUserProfile() {
        var user : User?
        let userDefaults = UserDefaults.standard
        do {
            user = try userDefaults.getObject(forKey: "UserProfile", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            user = User()
            user?.userName = ""
            user?.keyword = ""
        }
        tfUsername.text = user?.userName ?? ""
        let index = pickerDataSource.firstIndex(of: user?.keyword ?? "") ?? 0
        self.pickerData.selectRow(index, inComponent: 0, animated:false)
        keyword = user?.keyword ?? "bitcoin"
    }
    
    func saveUserProfile(user: User?) {
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(user, forKey: "UserProfile")
            showAlert(message: "Save profile data successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didTouchSaveData(_ sender: Any) {
        let user = User()
        user.userName = tfUsername.text
        user.keyword = keyword
        self.viewModel.saveUserProfile(user: user)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        keyword = pickerDataSource[row]
    }
}
