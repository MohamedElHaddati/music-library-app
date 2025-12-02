import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

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
        anchors.margins: 20
        spacing: 15

        RowLayout {
            spacing: 10
            
            TextField {
                id: newPlaylistName
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                placeholderText: "New Playlist Name"
                font.pixelSize: 14
                
                background: Rectangle {
                    radius: 8
                    color: "#333333"
                    border.color: newPlaylistName.activeFocus ? "#00BCD4" : "#444444"
                    border.width: 2
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }
                
                color: "white"
            }
            
            Button {
                id: createPlaylistButton
                text: "+ Create"
                font.pixelSize: 14
                font.bold: true
                
                background: Rectangle {
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00BCD4" }
                        GradientStop { position: 1.0; color: "#0097A7" }
                    }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#6000BCD4"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 2
                        shadowBlur: 0.4
                    }
                }
                
                contentItem: Text {
                    text: createPlaylistButton.text
                    font: createPlaylistButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (newPlaylistName.text !== "") {
                        musicController.createPlaylist(newPlaylistName.text)
                        newPlaylistName.text = ""
                    }
                }
            }
        }
        
        Label {
            text: listView.count + " playlist" + (listView.count !== 1 ? "s" : "")
            font.pixelSize: 14
            color: "#888888"
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: 10

            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                color: playlistMouseArea.containsMouse ? "#2D2D2D" : "#252525"
                radius: 10
                
                border.color: playlistMouseArea.containsMouse ? "#00BCD4" : "transparent"
                border.width: 1
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#30000000"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 2
                    shadowBlur: 0.3
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 10
                        
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#00BCD4" }
                            GradientStop { position: 0.5; color: "#0097A7" }
                            GradientStop { position: 1.0; color: "#00838F" }
                        }
                        
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowColor: "#4000BCD4"
                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 2
                            shadowBlur: 0.3
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "☰"
                            color: "white"
                            font.pixelSize: 24
                            font.bold: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: 16
                            font.bold: true
                            color: "white"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "Playlist"
                            font.pixelSize: 12
                            color: "#888888"
                        }
                    }
                    
                    Text {
                        text: "▶"
                        font.pixelSize: 20
                        color: playlistMouseArea.containsMouse ? "#00BCD4" : "#666666"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
                
                MouseArea {
                    id: playlistMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
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
