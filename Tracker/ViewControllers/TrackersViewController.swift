//
//  CollectionViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 28.07.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    let collectionView: TrackersCollectionView = {
        let collectionView = TrackersCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .brown
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let barButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(named: "Add tracker icon")
        barButtonItem.tintColor = .ypBlack
        return barButtonItem
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .searchTextFieldColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newTrackerObserver: NSObjectProtocol?
    var categories = [TrackerCategory]()
    var completedTrackers = [TrackerRecord]()
    var currentDate: Date?
    var dataHelper: DataHelper?
    var categoriesToShow = [TrackerCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        currentDate = datePicker.date
        
        dataHelper = DataHelper()
        dataHelper?.trackersViewController = self
        
        newTrackerObserver = NotificationCenter.default.addObserver(forName: NewHabitViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.setupCollectionView()
            self?.collectionView.reloadData()
        })
        
//        setupCollectionView()
        setupNavigationBar()
        setupSearchTextField()
        setupStarImage()
        setupLabel()
        
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: currentDate!).weekday ?? -1
        print(dayOfWeek)
    }
    
    private func showTrackersForDate(_ date: Date) {
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: date).weekday ?? -1
        categoriesToShow.removeAll()
        
        for category in categories {
            var trackers = [Tracker]()
            
            for tracker in category.trackers {
                for day in tracker.schedule.daysOfWeek {
                    if day.getNumberOfDay() == dayOfWeek {
                        trackers.append(tracker)
                    }
                }
            }
            
            if !trackers.isEmpty {
                categoriesToShow.append(TrackerCategory(name: category.name, trackers: trackers))
            }
        }
        
        print("categoriesToShow")
        print(categoriesToShow)
        print("categories")
        print(categories)
    }
    
    private func setupCollectionView() {
        collectionView.trackersViewController = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupDatePicker()
        
        barButtonItem.target = self
        barButtonItem.action = #selector(addTracker)
        
        navigationItem.leftBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupStarImage() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func addTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersViewController = self
        let navigationController = UINavigationController(rootViewController: trackerTypeViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        let date = sender.date
        currentDate = date
        showTrackersForDate(date)
    }
}

extension TrackersViewController: UITextFieldDelegate {
}
