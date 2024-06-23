// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @State private var viewSize = CGSize(width: 100, height: 100)

    let virtualSize = CGSize(width: 500, height: 500)

    var body: some View {
        Slider2DView(size: viewSize, title: "Slider 2D", virtualSize: virtualSize)
            .frame(width: 400, height: 400)
            .background {
                GeometryReader { gr in
                    Path { _ in
                        DispatchQueue.main.async {
                            self.viewSize = gr.size
                        }
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
