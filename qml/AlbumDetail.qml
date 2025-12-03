import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MusicManager

Page {
    id: root
    property int albumId: -1
    property string albumTitle: ""
    property string albumCover: ""
    
    background: Rectangle {
        color: AppTheme.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Hero header with album art and gradient overlay
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: AppTheme.primary }
                GradientStop { position: 1.0; color: "#1a1a1a" }
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: AppTheme.spacing6
                spacing: AppTheme.spacing5
                
                // Album artwork with disc icon
                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    Layout.alignment: Qt.AlignVCenter
                    radius: AppTheme.radiusMedium
                    color: AppTheme.surface
                    
                    Text {
                        anchors.centerIn: parent
                        text: "💿"
                        font.pixelSize: 80
                    }
                }
                
                // Album info
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: AppTheme.spacing3
                    
                    Text {
                        text: "ALBUM"
                        font.pixelSize: AppTheme.fontSizeSmall
                        font.bold: true
                        color: AppTheme.textSecondary
                    }
                    
                    Text {
                        text: root.albumTitle
                        font.pixelSize: 48
                        font.bold: true
                        color: AppTheme.textPrimary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
            
            // Play album button
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
                        var songs = musicController.getSongsByAlbum(root.albumId)
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
                    text: "Tracks"
                    font.pixelSize: AppTheme.fontSizeXLarge
                    font.bold: true
                    color: AppTheme.textPrimary
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: AppTheme.spacing2
                    clip: true
                    
                    model: musicController.getSongsByAlbum(root.albumId)
                    
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
                                text: {
                                    if (modelData.duration && modelData.duration > 0) {
                                        var minutes = Math.floor(modelData.duration / 60)
                                        var seconds = modelData.duration % 60
                                        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
                                    }
                                    return "--:--"
                                }
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
