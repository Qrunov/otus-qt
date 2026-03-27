import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import ".."

Page {
    id: mainPage
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    property string selectedFile

    PageHeader {
        id: pageHeader
        objectName: "pageHeader"
        title: qsTr("Тренажер английского языка")
    }

    StorageModel{
        id: itemModel
    }

    ListModel{
        id: unknown
    }

    ListModel{
        id: learning
    }

    function readFileContent(path){
        var file = new XMLHttpRequest();
        file.open("GET", path, false);
        file.send(null);

        if (file.status === 200){
            return file.responseText
        }
        else{
            console.error("Ошибка чтения файла:", path, " статус:", file.status)
            return null
        }
    }
    function splitOnWords(content){
        var words = content.split(/[,!\.\s]+/);
        return words;
    }

    function filterWords(words){
        var pattern = /^[a-z\-]+$/
        words = words.filter(function(word) {
            return word.length < 30
        }).map( function(word){
            return word.toLowerCase()
        }).filter(function(word){
            return pattern.test(word)
        })
        return words;
    }

    function computeWordsFrequency(words){
        var wd = {};
        for(var i = 0; i < words.length;i++){
            if (wd[words[i]]){
                wd[words[i]]++;
            }
            else
                wd[words[i]] = 1;
        }
        return wd;
    }

    function processFile(name){
        mainPage.selectedFile = name;
        var content = readFileContent(mainPage.selectedFile);
        if (content === null)
            return;
        var words = splitOnWords(content);
        words = filterWords(words);
        var wf = computeWordsFrequency(words);
        return wf
    }

    Component{
        id: filePickerPage
        FilePickerPage {
            onSelectedContentPropertiesChanged: {
                var dict = processFile(selectedContentProperties.filePath);
                itemModel.insertTopic(selectedContentProperties.fileName,dict);
                itemModel.fillModel();
            }
        }
    }

    SilicaListView {
        id: topicList
        anchors{
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: itemModel
        delegate: BackgroundItem {
            id: backgroundItem
            width: parent.width
            height: column.height + Theme.paddingLarge * 2
            Column {
                id: column
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                spacing: Theme.paddingSmall

                Label{
                    text: title
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: backgroundItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                }
                Row{
                    width: parent.width
                    spacing: Theme.paddingMedium
                    Column {
                        width: (parent.width - 3 * parent.spacing) / 4
                        Label {
                            text: "Слов"
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.bold: true
                            color: Theme.secondaryColor
                            width: parent.width
                        }
                        Label {
                            text: total
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.italic: true
                            color: Theme.secondaryColor
                            width: parent.width
                        }

                    }
                    Column {
                        width: (parent.width - 3 * parent.spacing) / 4
                        Label {
                            text: "Уникальных"
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.bold: true
                            color: Theme.secondaryColor
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            text: unq
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.italic: true
                            color: Theme.secondaryColor
                            width: parent.width
                        }
                    }
                    Column {
                        width: (parent.width - 3 * parent.spacing) / 4
                        Label {
                            text: "Изучено"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            text: known
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.italic: true
                            color: Theme.secondaryColor
                            width: parent.width
                        }
                    }
                    Column {
                        width: (parent.width - 3 * parent.spacing) / 4
                        Label {
                            text: "По объему"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            text: coverage
                            font.pixelSize: Theme.fontSizeExtraSmall
                            font.italic: true
                            color: Theme.secondaryColor
                            width: parent.width
                        }
                    }
                }
            }
            onClicked: {
                var component = Qt.createComponent("BaseWordPage.qml");
                if (Component.Ready === component.status){
                    var instance = component.createObject(this);
                    if (instance)
                    {
                        itemModel.getUnknownForTopic(index,unknown);
                        itemModel.getLeaningForTopic(index,learning);
                        instance.db = itemModel;
                        instance.outerIndex = index;
                        instance.loadNextPage(unknown,learning);
                    }
                }
                else
                    console.error("Ошибка формирования компонента:", component.errorString());
            }
        }
        footer: Button {
            icon.source: "image://theme/icon-m-add?"
            preferredWidth: Theme.buttonWidthTiny
            onClicked: {
                var file = pageStack.push(filePickerPage)

                //var dict = processFile("/usr/share/alsa/alsa.conf");
                // var dict = processFile(file);
                // itemModel.insertTopic("new",dict);
                // itemModel.fillModel();
            }

        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active){

            itemModel.fillModel();
        }
    }
}
