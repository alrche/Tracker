//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct TrackerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TrackerViewController().showPreview()
    }
}

final class TrackerViewController: UIViewController {

    // MARK: - Subviews
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "tracker_add") {
            button.setImage(imageButton, for: .normal)
            button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        }
        return button
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_DE")
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker.widthAnchor.constraint(equalToConstant: 87).isActive = true
        return picker
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    lazy var currentCategories: [TrackerCategory] = {
        filterCategoriesToShow()
    }()

    // MARK: - Core Data Stores
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()

    // MARK: - VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        setupView()
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
    }

    @objc
    func didTapPlusButton() {
        let createTrackerViewController = NewTrackerViewController()
        createTrackerViewController.delegate = self
        let createTracker = UINavigationController(rootViewController: createTrackerViewController)
        navigationController?.present(createTracker, animated: true)
    }


    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        currentDate = selectedDate
        updateCollectionAccordingToDate()
    }

    // MARK: - Setup view
    private func setupView() {
        let subViews = [customNavigationBar, collectionView]
        subViews.forEach { view.addSubview($0) }
        setupNavigationBar()
        setupCollectionView()
        createNewCategory()

        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.completedTrackers
        updateCollectionAccordingToDate()
    }

    // MARK: - Custom navigation bar

    private let customNavigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = .trackerWhite
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.trackerBlack]
        navigationController?.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        setupNavigationBarConstraints()

    }

    private func setupNavigationBarConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 182)
        ])
    }

    // MARK: setupCollectionView
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.identifier
        )
        collectionView.backgroundColor = .trackerWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 182),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func createNewCategory() {
        try? trackerCategoryStore.addNewCategory(name: "Важное или не очень")
    }

    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: collectionView.frame)
        backgroundView.setupNoTrackersState()
        collectionView.backgroundView = backgroundView
    }

    private func filterCategoriesToShow() -> [TrackerCategory] {
        currentCategories = []
        let weekdayInt = Calendar.current.component(.weekday, from: currentDate)
        guard let day = (weekdayInt == 1) ? WeekDays(rawValue: 7) : WeekDays(rawValue: weekdayInt - 1) else {
            return currentCategories
        }

        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(day)
            }

            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        return currentCategories
    }

    private func updateCollectionAccordingToDate() {
        currentCategories = filterCategoriesToShow()
        collectionView.reloadData()
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.counterDelegate = self
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        cell.trackerInfo = TrackerInfoCell(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            daysCount: calculateTimesTrackerWasCompleted(id: tracker.id),
            currentDay: currentDate
        )
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if currentCategories.count == 0 {
            showPlaceHolder()
        } else {
            collectionView.backgroundView = nil
        }
        return currentCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath
            ) as? HeaderCollectionReusableView {
                sectionHeader.titleLabel.text = categories[indexPath.section].title
                return sectionHeader
            }
        }
        return UICollectionReusableView()
    }

}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
}

//MARK: TrackerCounterDelegate
extension TrackerViewController: TrackerCounterDelegate {
    func increaseTrackerCounter(id: UUID, date: Date) {
        try? trackerRecordStore.addRecord(trackerId: id, date: date)
    }

    func decreaseTrackerCounter(id: UUID, date: Date) {
        try? trackerRecordStore.deleteRecord(trackerId: id, date: date)
    }

    func checkIfTrackerWasCompletedAtCurrentDay(id: UUID, date: Date) -> Bool {
        let contains = completedTrackers.filter {
            $0.id == id && Calendar.current.isDate(
                $0.date,
                equalTo: currentDate,
                toGranularity: .day
            )
        }.count > 0
        return contains
    }

    func calculateTimesTrackerWasCompleted(id: UUID) -> Int {
        let contains = completedTrackers.filter {
            $0.id == id
        }
        return contains.count
    }
}

//MARK: - SearchController
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text != ""{
            updateCollectionAccordingToSearchRequest(trackerToSearch: text)
        }
    }

    private func updateCollectionAccordingToSearchRequest(trackerToSearch: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.name.contains(trackerToSearch)
            }
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        collectionView.reloadData()
    }
}

//MARK: TrackerSearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        updateCollectionAccordingToDate()
    }
}

//MARK: TrackerCreationDelegate
extension TrackerViewController: CreationTrackerDelegate {
    func createTracker(tracker: Tracker, category: String) {
        try? trackerStore.addNewTracker(tracker: tracker, forCategory: category)
        updateCollectionAccordingToDate()
    }
}

//MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet) {
        categories = trackerCategoryStore.categories
        updateCollectionAccordingToDate()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackerViewController: TrackerRecordStoreDelegate {
    func recordUpdate() {
        completedTrackers = trackerRecordStore.completedTrackers
    }
}
