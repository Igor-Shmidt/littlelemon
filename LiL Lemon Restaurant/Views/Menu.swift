import SwiftUI
import Combine

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var categories: [String] = []

    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)])
    private var dishes: FetchedResults<Dish>
    var body: some View {
        NavigationView {
            VStack {
                MastHead(categories: Array(categories.dropFirst()))
                    .padding(.top, -40)

                Group {
                    TextField("Search menu", text: $searchText)
                        .onChange(of: searchText) { _ in
                            dishes.nsPredicate = buildPredicate()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(16)

                    Picker("Order for Delivery", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.capitalized)
                                .tag(category != "menu" ? category : nil)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedCategory) { _ in
                        dishes.nsPredicate = buildPredicate()
                    }

                    List {
                        ForEach(dishes, id: \.self) { dish in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(dish.title ?? "")
                                        .font(.headline)
                                    Text(dish.text ?? "")
                                    Text(dish.formatPrice())
                                        .font(.subheadline)

                                }
                                Spacer()
                                AsyncImage(url: dish.image) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 70, maxHeight: 70)
                                    default:
                                        Image(systemName: "photo")
                                    }
                                }
                                .frame(width: 70, height: 70)
                                .scaledToFit()
                                .padding()

                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppHeader()
                }
            }
            .task {
                await getMenuData()
                getCategories()
            }
        }
        .tabItem {
            Label("Menu", systemImage: "list.dash")
        }
    }

    private func getCategories() {
        guard !dishes.isEmpty else {
            categories = []
            return
        }
        categories = dishes.reduce(into: ["menu"]) { partialResult, dish in
            guard let category = dish.category, !category.isEmpty,
                  !partialResult.contains(category)
            else { return }
            partialResult.append(category)
        }
    }

    private func buildPredicate() -> NSPredicate? {
        var sub = [NSPredicate]()
        if !searchText.isEmpty {
            sub.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        if let selectedCategory, !selectedCategory.isEmpty {
            sub.append(NSPredicate(format: "category == %@", selectedCategory))
        }
        return switch sub.count {
        case 0: nil as NSPredicate?
        case 1: sub[sub.startIndex]
        default: NSCompoundPredicate(type: .and, subpredicates: sub)
        }
    }

    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }

    private let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!

    private func getMenuData() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let menuList = try JSONDecoder().decode(MenuList.self, from: data)
            try await Dish.updateDishes(from: menuList.menu, viewContext)
        }
        catch {
            print(error)
        }
    }
}


#Preview {
    let persistence = PersistenceController()
    TabView {
        Menu()
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
