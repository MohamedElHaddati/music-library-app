import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var model: musicController.getAlbums()

    Connections {
        target: musicController
        function onAlbumsChanged() {
            root.model = musicController.getAlbums()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        
        Button {
            text: "Create Album"
            Layout.margins: 10
            onClicked: createAlbumDialog.open()
        }

        GridView {
            id: gridView
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 160
            cellHeight: 200
            model: root.model
            clip: true

            delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 5
                color: "#e0e0e0"
                radius: 5
                border.color: "#cccccc"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 100
                        height: 100
                        color: "#999999"
                        radius: 2
                        
                        Text {
                            anchors.centerIn: parent
                            text: "CD"
                            color: "white"
                            font.pixelSize: 24
                        }
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: modelData.title
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackView.push("qrc:/qt/qml/MusicManager/qml/AlbumDetail.qml", {
                            "albumId": modelData.id,
                            "albumTitle": modelData.title
                        })
                    }
                }
            }
        }
    }
    
    Dialog {
        id: createAlbumDialog
        title: "Create Album"
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        
        ColumnLayout {
            TextField {
                id: albumTitleField
                placeholderText: "Album Title"
            }
        }
        
        onAccepted: {
            if (albumTitleField.text !== "") {
                musicController.createAlbum(albumTitleField.text)
                albumTitleField.text = ""
            }
        }
    }
    }
}

