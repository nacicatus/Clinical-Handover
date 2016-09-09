//
//  PatientModel.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import Foundation

class PatientModel: NSObject {
    // properties
    var patientName: String?
    var dateOfBirth: NSDate?
    var unitNumber: String?
    var gender: String?
    var ward: String?
    var bedNumber: Int?
    var consultant: ConsultantModel?
    var code: String?
    var category: String?
    var admissionDate: NSDate?
    var diagnosis: String?
    var allergies: String?
    var notes: String?
    var nurses: String?
    var socialServices: String?
    var team: String?
    var wardRoundNotes: String?

    override init() {
        
    }
    
    init(patientName: String,
        dateOfBirth: NSDate,
        unitNumber: String,
        gender: String,
        ward: String,
        bedNumber: Int,
        consultant: ConsultantModel,
        code: String,
        category: String,
        admissionDate: NSDate,
        diagnosis: String,
        allergies: String,
        notes: String,
        nurses: String,
        socialServices: String,
        team: String,
        wardRoundNotes: String) {
            self.patientName = patientName
            self.dateOfBirth = dateOfBirth
            self.unitNumber = unitNumber
            self.gender = gender
            self.ward = ward
            self.bedNumber = bedNumber
            self.consultant = consultant
            self.code = code
            self.category = category
            self.admissionDate = admissionDate
            self.diagnosis = diagnosis
            self.allergies = allergies
            self.notes = notes
            self.nurses = nurses
            self.socialServices = socialServices
            self.team = team
            self.wardRoundNotes = wardRoundNotes
    }
}