//
//  NoteView.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI

struct NoteView: View {
    
    let note: Note
    let onComplete: () -> Void
    
    private let maxDrag = 200.0
    
    @State private var currentDragOffsetX: CGFloat = 0
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {

        HStack {
            Rectangle()
                .frame(width: 10, height: 80)
                .foregroundColor(.init(rgb: note.bgColor))
            VStack (alignment: .leading) {
                Text(note.title)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                Text(format(date: note.date))
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .bold()
            }
            Spacer()
        }
        .padding(.leading, 0)
        .padding(.trailing, 16)
        .background(
            Color(rgb: note.bgColor)
                .opacity(0.5)
        )
        .offset(x: currentDragOffsetX)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    if (value.translation.width < -30) {
                        return
                    }
                    
                    withAnimation(.spring) {
                        currentDragOffsetX = value.translation.width
                    }
                    
                    if (value.translation.width > maxDrag) {
                        viewModel.noteToDelete = note
                        onComplete()
                        withAnimation(.default.delay(3)) {
                            currentDragOffsetX = 0
                        }
                    }
                })
                .onEnded({ value in
                    withAnimation(.spring) {
                        currentDragOffsetX = 0
                    }
                })
        )
    }
    
    private func format(date: Date) -> String {
        let now = Date.now
        if Calendar.current.isDateInToday(date) {
            return date.formatted(.dateTime.hour().minute())
        } else if Calendar.current.isDate(now, equalTo: date, toGranularity: .year) {
            return date.formatted(.dateTime.day().month())
        }
        return date.formatted(.dateTime.day().month().year())
    }
}

#Preview {
    NoteView(note: Note(title: "this is a note"), onComplete: { print("delete item")})
}

