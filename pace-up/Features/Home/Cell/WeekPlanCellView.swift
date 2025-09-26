// WeekPlanCell.swift
import UIKit

class WeekPlanCell: UICollectionViewCell {
    static let reuseIdentifier = "WeekPlanCell"
    
    // Uma stack view para listar os cards de treino do dia
    private let workoutsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Preenche a célula com os treinos de uma semana específica
    func configure(with workouts: [WorkoutDay]) {
        // Limpa a lista antiga antes de adicionar a nova
        workoutsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Adiciona um card para cada treino da semana
        for workout in workouts {
            let card = WorkoutDayCardView()
            card.configure(with: workout)
            workoutsStackView.addArrangedSubview(card)
        }
    }
    
    private func setupUI() {
        contentView.addSubview(workoutsStackView)
        NSLayoutConstraint.activate([
            workoutsStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            workoutsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            workoutsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
