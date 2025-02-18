//
//  SimpleValidationViewController.swift
//  RxPractice
//
//  Created by 박준우 on 2/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SimpleValidationViewController: UIViewController {
    
    private let idTextField: UITextField = UITextField()
    private let pwTextField: UITextField = UITextField()

    private let idLabel: UILabel = UILabel()
    private let pwLabel: UILabel = UILabel()
    
    private let button: UIButton = UIButton()
    
    private let disposBag = DisposeBag()
    
    private let minimalCount: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
        
        let id = self.idTextField.rx.text.orEmpty
            .withUnretained(self, resultSelector: { owner, value in
                return value.count >= owner.minimalCount
            })
        
        let pw = self.pwTextField.rx.text.orEmpty
            .withUnretained(self, resultSelector: { owner, value in
                return value.count >= owner.minimalCount
            })
        
        Observable.combineLatest(id, pw)
            .map { id, pw in
                return (id, pw, id && pw)
            }
            .bind(with: self) { owner, value in
                owner.setIDLabel(value: value.0)
                owner.setPWLabel(value: value.1)
                owner.setButtonState(value: value.2)
            }
            .disposed(by: self.disposBag)
    }
    
    private func configureHierarchy() {
        [self.idTextField, self.pwTextField, self.idLabel, self.pwLabel, self.button].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func configureLayout() {
        self.idTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        self.idLabel.snp.makeConstraints { make in
            make.top.equalTo(self.idTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        self.pwTextField.snp.makeConstraints { make in
            make.top.equalTo(self.idLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        self.pwLabel.snp.makeConstraints { make in
            make.top.equalTo(self.pwTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        self.button.snp.makeConstraints { make in
            make.top.equalTo(self.pwLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    private func configureView() {
        self.view.backgroundColor = .gray
        self.idTextField.borderStyle = .roundedRect
        self.pwTextField.borderStyle = .roundedRect
        self.pwTextField.isSecureTextEntry = true
        self.button.setTitleColor(.white, for: .highlighted)
        self.button.setTitleColor(.black, for: [])
        self.button.setTitle("버튼", for: [])
        self.setIDLabel(value: false)
        self.setPWLabel(value: false)
        self.setButtonState(value: false)
    }
    
    private func setIDLabel(value: Bool) {
        self.idLabel.textColor = value ? .blue : .red
        self.idLabel.text = value ? "가능한 ID입니다" : "ID는 적어도 \(self.minimalCount)자리 이상이어야 합니다"
    }
    
    private func setPWLabel(value: Bool) {
        self.pwLabel.textColor = value ? .blue : .red
        self.pwLabel.text = value ? "가능한 PW입니다" : "PW는 적어도 \(self.minimalCount)자리 이상이어야 합니다"
    }
    
    private func setButtonState(value: Bool) {
        self.button.backgroundColor = value ? .green : .lightGray
        self.button.isEnabled = value
    }
}
