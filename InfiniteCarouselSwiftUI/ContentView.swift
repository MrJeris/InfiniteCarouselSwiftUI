import SwiftUI

struct ItemAds: Identifiable {
    var id: Int
    var color: Color
}

struct InfinityScrollTabView<Content: View, Item: Identifiable>: View {
    var items: [Item]
    var content: (Item) -> Content
    
    @State private var offset: CGFloat = 0.0
    @State private var draggingOffset: CGFloat = 0.0
    @State private var currentIndex: Int = 0
    
    //Parametrs
    var spacing: CGFloat = 8
    var width: CGFloat = 340
    var height: CGFloat = 230
    var animation: Animation = .smooth
    
    var body: some View {
        VStack {
            Text("Offset = \(offset)")
            Text("Current index = \(currentIndex)")
            Text("Dragging Offset = \(draggingOffset)")
            
            GeometryReader { geo in
                LazyHStack(spacing: spacing) {
                    //Last item fake
                    content(items[items.count-1])
                        .frame(width: width, height: height)
                    
                    ForEach(items) { item in
                        content(item)
                            .frame(width: width, height: height)
                    }
                    
                    //first item fake
                    content(items[0])
                        .frame(width: width, height: height)
                }
                .offset(x: draggingOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            handleDragGesture(translation: value.translation.width, geoWidth: geo.size.width)
                        }
                        .onEnded { _ in
                            handleDragEnd(geoWidth: geo.size.width)
                        }
                )
                //При открытии переключаем на текущий элемент
                .onAppear {
                    draggingOffset = offsetX(geo.size.width)
                }
            }
        }
    }
    
    func handleDragGesture(translation: CGFloat, geoWidth: CGFloat) {
        offset = translation
        draggingOffset = offsetX(geoWidth) + translation
    }
    
    func offsetX(_ geo: Double) -> CGFloat {
        let sizePartElement = Double((geo - width - spacing * 2) / 2)
        let elementSize = spacing + width
        let itemNumber = Double(currentIndex)
        
        return -(width - sizePartElement + elementSize * itemNumber)
    }
    
    func handleDragEnd(geoWidth: CGFloat) {
        //Переход на предыдущий элемент
        if offset > width / 2 {
            //Если это конец элементов в начале, то
            if currentIndex == 0 {
                //Переходим на фейковый последний элемент
                currentIndex = -1
                withAnimation(animation) {
                    draggingOffset = offsetX(geoWidth)
                }
                
                //И без анимации переходим на реальный последний элемент
                currentIndex = items.count - 1
                draggingOffset = offsetX(geoWidth)
            }
            
            //Переход на предыдущий элемент если он не последний
            else if currentIndex != -1 && currentIndex != 0 {
                currentIndex = currentIndex - 1
                withAnimation(animation) {
                    draggingOffset = offsetX(geoWidth)
                }
            }
        }
        
        //Переход на следующий элемент
        else if offset < -width / 2 {
            //Если мы выходим за пределы в конце, то
            if currentIndex == items.count - 1 {
                //Переходим на фейковый 1 элемент
                currentIndex = items.count
                withAnimation(animation) {
                    draggingOffset = offsetX(geoWidth)
                }
                
                //И без анимации переходим на реальный 1 элемент
                currentIndex = 0
                draggingOffset = offsetX(geoWidth)
            }
            
            //Переход на следующий элемент если он не последний
            else if currentIndex != items.count && currentIndex != items.count - 1 {
                currentIndex = currentIndex + 1
                withAnimation(animation) {
                    draggingOffset = offsetX(geoWidth)
                }
            }
        }
        //Если мы остаёмся на том же елементе
        else {
            withAnimation(animation) {
                draggingOffset = offsetX(geoWidth)
            }
        }
    }
}

struct Element: View {
    let color: Color
    let id: Int
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                //Image
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
                
                HStack {
                    Text("Реклама")
                    
                    Image(systemName: "info.circle")
                }
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                //.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(10)
            }
            
            Text("Элемент \(id)")
                .font(.largeTitle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let items = [
        ItemAds(id: 0, color: .blue),
        ItemAds(id: 1, color: .gray),
        ItemAds(id: 2, color: .orange),
        ItemAds(id: 3, color: .red),
        ItemAds(id: 4, color: .yellow),
        ItemAds(id: 5, color: .pink),
    ]
    
    static var previews: some View {
        InfinityScrollTabView(items: items) { item in
            Element(color: item.color, id: item.id)
        }
    }
}
