//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by 神村亮佑 on 2020/08/08.
//  Copyright © 2020 神村亮佑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class ViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        print("tapped login button")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.rx.text.map{ $0 ?? "" }.bind(to: loginViewModel.usernameTextPublishSubject).disposed(by: disposeBag)
         passwordTextField.rx.text.map{ $0 ?? "" }.bind(to: loginViewModel.passwordTextPublishedSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
    }


}

class LoginViewModel {
    
    let usernameTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishedSubject = PublishSubject<String>()
    
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextPublishSubject.asObservable().startWith(""), passwordTextPublishedSubject.asObservable()).map{ username, password in
                return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}
