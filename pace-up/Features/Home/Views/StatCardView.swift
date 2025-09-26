import UIKit

class StatCardView: UIView {
  private let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.tintColor = .appGreen
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .gray)
  private let valueLabel = UILabel(text: "", font: .systemFont(ofSize: 22, weight: .bold), textColor: .text)
  
  lazy var textStack: UIStackView = {
    let textStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    textStack.axis = .vertical
    textStack.alignment = .leading
    textStack.spacing = 4
    return textStack
  }()
  
  lazy var mainStack: UIStackView = {
    let mainStack = UIStackView(arrangedSubviews: [iconImageView, textStack])
    mainStack.axis = .vertical
    mainStack.alignment = .leading
    mainStack.spacing = 12
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    return mainStack
  }()
  
  init(icon: UIImage?, title: String, value: String) {
    super.init(frame: .zero)
    
    iconImageView.image = icon
    titleLabel.text = title
    valueLabel.text = value
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateValue(to newValue: String) {
    self.valueLabel.text = newValue
  }
  
  private func setupView() {
    backgroundColor = .background
    layer.cornerRadius = 18
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(mainStack)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      iconImageView.widthAnchor.constraint(equalToConstant: 24),
      iconImageView.heightAnchor.constraint(equalToConstant: 24),
      
      mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
    ])
  }
}
