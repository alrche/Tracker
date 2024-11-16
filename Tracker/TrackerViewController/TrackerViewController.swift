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

final class TrackerViewController: UIViewController, ViewConfigurable {
    var placeHolder: PlaceHolderView?

    // MARK: - Subviews
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "tracker_add")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(imageButton, for: .normal)
            button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        }
        return button
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_DE")
        picker.backgroundColor = .trackerWhite
        picker.preferredDatePickerStyle = .compact
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.overrideUserInterfaceStyle = .light
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

    let pinnedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .trackerBlue
        return button
    }()

    // MARK: - Core Data Store
    private let trackerCategoryStore = TrackerCategoryStore()

    // MARK: - Private Properties
    private var presenter = TrackerPresenter()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - VC methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.reportToAppMetricaService(event: .open, params: ["screen" : "Main"])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.reportToAppMetricaService(event: .close, params: ["screen" : "Main"])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        presenter.viewController = self
        setupView()
    }

    @objc
    func didTapPlusButton() {
        presenter.reportToAppMetricaService(event: .click, params: ["screen" : "Main", "item" : "add_track"])
        let createTrackerViewController = NewTrackerViewController()
        createTrackerViewController.delegate = presenter
        let createTracker = UINavigationController(rootViewController: createTrackerViewController)

        navigationController?.present(createTracker, animated: true)
    }


    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        presenter.datePickerWasChanged(date: selectedDate)
    }

    @objc private func filterButtonPressed() {
        presenter.filterButtonPressed()
    }

    // MARK: - Setup view
    private func setupView() {
        setupNavigationBar()
        setupCollectionView()
        configureView()
        setupFilterButton()

        presenter.updateMainScreen()
    }

    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [customNavigationBar, collectionView, filterButton]
        subViews.forEach { view.addSubview($0) }
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 182),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 182),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Custom navigation bar

    private let customNavigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = .trackerWhite
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = NSLocalizedString("trackers", comment: "")
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.trackerBlack]
        navigationController?.navigationBar.prefersLargeTitles = true

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("placeholder.searchbar", comment: "")
        navigationItem.searchController = searchController
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
    }

    private func setupFilterButton() {
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
    }

    private func createNewCategory(categoryName: String) {
        try? trackerCategoryStore.addNewCategory(name: categoryName)
    }

    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: collectionView.frame)
        backgroundView.setupNoTrackersState()
        collectionView.backgroundView = backgroundView
    }

    private func showSearchPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: collectionView.frame)
        backgroundView.setupNoSearchResultsState()
        collectionView.backgroundView = backgroundView
    }

    private func deleteTracker(tracker: Tracker) {
        presenter.reportToAppMetricaService(event: .click, params: ["screen" : "Main", "item" : "delete"])
        let alert = UIAlertController(
            title: NSLocalizedString("delete.confirmation", comment: ""),
            message: nil,
            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("delete", comment: ""),
            style: .destructive) { [weak self] _ in
                guard let self = self else {return}
                self.presenter.deleteTracker(tracker: tracker)
            }
        deleteAction.accessibilityIdentifier = "deleteTrackerConfirmation"
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel))

        present(alert, animated: true)
    }

    private func editTracker(tracker: TrackerInfoCell, category: TrackerCategory) {
        presenter.editTracker(tracker: tracker, category: category)
    }

    private func pinTracker(tracker:Tracker) {
        presenter.pinTracker(tracker: tracker)
    }

    func presentViewController(vc: UIViewController) {
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.counterDelegate = presenter
        let tracker = presenter.getTracker(forIndexPath: indexPath)
        let category = presenter.getCategory(forIndexPath: indexPath)
        cell.trackerInfo = TrackerInfoCell(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            daysCount: presenter.calculateTimesTrackerWasCompleted(id: tracker.id),
            currentDay: presenter.currentDate,
            schedule: tracker.schedule,
            isPinned: tracker.isPinned
        )

        cell.deleteTrackerHandler = { [weak self] tracker in
            self?.deleteTracker(tracker: tracker)
        }
        cell.pinTrackerHandler = { [weak self] tracker in
            self?.pinTracker(tracker: tracker)
        }
        cell.editTrackerHandler = { [weak self] tracker in
            self?.editTracker(tracker: tracker, category: category)
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if searchController.isActive {
            if presenter.noSearchResults() {
                showSearchPlaceHolder()
            } else {
                collectionView.backgroundView = nil
            }
        } else {
            if presenter.noTrackersToShow() {
                showPlaceHolder()
            } else {
                collectionView.backgroundView = nil
            }
        }
        return presenter.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath) as? HeaderCollectionReusableView {

            sectionHeader.titleLabel.text = presenter.getCategory(forIndexPath: indexPath).title
            return sectionHeader
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


//MARK: - Updating Collection
extension TrackerViewController {
    func updateCollectionView() {
        updateFilterButton()
        collectionView.reloadData()
    }

    private func updateFilterButton() {
        if presenter.filterButtonShoulBeHidden() {
            filterButton.isHidden = true
        } else {
            filterButton.isHidden = false
        }
        filterButton.setTitleColor(.white, for: .normal)
    }
}

//MARK: - SearchController
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            presenter.updateCollectionAccordingToSearchBarResults(name: text)
            if presenter.noTrackersToShow() {
                placeHolder?.setupNoSearchResultsState()
            } else {
                collectionView.backgroundView = nil
            }
            collectionView.reloadData()
        }
    }
}

//MARK: TrackerSearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        presenter.updateMainScreen()
    }
}
