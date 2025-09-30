//
//  ProfileInfoRowView.swift
//  pace-up
//
//  Created by Maria Aida Vitoria on 26/09/25.
//
import UIKit

class ProfileInfoRowView: UIView {
    
    private let labelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(label: String, value: String) {
        super.init(frame: .zero)
        self.labelLabel.text = label
        self.valueLabel.text = value
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(labelLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            labelLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: labelLabel.trailingAnchor, constant: 16),
            
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}
