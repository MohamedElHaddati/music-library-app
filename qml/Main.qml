import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: "Music Manager"

    property var currentSong: null

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton { text: "Songs"; onClicked: viewStack.currentIndex = 0 }
            ToolButton { text: "Albums"; onClicked: viewStack.currentIndex = 1 }
            ToolButton { text: "Playlists"; onClicked: viewStack.currentIndex = 2 }
            Item { Layout.fillWidth: true }
            TextField {
                id: searchField
                placeholderText: "Search..."
                onTextChanged: songList.refresh(text)
            }
        }
    }

    StackLayout {
        id: viewStack
        anchors.top: parent.top
        anchors.bottom: playerFooter.top
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 0

        SongList { id: songList }
        
        // Simple placeholders for other views
        Item {
            Text { text: "Albums View (Not Implemented)"; anchors.centerIn: parent }
        }
        Item {
            Text { text: "Playlists View (Not Implemented)"; anchors.centerIn: parent }
        }
    }

    footer: PlayerControls {
        id: playerFooter
        currentSongTitle: currentSong ? currentSong.title : "No Song Selected"
        currentSongArtist: currentSong ? currentSong.artist : ""
        source: currentSong ? currentSong.path : ""
    }
}
