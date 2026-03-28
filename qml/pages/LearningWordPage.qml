import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1


BaseWordPage {
    id: learningWord
    anchors.fill: parent
    Column{
        anchors.fill: parent
        Label{
            id: en
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 4
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }
        IconButton{
            id: reveal
            icon.source: "image://theme/icon-l-down"

            onClicked:{
                ru.text = m_learning.get(0).ru
            }
            anchors{
                left: parent.left
                right: parent.right
                top: en.bottom
            }
        }

        Label{
            id: ru
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 4
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"

            anchors{
                left: parent.left
                right: parent.right
                top: reveal.bottom
            }
        }
        GridLayout {
            id: btns1
            columns: 2
            rowSpacing: 20
            columnSpacing: 20

            anchors {
                left: parent.left
                right: parent.right
                top: ru.bottom
                bottom: parent.bottom
                leftMargin: 20
                rightMargin: 20
            }
            Button {
                id: fail
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight

                Label {
                    text: qsTr("Я не вспомнил слово")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    anchors.centerIn: parent
                }
                onClicked: {
                    db.progressDown(m_learning.get(0).id)
                    m_learning.remove(0)
                    loadNextPage(m_marking, m_learning)
                }
            }

            Button {
                id: success
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight
                Label {
                    text: qsTr("Я вспомнил слово")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    anchors.centerIn: parent
                }

                onClicked: {
                    db.progressUp(m_learning.get(0).id)
                    m_learning.remove(0)
                    loadNextPage(m_marking, m_learning)
                }
            }
        }
    }

    Component.onCompleted: {
        pageTitle = "Запоминание слова"
        learningWord.learningClicked.connect(onLearningButtonClicked)
        en.text = m_learning.get(0).en
    }


    function onLearningButtonClicked() {
        console.log("onLearningButtonClick");
        loadNextPage(m_marking, m_learning);
    }

}
