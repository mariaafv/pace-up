// WorkoutDayCardView.swift
import UIKit

class WorkoutDayCardView: UIView {
    
    // MARK: - UI Components
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .appGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
  private let dayLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .bold), textColor: .text)
  private let typeLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .gray)
  private let durationLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .semibold), textColor: .text)

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Configuration
    
    func configure(with workout: WorkoutDay) {
        dayLabel.text = workout.day ?? "Dia indefinido"
        typeLabel.text = workout.type ?? "Treino"
        
        if let duration = workout.duration_minutes, duration > 0 {
            durationLabel.text = "\(duration) min"
            durationLabel.isHidden = false
        } else {
            durationLabel.text = ""
            durationLabel.isHidden = true
        }
        
        // Define o ícone com base no tipo de treino
        switch (workout.type ?? "").lowercased() {
            case let str where str.contains("leve"):
                iconImageView.image = UIImage(systemName: "figure.run")
            case let str where str.contains("tiro"):
                iconImageView.image = UIImage(systemName: "hare.fill")
            case let str where str.contains("longo"):
                iconImageView.image = UIImage(systemName: "tortoise.fill")
            case let str where str.contains("força"):
                iconImageView.image = UIImage(systemName: "flame.fill")
            default: // Descanso
                iconImageView.image = UIImage(systemName: "bed.double.fill")
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        let infoStack = UIStackView(arrangedSubviews: [dayLabel, typeLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        
        let mainStack = UIStackView(arrangedSubviews: [iconContainerView, infoStack, durationLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainerView.addSubview(iconImageView)
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
