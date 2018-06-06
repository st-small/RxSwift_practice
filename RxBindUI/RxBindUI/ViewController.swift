//
//  ViewController.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 06.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var button: Button!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var aSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!

    let disposeBag = DisposeBag()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        textField.rx.text.asDriver()
            .drive(textFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        textView.rx.text
            .bind(onNext: { 
                self.textViewLabel.text = "Character count: \($0!.count)"
            })
            .disposed(by: disposeBag)
        
        button.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.buttonLabel.text! += "Tapped!" 
                self.view.endEditing(true)
                UIView.animate(withDuration: 0.3, animations: { 
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
        
        segmentedControl.rx.value.asDriver()
            .skip(1)
            .drive(onNext: { 
                self.segmentedControlLabel.text = "Selected segment \($0)"
                UIView.animate(withDuration: 0.3, animations: { 
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
        
        slider.rx.value.asDriver()
            .drive(progressView.rx.progress)
            .disposed(by: disposeBag)
        
        aSwitch.rx.value.asDriver()
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        aSwitch.rx.value.asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        stepper.rx.value.asDriver()
            .map { String(Int($0)) }
            .drive(stepperLabel.rx.text)
            .disposed(by: disposeBag)
        
        datePicker.rx.date.asDriver()
            .map { self.dateFormatter.string(from: $0) }
            .drive(onNext: { self.datePickerLabel.text = "Selected date: \($0)"})
            .disposed(by: disposeBag)
    }
}

