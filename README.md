#  Slider2D

A simple two-dimensional slider with magnetic snap points at various
strategic locations.

- Drag the handle around; it will stick to the snap points when close
- Control-drag to ignore the snap points and just move smoothly
- Click on the canvas to position the handle at the mouse position
- Double-click on the canvas to set the handle back to zero

## Usage

```
Slider2DView(
    canvasColor: Color = .green,
    cornerRadius: CGFloat = 15,
    handleColor: Color = .purple,
    size: CGSize = CGSize(width: 400, height: 400),
    snapTolerance: CGFloat = 20
    title: String
)
```

![](https://github.com/SaganRitual/Slider2D/blob/main/demo.gif)
