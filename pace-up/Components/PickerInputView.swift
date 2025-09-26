import UIKit

class PickerInputView: UIView {
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  let valueLabel: UILabel = {
    let label = UILabel()
    label.textColor = .text
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "chevron.down")
    imageView.tintColor = .lightGray
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  var placeholder: String? {
    didSet {
      placeholderLabel.text = placeholder
      updateLabelVisibility()
    }
  }
  
  var text: String? {
    didSet {
      valueLabel.text = text
      updateLabelVisibility()
    }
  }
  
  let pickerView = UIPickerView()
  
  override var canBecomeFirstResponder: Bool {
    return true
  }

  override var inputView: UIView? {
    return pickerView
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .background
    layer.cornerRadius = 14
    layer.borderColor = UIColor.systemGray5.cgColor
    layer.borderWidth = 1
    
    addSubview(placeholderLabel)
    addSubview(valueLabel)
    addSubview(iconImageView)
    
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      iconImageView.heightAnchor.constraint(equalToConstant: 20),
      iconImageView.widthAnchor.constraint(equalToConstant: 20)
    ])
    
    updateLabelVisibility()
  }
  
  private func updateLabelVisibility() {
    placeholderLabel.isHidden = (text != nil && !text!.isEmpty)
    valueLabel.isHidden = !placeholderLabel.isHidden
  }
}
