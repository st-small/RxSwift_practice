//
//  BindDataViewController.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 06.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindDataViewController: UIViewController {
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: Button!
    
    let disposeBag = DisposeBag()
    let buttonTapped = PublishSubject<String>()
    let textFieldText = Variable("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .bind(to: textFieldText)
            .disposed(by: disposeBag)
        
        textFieldText.asObservable()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .map { "Tapped! " }
            .bind(to: buttonTapped)
            .disposed(by: disposeBag)
        
        buttonTapped
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
