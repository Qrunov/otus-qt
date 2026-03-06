import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string note
    DialogHeader {
        acceptText: "Сохранить"
        cancelText: "Отменить"
    }
    TextArea {
        id: noteArea
        anchors.centerIn: parent
        placeholderText: "Текст заметки"
        label: "Текст заметки"
        text: note
    }
    onAccepted: note = noteArea.text
}
