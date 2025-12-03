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
        anchors.margins: AppTheme.spacing4
        spacing: AppTheme.spacing5

        // Create playlist section with modern styling
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: AppTheme.radiusLarge
            color: AppTheme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: AppTheme.spacing3
                spacing: AppTheme.spacing3
                
                Rectangle {
                    Layout.preferredWidth: parent.width - createButton.width - AppTheme.spacing3
                    Layout.fillHeight: true
                    radius: AppTheme.radiusMedium
                    color: AppTheme.surfaceElevated
                    
                    TextField {
                        id: newPlaylistName
                        anchors.fill: parent
                        anchors.margins: AppTheme.spacing2
                        placeholderText: "New Playlist Name"
                        font.pixelSize: AppTheme.fontSizeBody
                        color: AppTheme.textPrimary
                        background: Rectangle { color: "transparent" }
                    }
                }
                
                Rectangle {
                    id: createButton
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    radius: AppTheme.radiusMedium
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: AppTheme.primary }
                        GradientStop { position: 1.0; color: AppTheme.primaryHover }
                    }
                    
                    Behavior on opacity {
                        NumberAnimation { duration: AppTheme.durationFast }
                    }
                    
                    opacity: createMouseArea.containsMouse ? 0.9 : 1.0
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Create"
                        font.pixelSize: AppTheme.fontSizeBody
                        font.bold: true
                        color: AppTheme.background
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
            font.pixelSize: AppTheme.fontSizeXLarge
            font.bold: true
            color: AppTheme.textPrimary
        }

        // Playlist cards in vertical list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: AppTheme.spacing3

            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                radius: AppTheme.radiusMedium
                
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
                    NumberAnimation { duration: AppTheme.durationFast }
                }
                
                scale: playlistMouseArea.pressed ? 0.98 : (playlistMouseArea.containsMouse ? 1.02 : 1.0)

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: AppTheme.spacing4
                    spacing: AppTheme.spacing4
                    
                    // Playlist icon with gradient
                    Rectangle {
                        width: 56
                        height: 56
                        radius: AppTheme.radiusMedium
                        gradient: Gradient {
                            GradientStop { 
                                position: 0.0; 
                                color: index % 2 === 0 ? "#6b46c1" : AppTheme.primary
                            }
                            GradientStop { 
                                position: 1.0; 
                                color: index % 2 === 0 ? "#e94560" : AppTheme.primaryHover
                            }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "♫"
                            color: AppTheme.textPrimary
                            font.pixelSize: AppTheme.fontSizeLarge
                        }
                    }

                    // Playlist info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AppTheme.spacing1
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: AppTheme.fontSizeMedium
                            font.bold: true
                            color: AppTheme.textPrimary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        
                        Text {
                            text: modelData.songCount !== undefined 
                                  ? `Playlist • ${modelData.songCount} songs`
                                  : "Playlist"
                            font.pixelSize: AppTheme.fontSizeSmall
                            color: AppTheme.textSecondary
                        }
                    }
                    
                    // Play button
                    Rectangle {
                        width: AppTheme.minTouchTarget
                        height: AppTheme.minTouchTarget
                        radius: width / 2
                        color: AppTheme.primary
                        opacity: playlistMouseArea.containsMouse ? 1 : 0
                        scale: playlistMouseArea.containsMouse ? 1 : 0.8
                        
                        Behavior on opacity {
                            NumberAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Behavior on scale {
                            NumberAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            font.pixelSize: AppTheme.fontSizeMedium
                            color: AppTheme.background
                        }
                    }
                }
                
                MouseArea {
                    id: playlistMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        window.stackView.push("qrc:/qt/qml/MusicManager/qml/PlaylistDetail.qml", {
                            "playlistId": modelData.id,
                            "playlistTitle": modelData.title
                        })
                    }
                }
            }
        }
    }
}
