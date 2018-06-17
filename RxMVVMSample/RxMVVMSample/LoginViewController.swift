//
//  LoginViewController.swift
//  RxMVVMSample
//
//  Created by Stanly Shiyanovskiy on 16.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Log In"
        
        textField.rx.text
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberIsValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(onNext: viewModel.submit)
            .disposed(by: disposeBag)
    }

}
