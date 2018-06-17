//
//  Globals.swift
//  RxMVVMSample
//
//  Created by Stanly Shiyanovskiy on 16.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

func viewController(forViewModel viewModel: Any) -> UIViewController? {
    switch viewModel {
    case let viewModel as RootViewModel:
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootViewController") as? RootViewController
        viewController?.viewModel = viewModel
        return viewController
    case let viewModel as LoginViewModel:
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
        viewController?.viewModel = viewModel
        return viewController
    default:
        return nil
    }
}
