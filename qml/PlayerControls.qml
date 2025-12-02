import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ToolBar {
    id: root
    
    property var currentSong: musicController.getCurrentSong()
    
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
        audioOutput: AudioOutput {}
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position > 0 && position >= duration) {
                musicController.nextSong()
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        
        ColumnLayout {
            Text { 
                text: root.currentSong.title 
                font.bold: true 
                color: "white"
                elide: Text.ElideRight
                Layout.maximumWidth: 200
            }
            Text { 
                text: root.currentSong.artist 
                font.pixelSize: 10 
                color: "#cccccc"
                elide: Text.ElideRight
                Layout.maximumWidth: 200
            }
        }
        
        Item { Layout.fillWidth: true }
        
        Button {
            text: "⏮"
            onClicked: musicController.previousSong()
        }
        
        Button {
            text: player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
            enabled: root.currentSong.hasSong
            onClicked: {
                if (player.playbackState === MediaPlayer.PlayingState)
                    player.pause()
                else
                    player.play()
            }
        }
        
        Button {
            text: "⏭"
            onClicked: musicController.nextSong()
        }
    }
}
