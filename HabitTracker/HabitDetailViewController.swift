//
//  HabitDetailViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Charts

class HabitDetailViewController: UIViewController, ChartViewDelegate {

    // MARK: - Attributes

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    var dataController: DatabaseService!
    var habit: Habit? = nil {
        didSet {
            self.configureData()
        }
    }


    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // if habit is updated, fetch the new one
        if let h = habit {
            dataController.fetchHabit(h.objectID, callback: { (habit: Habit?) in
                self.habit = habit
            })
        }

        configureBarChart()
    }

    func configureView() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editHabit")
        self.navigationItem.rightBarButtonItem = editButton
        configureData()
    }

    func configureData() {
        self.navigationItem.title = habit?.name
    }


    // MARK: - Charts

    func configureBarChart() {
        barChartView.delegate = self
        barChartView.descriptionText = ""
        barChartView.noDataTextDescription = "Data will be loaded soon."

        barChartView.maxVisibleValueCount = 0
        barChartView.maxVisibleValueCount = 7

        barChartView.pinchZoomEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.dragEnabled = false

        barChartView.backgroundColor = Constants.Colors.accent
        barChartView.borderColor = UIColor.whiteColor()
        barChartView.descriptionTextColor = UIColor.whiteColor()
        barChartView.legend.textColor = UIColor.whiteColor()

        let yAxis = barChartView.getAxis(ChartYAxis.AxisDependency.Left)
        yAxis.drawGridLinesEnabled = false
        yAxis.labelTextColor = UIColor.whiteColor()
        yAxis.axisLineColor = UIColor.whiteColor()

        barChartView.getAxis(ChartYAxis.AxisDependency.Right).enabled = false


        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        barChartView.xAxis.axisLineColor = UIColor.whiteColor()
        barChartView.xAxis.gridColor = UIColor.whiteColor()


        // let entries = self.habit.entries
        let xVals = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var yVals: [BarChartDataEntry] = []


        for idx in 0...6 {
            yVals.append(BarChartDataEntry(value: Double(idx + 1), xIndex: idx))
        }

        let set1 = BarChartDataSet(yVals: yVals, label: "Day")
        set1.colors = [UIColor.whiteColor()]
        set1.barSpace = 0.25
        set1.highlightColor = Constants.Colors.normalPrimary

        let data = BarChartData(xVals: xVals, dataSet: set1)
        data.setValueFont(UIFont.systemFontOfSize(14))
        data.setValueTextColor(UIColor.whiteColor())
        self.barChartView.data = data

        self.view.reloadInputViews()
    }

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let chartMarker = FloatingChartMarker()
        chartMarker.textLabel = "Hella" // probably just add textLabel to entry
        chartView.marker = chartMarker

    }


    // MARK: - Segues

    func editHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showEditHabit, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showEditHabit {
            let controller = segue.destinationViewController as! HabitViewController
            controller.dataController = self.dataController
            controller.currentState = []
            controller.habit = habit
        }
    }

}
