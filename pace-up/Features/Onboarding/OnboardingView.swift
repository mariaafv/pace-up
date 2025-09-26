import UIKit

class OnboardingView: UIView {
  private let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 20
    return stack
  }()
  
  private let stepLabel = UILabel(text: "Etapa 1 de 5", font: .systemFont(ofSize: 14), textColor: .gray)
  private let progressView: UIProgressView = {
    let pv = UIProgressView(progressViewStyle: .bar)
    pv.progressTintColor = .appGreen
    pv.trackTintColor = .systemGray5
    pv.layer.cornerRadius = 4
    pv.clipsToBounds = true
    return pv
  }()
  
  
  private let titleLabel = UILabel(text: "Conte-nos sobre você", font: .systemFont(ofSize: 28, weight: .bold), textColor: .text)
  
  let weightTextField = CustomTextField(placeholder: "Peso (kg)", keyboardType: .decimalPad, isSecure: false)
  let heightTextField = CustomTextField(placeholder: "Altura (cm)", keyboardType: .numberPad, isSecure: false)
  let experiencePicker = PickerInputView()
  let goalPicker = PickerInputView()
  
  private let daysTitleLabel = UILabel(text: "Quais dias da semana deseja correr?", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .text  )
  
  let dayCheckBoxes: [CheckboxButton] = {
    let days = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"]
    return days.map { dayTitle in
      let button = CheckboxButton()
      button.setTitle(dayTitle, for: .normal)
      return button
    }
  }()
  
  private lazy var daysStackView: UIStackView = {
    let row1 = UIStackView(arrangedSubviews: Array(dayCheckBoxes[0...3]))
    row1.axis = .horizontal
    row1.distribution = .fillEqually
    
    let row2 = UIStackView(arrangedSubviews: Array(dayCheckBoxes[4...6]))
    row2.axis = .horizontal
    row2.distribution = .fillEqually
    
    let containerView = UIView()
    containerView.addSubview(row2)
    row2.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      row2.topAnchor.constraint(equalTo: containerView.topAnchor),
      row2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      row2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
    
    let stack = UIStackView(arrangedSubviews: [row1, containerView])
    stack.axis = .vertical
    stack.spacing = 10
    return stack
  }()
  
  let nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Gerar treino", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
    button.backgroundColor = .appGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 28
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func updateProgress(to value: Float) {
    progressView.setProgress(value, animated: true)
  }
  
  private func setupView() {
    backgroundColor = .systemGroupedBackground
    experiencePicker.placeholder = "Tempo de experiência"
    goalPicker.placeholder = "Objetivo final"
    
    setupHierarchy()
    setupConstraints()
  }
  
  private func setupHierarchy() {
    addSubview(scrollView)
    addSubview(nextButton)
    scrollView.addSubview(contentView)
    contentView.addSubview(mainStackView)
    
    mainStackView.addArrangedSubview(stepLabel)
    mainStackView.addArrangedSubview(progressView)
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(weightTextField)
    mainStackView.addArrangedSubview(heightTextField)
    mainStackView.addArrangedSubview(experiencePicker)
    mainStackView.addArrangedSubview(goalPicker)
    
    mainStackView.addArrangedSubview(daysTitleLabel)
    mainStackView.addArrangedSubview(daysStackView)
    
    mainStackView.setCustomSpacing(5, after: stepLabel)
    mainStackView.setCustomSpacing(40, after: progressView)
    mainStackView.setCustomSpacing(30, after: goalPicker)
    mainStackView.setCustomSpacing(15, after: daysTitleLabel)  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
      nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
      nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
      nextButton.heightAnchor.constraint(equalToConstant: 56),
      
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
      
      contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
      
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      progressView.heightAnchor.constraint(equalToConstant: 8),
      weightTextField.heightAnchor.constraint(equalToConstant: 56),
      heightTextField.heightAnchor.constraint(equalToConstant: 56),
      experiencePicker.heightAnchor.constraint(equalToConstant: 56),
      goalPicker.heightAnchor.constraint(equalToConstant: 56)
    ])
  }
}

extension UILabel {
  convenience init(text: String, font: UIFont, textColor: UIColor) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
    self.textColor = textColor
  }
}
