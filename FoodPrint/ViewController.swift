//
//  ViewController.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import UIKit
import SwiftUI

@available(iOS 15.0, *)
struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        PreviewContainerView(controller: ViewController())
            .edgesIgnoringSafeArea(.all)
    }
}

@available(iOS 15.0, *)
struct PreviewContainerView: UIViewControllerRepresentable {
    let controller: UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

class ViewController: UIPageViewController {

    var pages = [UIViewController]()

    let skipButton = UIButton()
    let nextButton = UIButton()
    let pageControl = UIPageControl()
    let initialPage = 0

    // animations
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
}

extension ViewController {

    func setup() {
        dataSource = self
        delegate = self

        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        let loginPage = UIHostingController(rootView: LoginPageView())
        let heightPage = UIHostingController(rootView: SwipingHeightPageView())
        let weightPage = UIHostingController(rootView: SwipingWeightPageView())
        let genderPage = UIHostingController(rootView: SwipingGenderPageView())
        let agePage = UIHostingController(rootView: SwipingAgePageView())
        let eatPage = UIHostingController(rootView: SwipingEatPageView())

        pages.append(heightPage)
        pages.append(weightPage)
        pages.append(genderPage)
        pages.append(agePage)
        pages.append(eatPage)
        pages.append(loginPage)

        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }

    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(.systemBlue, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
    }

    func layout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)

        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),


            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
        ])

        // for animations
        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)

        pageControlBottomAnchor?.isActive = true
        skipButtonTopAnchor?.isActive = true
        nextButtonTopAnchor?.isActive = true
    }
}

// MARK: - DataSource

extension ViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            //return pages.first              // wrap first
            return nil
        }
    }
}

// MARK: - Delegates

extension ViewController: UIPageViewControllerDelegate {

    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }

        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
        
        if currentIndex == pages.count - 1 {
            disablePageViewController()
        }
    }
    
    private func disablePageViewController() {
        dataSource = nil
        delegate = nil
    }

    private func animateControlsIfNeeded() {
        let lastPage = pageControl.currentPage == pages.count - 1

        if lastPage {
            hideControls()
            disablePageViewController()
        } else {
            showControls()
        }

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideControls() {
        pageControlBottomAnchor?.constant = -80
        skipButtonTopAnchor?.constant = -80
        nextButtonTopAnchor?.constant = -80
    }

    private func showControls() {
        pageControlBottomAnchor?.constant = 16
        skipButtonTopAnchor?.constant = 16
        nextButtonTopAnchor?.constant = 16
    }
}

// MARK: - Actions

extension ViewController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        animateControlsIfNeeded()
    }

    @objc func skipTapped(_ sender: UIButton) {
        let lastPage = pages.count - 1
        pageControl.currentPage = lastPage

        goToSpecificPage(index: lastPage, ofViewControllers: pages)
        animateControlsIfNeeded()
    }

    @objc func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        goToNextPage()
        animateControlsIfNeeded()
    }
}

// MARK: - Extensions

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }

        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }

        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }

    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}

