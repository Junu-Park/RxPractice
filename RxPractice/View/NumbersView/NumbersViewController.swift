//
//  NumbersViewController.swift
//  RxPractice
//
//  Created by 박준우 on 2/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class NumbersViewController: UIViewController {
    
    private let textField1: UITextField = UITextField()
    private let textField2: UITextField = UITextField()
    private let textField3: UITextField = UITextField()
    
    private let plusLabel: UILabel = UILabel()
    private let resultLabel: UILabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.configureHierarchy()
        self.configureLayout()
        
        // TODO: zip(제대로 적용 안 됨) vs combineLatest
        Observable
            .combineLatest(self.textField1.rx.text.orEmpty, self.textField2.rx.text.orEmpty, self.textField3.rx.text.orEmpty)
            .map { value1, value2, value3 in
                let first = Int(value1) ?? 0
                let second = Int(value2) ?? 0
                let third = Int(value3) ?? 0
                let result = first + second + third
                return String(result)
            }
            .withUnretained(self)
            .bind { owner, value in
                owner.resultLabel.text = value
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
        self.resultLabel.backgroundColor = .lightGray
        self.plusLabel.text = "+"
        self.plusLabel.textColor = .black
        self.textField1.borderStyle = .roundedRect
        self.textField2.borderStyle = .roundedRect
        self.textField3.borderStyle = .roundedRect
    }
    
    private func configureHierarchy() {
        [self.textField1, self.textField2, self.textField3, self.plusLabel, self.resultLabel].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func configureLayout() {
        self.resultLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.center.equalToSuperview()
        }
        self.textField3.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.resultLabel.snp.top).offset(-16)
        }
        self.plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.textField3)
            make.trailing.equalTo(self.textField3.snp.leading).offset(-16)
        }
        self.textField2.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.textField3.snp.top).offset(-16)
        }
        self.textField1.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.textField2.snp.top).offset(-16)
        }
    }
}
