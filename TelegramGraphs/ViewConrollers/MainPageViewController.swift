//
//  MainPageViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/17/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {

    var orderedViewControllers = GraphData.shared.viewControllersWithDifferentGraphs

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        //set first view controller
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            GraphData.shared.activeGraph = firstViewController.graphToDrawInVC
            firstViewController.graphView.setNeedsDisplay()
            }
    }
}

// MARK: UIPageViewControllerDataSource

extension MainPageViewController: UIPageViewControllerDataSource {

    //logic of swipe right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! GraphViewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    //logic of swipe left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! GraphViewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
}

// MARK: UIPageViewControllerDelegate

extension MainPageViewController: UIPageViewControllerDelegate {

    //find VC which will be diaplayed
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let graphVC = pendingViewControllers.first as! GraphViewController
        GraphData.shared.activeGraph = graphVC.graphToDrawInVC
        graphVC.graphView.setNeedsDisplay()
    }
}
