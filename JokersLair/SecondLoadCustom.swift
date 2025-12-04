import Foundation
import SwiftUI

struct SecondLoadCustom: View {
    @State private var rotation: Double = 0
    @State private var dotsAnimation = 0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.white, .gray.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false)
                        ) {
                            rotation = 360
                        }
                    }
                
                HStack(spacing: 0) {
                    Text("Loading")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(String(repeating: ".", count: (dotsAnimation % 4) + 1))
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 40, alignment: .leading)
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dotsAnimation += 1
                        }
                    }
                }
            }
        }
    }
}
