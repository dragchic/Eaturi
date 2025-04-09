//
//  SplashScreenView.swift
//  eaturi
//
//  Created by Flavia Angelina Witarsah on 09/04/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("colorSecondary"), location: 0.5),
                    .init(color: Color("colorPrimary"),  location: 1.5)
                ]),
                startPoint: .topTrailing,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack{
                VStack{
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundColor(.colorOren)
                    Text("Eaturi")
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
