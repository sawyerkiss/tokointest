//
//  ProfileViewModel.swift
//  tokointest
//
//  Created by Macintosh HD on 8/18/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {

    var loadProfileData: (() -> ())?
    
    var saveProfileData: (() -> ())?
    
    var userProfile: User? {
        didSet {
            self.saveProfileData?()
        }
    }
    
    func loadUserProfile() {
        self.loadProfileData?()
    }
}
extension ProfileViewModel {
      func saveUserProfile(user: User?) {
        self.userProfile = user
      }
}
