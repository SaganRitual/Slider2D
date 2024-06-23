// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct Slider2DView: View {
    let canvasColor: Color
    let cornerRadius: CGFloat
    let handleColor: Color
    let scale: CGVector
    let size: CGSize
    let snapTolerance: CGFloat
    let title: String

    private let magnets = Magnets()

    @GestureState private var dragOffset: CGSize = .zero
    @State private var dotPosition: CGPoint = .zero
    @State private var snapped = false

    init(
        canvasColor: Color = Color(NSColor.secondarySystemFill),
        cornerRadius: CGFloat = 15,
        handleColor: Color = .gray,
        size: CGSize = CGSize(width: 400, height: 400),
        snapTolerance: CGFloat = 20,
        title: String,
        virtualSize: CGSize? = nil
    ) {
        self.canvasColor = canvasColor
        self.cornerRadius = cornerRadius
        self.handleColor = handleColor
        self.size = size
        self.snapTolerance = snapTolerance
        self.title = title
        self.scale = virtualSize.map { CGVector(dx: $0.width / size.width, dy: $0.height / size.height) } ?? .init(dx: 1, dy: 1)
    }

    private var handleOffset: CGPoint {
        let intendedPosition = CGPoint(dragOffset + dotPosition)
        let magnet = magnets.closest(to: intendedPosition, inSpace: size)
        let snap = magnet.distance(to: intendedPosition) < snapTolerance
        let rawResult = snap ? magnet : intendedPosition

        return rawResult.constrained(to: self.size)
    }

    private var scaledOutput: CGPoint {
        let p = handleOffset + dotPosition
        return CGPoint(x: p.x * scale.dx, y: p.y * scale.dy)
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(title)

            ZStack {
                Rectangle()
                    .frame(width: 2, height: size.height)
                    .foregroundColor(.black)

                Rectangle()
                    .frame(width: size.width, height: 2)
                    .foregroundColor(.black)

                ZStack {
                    Rectangle()
                        .fill(canvasColor)
                        .frame(width: size.width, height: size.height)
                        .zIndex(0)

                    Circle()
                        .fill(handleColor)
                        .stroke(snapped ? Color.green : Color.gray, lineWidth: 2)
                        .frame(width: max(10, size.width / 10), height: max(10, size.height / 10))
                        .offset(CGSize(handleOffset))
                        .zIndex(1)
                }
                .gesture(
                    DragGesture(coordinateSpace: .local)
                        .updating($dragOffset) { value, state, transaction in
                            state = value.translation
                        }
                        .onEnded { value in
                            dotPosition += value.translation
                            dotPosition = handleOffset
                        }
                )
                .coordinateSpace(name: "sliderCanvas")
            }
            .mask( // Apply a mask to hide the overlapping border
                Rectangle()
                    .frame(width: size.width, height: size.height)
            )
            .border(Color.black, width: 2)

            Text("\(scaledOutput)")
        }
        .onChange(of: handleOffset) { (_, _) in
            let intendedPosition = CGPoint(dragOffset + dotPosition)
            let magnet = magnets.closest(to: intendedPosition, inSpace: size)
            snapped = magnet.distance(to: intendedPosition) < snapTolerance
        }
    }
}

private extension Slider2DView {

    struct Magnets {
        let stops: [CGPoint]

        init() {
            var stops = [CGPoint]()

            stride(from: -1.0, through: 1.0, by: 0.5).forEach { x in
                stride(from: -1.0, through: 1.0, by: 0.5).forEach { y in
                    stops.append(CGPoint(x: x, y: y))
                }
            }

            self.stops = stops
        }

        func closest(to position: CGPoint, inSpace: CGSize) -> CGPoint {
            let distances = stops.map {
                let p = CGPoint(x: $0.x * inSpace.width / 2, y: $0.y * inSpace.height / 2)
                return p.distance(to: position)
            }

            var ixOfMinimum = -1
            var minimumDistance = CGFloat.greatestFiniteMagnitude
            for ix in 0..<distances.count {
                if distances[ix] < minimumDistance {
                    ixOfMinimum = ix
                    minimumDistance = distances[ix]
                }
            }

            let magnet = CGPoint(
                x: stops[ixOfMinimum].x * inSpace.width / 2,
                y: stops[ixOfMinimum].y * inSpace.height / 2
            )

            return magnet
        }
    }

}

#Preview {
    Slider2DView(title: "Slider 2D")
}
