//
//  BirthdayViewController.swift
//  RxPractice
//
//  Created by 박준우 on 2/19/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BirthdayViewController: UIViewController {

    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    private let nextButton = PointButton(title: "가입하기")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.configureHierarchy()
        self.configureLayout()
        
        self.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        self.birthDayPicker.rx.date
            .map({ value in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: value)
                let year = String(components.year ?? 0)
                let month = String(components.month ?? 0)
                let day = String(components.day ?? 0)
                let isOver = (2025 - (components.year ?? 2025) >= 17)
                return (year, month, day, isOver)
            })
            .bind(with: self) { owner, value  in
                owner.yearLabel.text = "\(value.0)년"
                owner.monthLabel.text = "\(value.1)월"
                owner.dayLabel.text = "\(value.2)일"
                owner.nextButton.isEnabled = value.3
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc private func nextButtonClicked() {
        
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
        self.nextButton.setTitleColor(.gray, for: .highlighted)
        self.nextButton.setTitleColor(.white, for: [])
    }
    
    private func configureHierarchy() {
        self.view.addSubview(infoLabel)
        self.view.addSubview(containerStackView)
        self.view.addSubview(birthDayPicker)
        self.view.addSubview(nextButton)
    }
    
    private func configureLayout() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
