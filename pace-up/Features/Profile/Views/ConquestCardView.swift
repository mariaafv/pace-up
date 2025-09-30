//
//  ConquestCardView.swift
//  pace-up
//
//  Created by Maria Aida Vitoria on 26/09/25.
//
import UIKit

class ConquestCardView: UIView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(backgroundColor: UIColor, value: String, unit: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 12
        self.valueLabel.text = value
        self.unitLabel.text = unit
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(valueLabel)
        addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            unitLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            unitLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}
