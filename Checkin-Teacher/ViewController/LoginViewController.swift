//
//  LoginViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Reusable
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var googleSignButton: GIDSignInButton!
    
    let loginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.center = googleSignButton.center
        loginButton.center.y += 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func loginByCredential(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
            if let _ = error {
                self?.showErrorAlert(errMessage: Constants.Message.unknowerror)
            } else {
                let homeVC = HomeViewController.instantiate()
                self?.navigationController?.viewControllers = [homeVC]
            }
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            showErrorAlert(errMessage: Constants.Message.unknowerror)
            return
        }
        guard let current = AccessToken.current else { return }
        LoginManager().logOut()
        let credential = FacebookAuthProvider.credential(withAccessToken: current.tokenString)
        loginByCredential(credential: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            showErrorAlert(errMessage: Constants.Message.unknowerror)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        loginByCredential(credential: credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "Login", bundle: nil)
}
