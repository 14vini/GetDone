//
//  noItems.swift
//  GetDone
//
//  Created by Vinicius on 5/2/25.
//

import SwiftUI

struct NoItemsView: View {
    
    @State var animate: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("no items...")
                    .foregroundColor(colorScheme == .dark ? .white : .black )
                        .opacity(0.7)
                        .padding(.bottom, 15)
                
                NavigationLink(
                    destination: AddView(),
                    label: {
                        Text("Add Something ")
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.cyan.opacity(0.5)
                                    .background(.ultraThinMaterial)
                                    .blur(radius: 2)
                                    )
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.primary.opacity(0.5), lineWidth: 1)
                                    .blur(radius: 0.5)
                            )


                    })
                    .padding(.horizontal, animate ? 15 : 30)
                    .shadow(
                        color: animate ? Color.clear.opacity(0.7) : Color.cyan.opacity(0.7),
                        radius: animate ? 30 : 10,
                        x: 0,
                        y: animate ? 50 : 25)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .offset(y: animate ? -7 : 0)
            }
            .frame(maxWidth: 200)
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
    
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoItemsView()
                .navigationTitle("Title")
        }
    }
}
