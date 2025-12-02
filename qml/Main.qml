import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "Music Manager Pro"
    
    // Global Dark Theme
    Material.theme: Material.Dark
    Material.accent: Material.Teal

    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.bottom: playerFooter.top
        anchors.left: parent.left
        anchors.right: parent.right
        initialItem: homePage
    }

    Component {
        id: homePage
        Page {
            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    Label {
                        text: "Library"
                        font.pixelSize: 20
                        font.bold: true
                        Layout.leftMargin: 10
                    }
                    Item { Layout.fillWidth: true }
                    TextField {
                        placeholderText: "Search..."
                        Layout.preferredWidth: 200
                        onTextChanged: songList.refresh(text)
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                TabBar {
                    id: bar
                    width: parent.width
                    Layout.fillWidth: true
                    TabButton { text: "Songs" }
                    TabButton { text: "Albums" }
                    TabButton { text: "Playlists" }
                }

                StackLayout {
                    currentIndex: bar.currentIndex
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    SongList { id: songList }
                    AlbumList { id: albumList }
                    PlaylistList { id: playlistList }
                }
            }
        }
    }

    footer: PlayerControls {
        id: playerFooter
    }
}
