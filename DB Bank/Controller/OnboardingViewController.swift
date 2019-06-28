//
//  OnboardingViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class OnboardingViewController : SuperViewController {
    
    let imageViewEdit = ImageView()
    let textFieldEdit = TextFields()
    let customButton = CustomButton()
    
    override func viewDidLoad() {
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.signOut()
        super.signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    /*
     IBOutlets
 */
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var hiThereLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var emailSignInButton: UIButton!
    
    
    /*
     Button Actions
*/
    @IBAction func createAccountBuuttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: goToCreateAccount, sender: self)
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: UIButton) {
        super.signInDelegate()
    }
    
    @IBAction func emailSignInButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: goToSignin, sender: self)
    }
    
    
    
    
    func setUpView () {
        SVProgressHUD.dismiss()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        hideNavigationBar()
        imageViewEdit.addCornerRadius(imageView: backgroundImage, view: view.self)
        textFieldEdit.addDynamicTextlayout(offset: 40, label: hiThereLabel, view: view.self, height: 42)
        textFieldEdit.addDynamicTextlayout(offset: 78, label: welcomeLabel, view: view.self, height: 20)
        customButton.customizeButton(button: createAccountButton)
        customButton.customizeButton(button: googleSignInButton)
    }
    
}

/*
    GoogleSignIn Button Implementation
 */
extension OnboardingViewController {
    
    override func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error, could not sign In User: \(error.localizedDescription)")
            super.failedSignInAlert()
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("ID Token: \(String(describing: authentication.idToken)) Access Token: \(String(describing: authentication.accessToken))")
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if error != nil {
                  print("Error, could not authenticate user :\(String(describing: error?.localizedDescription))")
                return
            } else {
                print("SignIn Successful")
                SVProgressHUD.show()
                self.instantiateDashVC(identifier: self.goToDashboard)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected from app : \(error.localizedDescription)")
    }
}

extension OnboardingViewController {
    
}
