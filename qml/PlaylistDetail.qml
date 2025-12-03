import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MusicManager

Page {
    id: root
    property int playlistId: -1
    property string playlistTitle: ""
    
    background: Rectangle {
        color: AppTheme.background
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
                GradientStop { position: 1.0; color: "#1a1a1a" }
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: AppTheme.spacing6
                spacing: AppTheme.spacing5
                
                // Playlist artwork
                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    Layout.alignment: Qt.AlignVCenter
                    radius: AppTheme.radiusMedium
                    color: AppTheme.surface
                    
                    Text {
                        anchors.centerIn: parent
                        text: "🎵"
                        font.pixelSize: 80
                    }
                }
                
                // Playlist info
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: AppTheme.spacing3
                    
                    Text {
                        text: "PLAYLIST"
                        font.pixelSize: AppTheme.fontSizeSmall
                        font.bold: true
                        color: AppTheme.textSecondary
                    }
                    
                    Text {
                        text: root.playlistTitle
                        font.pixelSize: 48
                        font.bold: true
                        color: AppTheme.textPrimary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
            
            // Back button overlay
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: AppTheme.spacing4
                width: 40
                height: 40
                radius: 20
                color: "#80000000"
                
                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.pixelSize: AppTheme.fontSizeLarge
                    color: AppTheme.textPrimary
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.StackView.view) {
                            root.StackView.view.pop()
                        }
                    }
                }
            }
            
            // Play playlist button
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: AppTheme.spacing4
                width: 56
                height: 56
                radius: 28
                color: AppTheme.primary
                
                Text {
                    anchors.centerIn: parent
                    text: "▶"
                    font.pixelSize: AppTheme.fontSizeLarge
                    color: AppTheme.textPrimary
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Play first song in playlist
                        var songs = musicController.getSongsByPlaylist(root.playlistId)
                        if (songs.length > 0) {
                            musicController.playSong(songs[0].id)
                        }
                    }
                }
            }
        }
        
        // Track list section
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: AppTheme.background
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: AppTheme.spacing5
                spacing: AppTheme.spacing4
                
                Text {
                    text: "Songs"
                    font.pixelSize: AppTheme.fontSizeXLarge
                    font.bold: true
                    color: AppTheme.textPrimary
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: AppTheme.spacing2
                    clip: true
                    
                    model: musicController.getSongsByPlaylist(root.playlistId)
                    
                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 60
                        radius: AppTheme.radiusMedium
                        color: mouseArea.containsMouse ? AppTheme.surfaceHover : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: AppTheme.spacing3
                            spacing: AppTheme.spacing3
                            
                            Text {
                                text: (index + 1).toString()
                                font.pixelSize: AppTheme.fontSizeMedium
                                color: AppTheme.textSecondary
                                Layout.preferredWidth: 30
                                horizontalAlignment: Text.AlignRight
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                
                                Text {
                                    text: modelData.title
                                    font.pixelSize: AppTheme.fontSizeMedium
                                    color: AppTheme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: modelData.artist
                                    font.pixelSize: AppTheme.fontSizeSmall
                                    color: AppTheme.textSecondary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                            
                            Text {
                                text: Math.floor(modelData.duration / 60) + ":" + 
                                      (modelData.duration % 60 < 10 ? "0" : "") + 
                                      (modelData.duration % 60)
                                font.pixelSize: AppTheme.fontSizeSmall
                                color: AppTheme.textSecondary
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
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
