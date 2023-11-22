//
//  Order.swift
//  CupcakeCorner
//
//  Created by Noalino on 22/11/2023.
//

import Foundation

extension String {
    var isValid: Bool {
        return !self.isEmpty && !self.allSatisfy { $0 == " " }
    }
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false

    var name = "" {
        didSet {
            if let encoded = try? JSONEncoder().encode(name) {
                UserDefaults.standard.set(encoded, forKey: "name")
            }
        }
    }
    var streetAddress = "" {
        didSet {
            if let encoded = try? JSONEncoder().encode(streetAddress) {
                UserDefaults.standard.set(encoded, forKey: "streetAddress")
            }
        }
    }
    var city = "" {
        didSet {
            if let encoded = try? JSONEncoder().encode(city) {
                UserDefaults.standard.set(encoded, forKey: "city")
            }
        }
    }
    var zip = "" {
        didSet {
            if let encoded = try? JSONEncoder().encode(zip) {
                UserDefaults.standard.set(encoded, forKey: "zip")
            }
        }
    }

    var hasValidAddress: Bool {
        if !name.isValid || !streetAddress.isValid || !city.isValid || !zip.isValid {
            return false
        }

        return true
    }

    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // Complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }

    init() {
        if let savedName = UserDefaults.standard.data(forKey: "name") {
            if let decodedName = try? JSONDecoder().decode(String.self, from: savedName) {
                name = decodedName
            }
        }
        if let savedStreetAddress = UserDefaults.standard.data(forKey: "streetAddress") {
            if let decodedAddress = try? JSONDecoder().decode(String.self, from: savedStreetAddress) {
                streetAddress = decodedAddress
            }
        }
        if let savedCity = UserDefaults.standard.data(forKey: "city") {
            if let decodedCity = try? JSONDecoder().decode(String.self, from: savedCity) {
                city = decodedCity
            }
        }
        if let savedZip = UserDefaults.standard.data(forKey: "zip") {
            if let decodedZip = try? JSONDecoder().decode(String.self, from: savedZip) {
                zip = decodedZip
            }
        }
    }
}
