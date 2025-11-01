//
//  ContentView.swift
//  BubbleSort
//
//  Created by Purnaman Rai (College) on 29/10/2025.
//

import SwiftUI

struct ColoredNumber: View, Identifiable {
    let id = UUID()
    let number: Int
    
    var body: some View {
        Text("\(number)")
            .frame(width: 20, height: 20)
            .padding(10)
            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
            .foregroundStyle(.black)
            .clipShape(.rect(cornerRadius: 15))
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
    }
}

struct ContentView: View {
    @State private var numbersToSort = [Int]()
    @State private var sortingState = ""
    @State private var playEffect = false
    @State private var allNumbersSorted = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "gearshape.fill")
                    .imageScale(.large)
                    .symbolEffect(.wiggle, value: playEffect)
                    .onTapGesture {
                        playEffect.toggle() // triggers the animation once
                    }
            }
            
            Text(sortingState)
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 170, height: 50)
                .contentTransition(.numericText())
                .animation(.default, value: sortingState)
            
            HStack {
                ForEach(numbersToSort, id: \.self) { number in
                    ColoredNumber(number: number)
                }
                .animation(.bouncy, value: numbersToSort)
                
                if sortingState != "Sorting..." {
                    Button {
                        print("Plus")
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 20, height: 20)
                            .padding(10)
                            .background(.red)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                    .animation(.bouncy, value: sortingState)
                    .transition(.scale)
                }
                
                if numbersToSort.isEmpty {
                    Button {
                        withAnimation {
                            numbersToSort = [7, 2, 9, 1, 8, 3, 5, 4, 6]
                        }
                    } label: {
                        Text("Add Samples")
                            .frame(width: 86, height: 20)
                            .padding(10)
                            .background(.secondary.opacity(0.2))
                            .foregroundStyle(.gray)
                            .clipShape(.rect(cornerRadius: 15))
                            .font(.system(size: 12, design: .monospaced))
                    }
                    .transition(.blurReplace)
                }
            }
            
            HStack {
                if sortingState != "Sorting..." && !numbersToSort.isEmpty {
                    Button("Sort") {
                        if numbersToSort.count > 1 {
                            Task {
                                withAnimation {
                                    sortingState = "Sorting..."
                                    allNumbersSorted = false
                                }
                                
                                while !allNumbersSorted {
                                    var sortedCount = 0
                                    
                                    for i in 0..<numbersToSort.count - 1 {
                                        if numbersToSort[i] < numbersToSort[i + 1] {
                                            sortedCount += 1
                                            continue
                                        } else {
                                            let temp = numbersToSort[i]
                                            withAnimation {
                                                numbersToSort[i] = numbersToSort[i + 1]
                                                numbersToSort[i + 1] = temp
                                            }
                                            
                                            try? await Task.sleep(for: .seconds(0.5))
                                        }
                                    }
                                    
                                    if sortedCount == numbersToSort.count - 1 {
                                        withAnimation {
                                            sortingState = "Sorting Complete"
                                        }
                                        allNumbersSorted = true
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primary)
                    .transition(.blurReplace)
                    
                    Button("Shuffle") {
                        withAnimation {
                            sortingState = ""
                            numbersToSort.shuffle()
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    .transition(.blurReplace)
                }
                
                if !numbersToSort.isEmpty {
                    Button {
                        withAnimation {
                            if sortingState == "Sorting..." {
                                allNumbersSorted = true
                                sortingState = ""
                                return
                            }
                            sortingState = ""
                            numbersToSort.removeAll()
                        }
                    } label: {
                        Image(systemName: sortingState == "Sorting..." ? "xmark" : "trash.fill")
                            .imageScale(.small)
                            .frame(width: 10, height: 20)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .transition(.scale.combined(with: .blurReplace))
                }
            }
            .frame(width: 220, height: 35)
            .padding()
            .fontDesign(.monospaced)
        }
    }
}

#Preview {
    ContentView()
}
