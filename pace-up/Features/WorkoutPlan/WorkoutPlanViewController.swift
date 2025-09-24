import UIKit

class WorkoutPlanViewController: BaseViewController {
  private let baseView = WorkoutPlanView()
  private let viewModel: WorkoutPlanViewModelProtocol?
  
  init(viewModel: WorkoutPlanViewModelProtocol?) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCalendar()
    viewModel?.fetchWorkoutPlan()
  }
  
  private func setupCalendar() {
    baseView.calendarCollectionView.delegate = self
    baseView.calendarCollectionView.dataSource = self
    baseView.calendarCollectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
    
    selectToday()
  }
  
  private func selectToday() {
    let today = Date()
    let calendar = Calendar.current
    
    if let todayIndex = viewModel?.calendarDays.firstIndex(where: { calendar.isDate(today, inSameDayAs: $0.date) }) {
      let indexPath = IndexPath(item: todayIndex, section: 0)
      baseView.calendarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
  }
}

extension WorkoutPlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.calendarDays.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCell.reuseIdentifier, for: indexPath) as? CalendarDayCell else {
      return UICollectionViewCell()
    }
    let day = viewModel?.calendarDays[indexPath.item]
    cell.configure(dayNumber: day?.dayNumber ?? "", dayOfWeek: day?.dayOfWeek ?? "")
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.selectDate(at: indexPath.item)
  }
}
