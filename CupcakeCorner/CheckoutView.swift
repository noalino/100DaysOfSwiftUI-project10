//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Noalino on 22/11/2023.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order

    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(confirmationTitle, isPresented: $showingConfirmation) {
            // Default OK button
        } message: {
            Text(confirmationMessage)
        }
    }

    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on the way!"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            confirmationTitle = "Oops, something went wrong."
            confirmationMessage = "Could not proceed with your order. Please retry."
            showingConfirmation = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
