import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var model: musicController.getPlaylists()

    Connections {
        target: musicController
        function onPlaylistsChanged() {
            root.model = musicController.getPlaylists()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            TextField {
                id: newPlaylistName
                placeholderText: "New Playlist Name"
                Layout.fillWidth: true
            }
            Button {
                text: "Create"
                onClicked: {
                    if (newPlaylistName.text !== "") {
                        musicController.createPlaylist(newPlaylistName.text)
                        newPlaylistName.text = ""
                    }
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: 5

            delegate: Rectangle {
                width: ListView.view.width
                height: 50
                color: "#f5f5f5"
                radius: 5
                border.color: "#dddddd"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Rectangle {
                        width: 30
                        height: 30
                        color: "#666"
                        radius: 15
                        Text {
                            anchors.centerIn: parent
                            text: "P"
                            color: "white"
                        }
                    }

                    Text {
                        text: modelData.title
                        font.pixelSize: 16
                        Layout.fillWidth: true
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackView.push("qrc:/qt/qml/MusicManager/qml/PlaylistDetail.qml", {
                            "playlistId": modelData.id,
                            "playlistTitle": modelData.title
                        })
                    }
                }
            }
        }
    }
}
