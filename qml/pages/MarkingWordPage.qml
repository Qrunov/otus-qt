import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

BaseWordPage {
    id: markingWord
    anchors.fill: parent
    Column{
        anchors.fill: parent
        width: parent.width
        spacing: 20
        Label{
            id: en
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 3
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
            }
            //           anchors.centerIn: parent
        }
        TextField{
            id: rus
            placeholderText: "Введите перевод"
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 3
            horizontalAlignment: "AlignHCenter"
            anchors{
                left: parent.left
                right: parent.right
                top: en.bottom
            }
        }
        GridLayout{
            id: btns1
            columns: 2
            rowSpacing: 20
            columnSpacing: 20


            anchors{
                left: parent.left
                right: parent.right
                top: rus.bottom
                leftMargin: 20
                rightMargin: 10
                //                bottom: parent.bottom
            }

            Button{
                id: ignore
                text: qsTr("Игнорировать")
                onClicked: {
                    db.deleteWord(m_marking.get(0).id)
                    m_marking.remove(0);
                    loadNextPage(m_marking, m_learning);
                }
            }
            Button{
                id: skip
                text: qsTr("Пропустить")
                onClicked: {
                    m_marking.remove(0);
                    loadNextPage(m_marking, m_learning);
                }
            }

            Button{
                id: aware
                text: qsTr("Я знаю слово")
                onClicked: {
                    db.markWordKnown(m_marking.get(0).id)
                    m_marking.remove(0);
                    loadNextPage(m_marking, m_learning);
                }
            }
            Button{
                id: append
                text: qsTr("Добавить слово")
                enabled: rus.length > 0
                onClicked: {
                    var m = m_marking.get(0);
                    db.determineWord(m.id, rus.text)
                    m_learning.append({en: m.en, ru: rus.text})
                    m_marking.remove(0);
                    m_isLearning.isToggled = true;
                    loadNextPage(m_marking, m_learning);
                }
            }
        }

    }
    Component.onCompleted: {
        pageTitle = "Разметка слова"
        markingWord.markingClicked.connect(onMarkingButtonClicked);
        en.text = m_marking.get(0).en;
    }
    function onMarkingButtonClicked(){
        loadNextPage(m_marking, m_learning);
    }
}
