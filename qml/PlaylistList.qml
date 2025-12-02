import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MusicManager

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
        anchors.margins: Theme.spacing4
        spacing: Theme.spacing5

        // Create playlist section with modern styling
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: Theme.radiusLarge
            color: Theme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing3
                spacing: Theme.spacing3
                
                Rectangle {
                    Layout.preferredWidth: parent.width - createButton.width - Theme.spacing3
                    Layout.fillHeight: true
                    radius: Theme.radiusMedium
                    color: Theme.surfaceElevated
                    
                    TextField {
                        id: newPlaylistName
                        anchors.fill: parent
                        anchors.margins: Theme.spacing2
                        placeholderText: "New Playlist Name"
                        font.pixelSize: Theme.fontSizeBody
                        color: Theme.textPrimary
                        background: Rectangle { color: "transparent" }
                    }
                }
                
                Rectangle {
                    id: createButton
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    radius: Theme.radiusMedium
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.primary }
                        GradientStop { position: 1.0; color: Theme.primaryHover }
                    }
                    
                    Behavior on opacity {
                        NumberAnimation { duration: Theme.durationFast }
                    }
                    
                    opacity: createMouseArea.containsMouse ? 0.9 : 1.0
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Create"
                        font.pixelSize: Theme.fontSizeBody
                        font.bold: true
                        color: Theme.background
                    }
                    
                    MouseArea {
                        id: createMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (newPlaylistName.text !== "") {
                                musicController.createPlaylist(newPlaylistName.text)
                                newPlaylistName.text = ""
                            }
                        }
                    }
                }
            }
        }

        // Featured playlists section header
        Text {
            text: "Your Playlists"
            font.pixelSize: Theme.fontSizeXLarge
            font.bold: true
            color: Theme.textPrimary
        }

        // Playlist cards in vertical list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: Theme.spacing3

            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                radius: Theme.radiusMedium
                
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { 
                        position: 0.0
                        color: Qt.rgba(
                            0.2 + (index % 3) * 0.2, 
                            0.3 + (index % 2) * 0.2, 
                            0.5 + (index % 4) * 0.15, 
                            0.3
                        )
                    }
                    GradientStop { 
                        position: 1.0
                        color: "transparent"
                    }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: Theme.durationFast }
                }
                
                scale: playlistMouseArea.pressed ? 0.98 : (playlistMouseArea.containsMouse ? 1.02 : 1.0)

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing4
                    spacing: Theme.spacing4
                    
                    // Playlist icon with gradient
                    Rectangle {
                        width: 56
                        height: 56
                        radius: Theme.radiusMedium
                        gradient: Gradient {
                            GradientStop { 
                                position: 0.0; 
                                color: index % 2 === 0 ? "#6b46c1" : Theme.primary
                            }
                            GradientStop { 
                                position: 1.0; 
                                color: index % 2 === 0 ? "#e94560" : Theme.primaryHover
                            }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "♫"
                            color: Theme.textPrimary
                            font.pixelSize: Theme.fontSizeLarge
                        }
                    }

                    // Playlist info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing1
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: Theme.fontSizeMedium
                            font.bold: true
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        
                        Text {
                            text: "Playlist • " + (modelData.songCount || 0) + " songs"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textSecondary
                        }
                    }
                    
                    // Play button
                    Rectangle {
                        width: Theme.minTouchTarget
                        height: Theme.minTouchTarget
                        radius: width / 2
                        color: Theme.primary
                        opacity: playlistMouseArea.containsMouse ? 1 : 0
                        scale: playlistMouseArea.containsMouse ? 1 : 0.8
                        
                        Behavior on opacity {
                            NumberAnimation { duration: Theme.durationFast }
                        }
                        
                        Behavior on scale {
                            NumberAnimation { duration: Theme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.background
                        }
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
