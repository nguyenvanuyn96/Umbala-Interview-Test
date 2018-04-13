//
//  MatrixRotationViewController.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit

class MatrixRotationViewController: UIViewController {
    private var _decriptionInputNLabel: UILabel!
    private var _numOfRowInputTextField: UITextField!
    private var _generateMatrixButton: UIButton!
    private var _matrixTextView: UITextView!
    
    private var _matrix: [[Int]] = [[Int]]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        self.setupView()
        self.setupLayout()
    }
    
    private func setupView() {
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapBackBarButton))
        self.navigationController?.title = "Matrix Rotation"
        
        self._decriptionInputNLabel = UILabel()
        self._decriptionInputNLabel.text = "Input the number of row"
        
        self._numOfRowInputTextField = UITextField()
        self._numOfRowInputTextField.layer.borderWidth = 2
        self._numOfRowInputTextField.layer.borderColor = UIColor.black.cgColor
        self._numOfRowInputTextField.keyboardType = .numberPad
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self._numOfRowInputTextField.frame.height))
        self._numOfRowInputTextField.leftView = paddingView
        self._numOfRowInputTextField.leftViewMode = UITextFieldViewMode.always
        
        self._generateMatrixButton = UIButton()
        self._generateMatrixButton.layer.borderColor = UIColor.blue.cgColor
        self._generateMatrixButton.layer.borderWidth = 2
        self._generateMatrixButton.layer.cornerRadius = 8
        self._generateMatrixButton.setTitle("Generate", for: UIControlState.normal)
        self._generateMatrixButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self._generateMatrixButton.backgroundColor = UIColor.blue
        self._generateMatrixButton.addTarget(self, action: #selector(didTapGenerateMatrixButton), for: UIControlEvents.touchUpInside)
        
        self._matrixTextView = UITextView()
        self._matrixTextView.backgroundColor = UIColor.lightGray
        self._matrixTextView.isUserInteractionEnabled = false
        
        self.view.addSubview(self._matrixTextView)
        self.view.addSubview(self._generateMatrixButton)
        self.view.addSubview(self._numOfRowInputTextField)
        self.view.addSubview(self._decriptionInputNLabel)
    }
    
    private func setupLayout() {
        self._decriptionInputNLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        self._numOfRowInputTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(self._decriptionInputNLabel.snp.bottom).offset(10)
            make.leading.equalTo(self._decriptionInputNLabel)
            make.trailing.equalTo(self._generateMatrixButton.snp.leading).offset(-10)
            make.height.equalTo(50)
        }
        
        self._generateMatrixButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self._numOfRowInputTextField)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(self._numOfRowInputTextField)
        }
        
        self._matrixTextView.snp.remakeConstraints { (make) in
            make.top.equalTo(self._generateMatrixButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapGenerateMatrixButton() {
        self._numOfRowInputTextField.resignFirstResponder()
        self._matrixTextView.resignFirstResponder()
        
        if let numberString = self._numOfRowInputTextField.text, let number = Int(numberString) {
            self._matrix = generateMatrix(n: number)
            
            var outputString = "Generated matrix:\n"
            let generatedMatrixString = self.getMatrixIntring(self._matrix)
            outputString.append(generatedMatrixString)
            
            outputString.append("\n")
            outputString.append("\n")
            outputString.append("\n")
            outputString.append("Rotated matrix:\n")
            
            self.rotateMatrix(matrix: &self._matrix)
            
            let rotatedMatrix = self.getMatrixIntring(self._matrix)
            outputString.append(rotatedMatrix)
            self._matrixTextView.text = outputString
        }
    }
    
    private func generateMatrix(n: Int) -> [[Int]] {
        var matrix = [[Int]]()
        for _ in 0..<n {
            var subArr = [Int]()
            
            for _ in 0..<n {
                let now = Date()
                let second = UInt32(Calendar.current.component(.second, from: now))
                let randomNumber = Int(arc4random_uniform(second))
                subArr.append(randomNumber)
            }
            
            matrix.append(subArr)
        }
        
        return matrix
    }
    
    private func rotateMatrix(matrix: inout [[Int]]) {
        
        let r = matrix.count - 1
        
        for i in 0...(((r + 1) / 2)) - 1
        {
            for j in i...(r - i) - 1 {
                let temp = matrix[i][j]
                //                matrix[i][j] = matrix[j][r-i]
                //                matrix[j][r-i] = matrix[r-i][r-j]
                //                matrix[r-i][r-j] = matrix[r-j][i]
                //                matrix[r-j][i] = temp
                
                
                matrix[i][j] = matrix[r-j][i]
                matrix[r-j][i] = matrix[r-i][r-j]
                matrix[r-i][r-j] = matrix[j][r-i]
                matrix[j][r-i] = temp
            }
        }
    }
    
    private func printMatrixInConsole(_ matrix: [[Int]]) {
        print(self.getMatrixIntring(matrix))
    }
    
    private func getMatrixIntring(_ matrix: [[Int]]) -> String {
        var matrixString = ""
        let number = matrix.count
        for i in 0..<number {
            for j in 0..<number {
                let num = matrix[i][j]
                if num > 9 {
                    matrixString.append(" \(num) ")
                } else {
                    matrixString.append("  \(num)  ")
                }
            }
            matrixString.append("\n")
        }
        
        return matrixString
    }
}

