import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MusicManager

Page {
    id: root
    property int playlistId: -1
    property string playlistTitle: ""
    
    background: Rectangle {
        color: Theme.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Hero header with playlist art and gradient overlay
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#6b46c1" }
                GradientStop { position: 1.0; color: Theme.background }
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing6
                spacing: Theme.spacing6
                
                // Large playlist artwork
                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    radius: Theme.radiusLarge
                    
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#e94560" }
                        GradientStop { position: 1.0; color: "#6b46c1" }
                    }
                    
                    // Shadow effect
                    layer.enabled: true
                    layer.effect: Item {
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -Theme.spacing3
                            radius: Theme.radiusLarge
                            color: "black"
                            opacity: Theme.shadowOpacityLarge
                            z: -1
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "♫"
                        font.pixelSize: Theme.fontSizeXXXLarge + 24
                        color: Theme.textPrimary
                    }
                }
                
                // Playlist info
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.spacing3
                    
                    Item { Layout.fillHeight: true }
                    
                    Text {
                        text: "PLAYLIST"
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        color: Theme.textPrimary
                        opacity: 0.7
                    }
                    
                    Text {
                        text: root.playlistTitle
                        font.pixelSize: Theme.fontSizeXXXLarge
                        font.bold: true
                        color: Theme.textPrimary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    
                    RowLayout {
                        spacing: Theme.spacing2
                        
                        Text {
                            text: musicController.getPlaylistSongs(root.playlistId).length + " songs"
                            font.pixelSize: Theme.fontSizeBody
                            color: Theme.textSecondary
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
            }
            
            // Back button overlay
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Theme.spacing3
                width: Theme.minTouchTarget
                height: Theme.minTouchTarget
                radius: Theme.radiusRound
                color: Theme.background
                opacity: backMouseArea.containsMouse ? 0.9 : 0.7
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.durationFast }
                }
                
                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.textPrimary
                }
                
                MouseArea {
                    id: backMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.pop()
                }
            }
            
            // Play playlist button
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: Theme.spacing3
                width: 150
                height: Theme.minTouchTarget
                radius: Theme.radiusRound
                color: Theme.primary
                opacity: playPlaylistMouseArea.pressed ? 0.8 : 1
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.durationFast }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: Theme.durationFast }
                }
                
                scale: playPlaylistMouseArea.containsMouse ? 1.05 : 1.0
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacing2
                    
                    Text {
                        text: "▶"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.background
                    }
                    
                    Text {
                        text: "Play Playlist"
                        font.pixelSize: Theme.fontSizeBody
                        font.bold: true
                        color: Theme.background
                    }
                }
                
                MouseArea {
                    id: playPlaylistMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: musicController.playPlaylist(root.playlistId)
                }
            }
        }
        
        // Track list section
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing4
                spacing: Theme.spacing3
                
                Text {
                    text: "Tracks"
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    color: Theme.textPrimary
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: musicController.getPlaylistSongs(root.playlistId)
                    clip: true
                    spacing: Theme.spacing2
                    
                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 60
                        radius: Theme.radiusMedium
                        color: trackMouseArea.containsMouse ? Theme.surfaceHover : Theme.surface
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.durationFast }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.spacing3
                            spacing: Theme.spacing3
                            
                            // Track number
                            Text {
                                text: (index + 1).toString()
                                font.pixelSize: Theme.fontSizeBody
                                color: Theme.textSecondary
                                Layout.preferredWidth: 30
                                horizontalAlignment: Text.AlignRight
                            }
                            
                            // Track info
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spacing1
                                
                                Text {
                                    text: modelData.title
                                    font.pixelSize: Theme.fontSizeBody
                                    font.bold: true
                                    color: Theme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: modelData.artist
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.textSecondary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                            
                            // Duration (would use modelData.duration if available)
                            Text {
                                text: modelData.duration || "3:45"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.textSecondary
                            }
                        }
                        
                        MouseArea {
                            id: trackMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: musicController.playSong(modelData.id)
                        }
                    }
                }
            }
        }
    }
}
