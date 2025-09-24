import UIKit
import FirebaseFirestore

class OnboardingViewController: BaseViewController {
  private let baseView = OnboardingView()
  private let viewModel: OnboardingViewModelProtocol
  
  init(viewModel: OnboardingViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    setupDelegates()
    setupTargets()
    setupViewModelCallbacks()
  }
  
  private func setupNavigation() {
    navigationItem.title = "Seu plano"
    navigationItem.backButtonTitle = "Etapa 1"
  }
  
  private func setupDelegates() {
    baseView.experiencePicker.pickerView.delegate = self
    baseView.experiencePicker.pickerView.dataSource = self
    
    baseView.goalPicker.pickerView.delegate = self
    baseView.goalPicker.pickerView.dataSource = self
    
    baseView.weightTextField.delegate = self
    baseView.heightTextField.delegate = self
  }
  
  private func setupTargets() {
    baseView.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    
    let expTap = UITapGestureRecognizer(target: self, action: #selector(experienceTapped))
    baseView.experiencePicker.addGestureRecognizer(expTap)
    
    let goalTap = UITapGestureRecognizer(target: self, action: #selector(goalTapped))
    baseView.goalPicker.addGestureRecognizer(goalTap)
    
    baseView.dayCheckBoxes.forEach { checkbox in
      checkbox.addTarget(self, action: #selector(dayCheckboxTapped(_:)), for: .touchUpInside)
    }
  }
  
  private func setupViewModelCallbacks() {
    viewModel.onProgressUpdate = { [weak self] newProgress in
      self?.baseView.updateProgress(to: newProgress)
    }
  }
  
  @objc private func didTapNext() {
    viewModel.didTapNext()
  }
  
  @objc private func experienceTapped() {
    baseView.experiencePicker.becomeFirstResponder()
  }
  
  @objc private func goalTapped() {
    baseView.goalPicker.becomeFirstResponder()
  }
  
  @objc private func dayCheckboxTapped(_ sender: CheckboxButton) {
    guard let dayTitle = sender.title(for: .normal) else { return }
    
    if sender.isSelected {
      viewModel.selectedDays.insert(dayTitle)
    } else {
      viewModel.selectedDays.remove(dayTitle)
    }
  }
}

extension OnboardingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == baseView.experiencePicker.pickerView {
      return viewModel.experienceOptions.count
    } else if pickerView == baseView.goalPicker.pickerView {
      return viewModel.goalOptions.count
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == baseView.experiencePicker.pickerView {
      return viewModel.experienceOptions[row]
    } else if pickerView == baseView.goalPicker.pickerView {
      return viewModel.goalOptions[row]
    }
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == baseView.experiencePicker.pickerView {
      let selectedExperience = viewModel.experienceOptions[row]
      baseView.experiencePicker.text = selectedExperience
      viewModel.experience = selectedExperience
    } else if pickerView == baseView.goalPicker.pickerView {
      let selectedGoal = viewModel.goalOptions[row]
      baseView.goalPicker.text = selectedGoal
      viewModel.goal = selectedGoal
    }
  }
}

extension OnboardingViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if textField == baseView.weightTextField {
      viewModel.weight = textField.text
    } else if textField == baseView.heightTextField {
      viewModel.height = textField.text
    }
  }
}
