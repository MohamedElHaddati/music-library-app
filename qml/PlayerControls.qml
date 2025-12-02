import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Effects

ToolBar {
    id: root
    height: 100
    
    property var currentSong: musicController.getCurrentSong()
    
    background: Rectangle {
        color: "#1A1A1A"
        
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#60000000"
            shadowVerticalOffset: -2
            shadowBlur: 0.5
        }
    }
    
    Connections {
        target: musicController
        function onCurrentSongChanged() {
            root.currentSong = musicController.getCurrentSong()
            if (root.currentSong.hasSong) {
                player.source = root.currentSong.path
                player.play()
            }
        }
    }
    
    MediaPlayer {
        id: player
        audioOutput: AudioOutput {
            id: audioOutput
            volume: volumeSlider.value
        }
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position > 0 && position >= duration) {
                musicController.nextSong()
            }
        }
    }
    
    Timer {
        interval: 100
        running: player.playbackState === MediaPlayer.PlayingState
        repeat: true
        onTriggered: progressBar.value = player.position / player.duration
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Progress Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            color: "#333333"
            
            Rectangle {
                id: progressBar
                property real value: 0
                width: parent.width * value
                height: parent.height
                color: "#00BCD4"
                
                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: function(mouse) {
                    if (player.duration > 0) {
                        var pos = (mouse.x / width) * player.duration
                        player.position = pos
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 15
            spacing: 20
            
            // Album Art & Song Info
            RowLayout {
                Layout.preferredWidth: 300
                spacing: 15
                
                Rectangle {
                    width: 60
                    height: 60
                    radius: 6
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#444444" }
                        GradientStop { position: 1.0; color: "#222222" }
                    }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#40000000"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 2
                        shadowBlur: 0.3
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "♪"
                        font.pixelSize: 28
                        color: "#00BCD4"
                        font.bold: true
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Text { 
                        text: root.currentSong.title || "No song playing"
                        font.pixelSize: 14
                        font.bold: true 
                        color: "white"
                        elide: Text.ElideRight
                        Layout.maximumWidth: 220
                    }
                    Text { 
                        text: root.currentSong.artist || "Select a song to play"
                        font.pixelSize: 12
                        color: "#AAAAAA"
                        elide: Text.ElideRight
                        Layout.maximumWidth: 220
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Playback Controls
            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
                
                Button {
                    id: prevButton
                    text: "⏮"
                    font.pixelSize: 18
                    flat: true
                    
                    background: Rectangle {
                        radius: 20
                        color: prevButton.hovered ? "#2D2D2D" : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: prevButton.text
                        font: prevButton.font
                        color: prevButton.hovered ? "#00BCD4" : "#CCCCCC"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    onClicked: musicController.previousSong()
                }
                
                Button {
                    id: playButton
                    text: player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                    enabled: root.currentSong.hasSong
                    font.pixelSize: 20
                    
                    background: Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: playButton.enabled ? "#00BCD4" : "#555555" }
                            GradientStop { position: 1.0; color: playButton.enabled ? "#0097A7" : "#444444" }
                        }
                        
                        scale: playButton.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowColor: playButton.enabled ? "#6000BCD4" : "#30000000"
                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 2
                            shadowBlur: 0.4
                        }
                    }
                    
                    contentItem: Text {
                        text: playButton.text
                        font: playButton.font
                        color: playButton.enabled ? "white" : "#888888"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (player.playbackState === MediaPlayer.PlayingState)
                            player.pause()
                        else
                            player.play()
                    }
                }
                
                Button {
                    id: nextButton
                    text: "⏭"
                    font.pixelSize: 18
                    flat: true
                    
                    background: Rectangle {
                        radius: 20
                        color: nextButton.hovered ? "#2D2D2D" : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: nextButton.text
                        font: nextButton.font
                        color: nextButton.hovered ? "#00BCD4" : "#CCCCCC"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    onClicked: musicController.nextSong()
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Volume Control
            RowLayout {
                Layout.preferredWidth: 150
                spacing: 10
                
                Text {
                    text: volumeSlider.value < 0.01 ? "🔇" : volumeSlider.value < 0.5 ? "🔉" : "🔊"
                    font.pixelSize: 16
                    color: "#AAAAAA"
                }
                
                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: 0.7
                    
                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: volumeSlider.availableWidth
                        height: 4
                        radius: 2
                        color: "#333333"
                        
                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#00BCD4"
                            radius: 2
                        }
                    }
                    
                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: 12
                        height: 12
                        radius: 6
                        color: "#00BCD4"
                        border.color: volumeSlider.pressed ? "#80DEEA" : "#00BCD4"
                        border.width: 2
                        
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowColor: "#6000BCD4"
                            shadowBlur: 0.3
                        }
                    }
                }
            }
        }
    }
}
