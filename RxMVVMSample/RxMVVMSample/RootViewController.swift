//
//  RootViewController.swift
//  RxMVVMSample
//
//  Created by Stanly Shiyanovskiy on 16.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RootViewController: UINavigationController {

    var viewModel: RootViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Наблюдаем за навигационными действиями и соответствующим образом настраиваем навигационный стек
        
        viewModel.navigationStackActions
            .subscribe(onNext: { [weak self] navigationStackAction in
                
                switch navigationStackAction {
                case .set(viewModels: let viewModels, animated: let animated):
                    let viewControllers = viewModels.flatMap { viewController(forViewModel: $0) }
                    self?.setViewControllers(viewControllers, animated: animated)
                    
                case .push(viewModel: let viewModel, animated: let animated):
                    guard let viewController = viewController(forViewModel: viewModel) else { return }
                    self?.pushViewController(viewController, animated: animated)
                    
                case .pop(animated: let animated):
                    _ = self?.popViewController(animated: animated)
                }
            })
        .disposed(by: disposeBag)
    }
}

























