//
//  RootViewModel.swift
//  RxMVVMSample
//
//  Created by Stanly Shiyanovskiy on 16.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RxSwift
import Set

private let setClientId = "<your client id>"
private let setClientSecret = "<your client secret>"

enum NavigationStackAction {
    case set(viewModels: [Any], animated: Bool)
    case push(viewModel: Any, animated: Bool)
    case pop(animated: Bool)
}

class RootViewModel {
    
    lazy private(set) var navigationStackActions: BehaviorSubject<NavigationStackAction> = BehaviorSubject<NavigationStackAction>(value: .set(viewModels: [LoginViewModel()], animated: false))
    
    private let disposeBag = DisposeBag()
    
    func createLoginViewModel() -> LoginViewModel {
        let loginViewModel = LoginViewModel() 
        loginViewModel.events
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .loggedIn(phoneNumber: let phoneNumber):
                    self?.launchSetSDK(withPhoneNumber: phoneNumber)
                }
            })
        .disposed(by: disposeBag)
        return loginViewModel
    }
    
    func createSetViewModel() -> SetViewModel {
        let setViewModel = SetViewModel()
        setViewModel.events
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .logOut:
                    self?.stopSetSDKAndLogOut()
                }
            })
            .disposed(by: disposeBag)
        return setViewModel
    }
    
    private func launchSetSDK(withPhoneNumber phoneNumber: String) {
        let setConfiguration = SetConfiguration(clientId: setClientId, clientSecret: setClientSecret, userId: phoneNumber)
        SetSDK.instance.launch(withConfiguration: setConfiguration) { possibleError in 
            guard let "self" = self else { return }
            if let error = possibleError {
                print("Handle this error: \(error.localizedDescription)")
                return
            }
            self.navigationStackActions.onNext(.push(viewModel: self.createSetViewModel(), animated: true))
        }
    }
    
    private func stopSetSDKAndLogOut() {
        SetSDK.instance.shutDown()
        navigationStackActions.onNext(.pop(animated: true))
    }
}
