//
//  LoginViewModel.swift
//  RxMVVMSample
//
//  Created by Stanly Shiyanovskiy on 16.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    enum Event {
        case loggedIn(phoneNumber: String)
    }
    
    let phoneNumber = Variable<String?>(nil)
    let events = PublishSubject<Event>()
    
    lazy private(set) var phoneNumberIsValid: Observable<Bool> = self.phoneNumber
        .asObservable()
        .map { number in
            guard let number = number else { return false }
            let regex = try! NSRegularExpression(pattern: "^[0-9]{11}$")
            let matches = regex.matches(in: number, options: [], range: NSRange(location: 0, length: number.count))
            return matches.count == 1
    }
    
    func submit() {
        guard let number = phoneNumber.value else { return }
        events.onNext(.loggedIn(phoneNumber: number))
    }
}
