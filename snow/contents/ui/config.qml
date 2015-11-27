/*
 *  Copyright 2015 Ivan Safonov <safonov.ivan.s@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.0
import org.kde.plasma.core 2.0

ColumnLayout {
    id: root
    spacing: units.largeSpacing / 2

    property string cfg_Image
    property int cfg_FillMode
    property int cfg_Velocity
    property int cfg_Particles
    property int cfg_Size
    property string cfg_Snowflake

    GroupBox {
        title: i18nd("plasma_applet_org.kde.snow", "Background")
        Layout.fillWidth: true

        GridLayout {
            columnSpacing: units.largeSpacing / 2
            rowSpacing: units.largeSpacing / 2
            columns: 2

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Image:")
                Layout.alignment: Qt.AlignRight
            }

            Rectangle {
                border.color: "black"
                border.width: 1
                width: 160
                height: 90
                Image {
                    id: img1
                    anchors.margins: 2
                    anchors.fill: parent
                    fillMode: cfg_FillMode
                    source: cfg_Image
                    antialiasing: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: fileDialog.open()
                    }
                }
            }

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Positioning:")
                Layout.alignment: Qt.AlignRight
            }

            ComboBox {
                model: [
                    {
                        'label': i18nd("plasma_applet_org.kde.image", "Scaled and Cropped"),
                        'fillMode': Image.PreserveAspectCrop
                    },
                    {
                        'label': i18nd("plasma_applet_org.kde.image", "Scaled"),
                        'fillMode': Image.Stretch
                    },
                    {
                        'label': i18nd("plasma_applet_org.kde.image", "Scaled, Keep Proportions"),
                        'fillMode': Image.PreserveAspectFit
                    },
                    {
                        'label': i18nd("plasma_applet_org.kde.image", "Centered"),
                        'fillMode': Image.Pad
                    },
                    {
                        'label': i18nd("plasma_applet_org.kde.image", "Tiled"),
                        'fillMode': Image.Tile
                    }
                ]
                textRole: "label"
                property int fillMode: cfg_FillMode
                onFillModeChanged: {
                    for (var i = 0; i < model.length; i++) {
                        if (model[i].fillMode == fillMode) {
                            currentIndex = i;
                            break
                        }
                    }
                }
                onCurrentIndexChanged: cfg_FillMode = model[currentIndex].fillMode
                Layout.fillWidth: true
            }
        }
    }

    GroupBox {
        title: i18nd("plasma_applet_org.kde.snow", "Snow")
        Layout.fillWidth: true

        GridLayout {
            columnSpacing: units.largeSpacing / 2
            rowSpacing: units.largeSpacing / 2
            columns: 2

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Snowflake:")
                Layout.alignment: Qt.AlignRight
            }
            ComboBox {
                textRole: "filePath"
                model : FolderListModel {
                    folder: "data"
                    showDirs: false
                    nameFilters: ["*.png"]
                }

                onCurrentIndexChanged: {
                    if (count)
                        cfg_Snowflake = model.get(currentIndex, "filePath")
                }

                property string snowflake: cfg_Snowflake
                onCountChanged: setSnowflake()
                onSnowflakeChanged: setSnowflake()

                function setSnowflake() {
                    for (var i = 0; i < count; i++) {
                        if (model.get(i, "filePath") == snowflake) {
                            currentIndex = i;
                            return
                        }
                    }
                    if (count && currentIndex == 0)
                        cfg_Snowflake = model.get(currentIndex, "filePath")
                }

                style: ComboBoxStyle {
                    label: Rectangle {
                        implicitHeight: 40
                        implicitWidth: 60
                        color: "black"
                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            source: control.currentText
                        }
                    }
                    property Component __dropDownStyle: MenuStyle {
                        __menuItemType: "comboboxitem"

                        itemDelegate.label: Rectangle {
                            implicitHeight: 40
                            implicitWidth: 60
                            color: "black"
                            Image {
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                                source: styleData.text
                            }
                        }
                    }
                }
            }

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Number of snowflakes:")
                Layout.alignment: Qt.AlignRight
            }
            SpinBox {
                value: cfg_Particles
                minimumValue: 50
                maximumValue: 2000
                onValueChanged: cfg_Particles = value
            }

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Size of snowflake:")
                Layout.alignment: Qt.AlignRight
            }
            SpinBox {
                value: cfg_Size
                suffix: i18nd("plasma_applet_org.kde.snow", " pixels")
                minimumValue: 5
                maximumValue: 50
                onValueChanged: cfg_Size = value
            }

            Label {
                text: i18nd("plasma_applet_org.kde.snow", "Speed:")
                Layout.alignment: Qt.AlignRight
            }
            SpinBox {
                value: cfg_Velocity
                suffix: i18nd("plasma_applet_org.kde.snow", " pixels/sec")
                minimumValue: 10
                maximumValue: 500
                onValueChanged: cfg_Velocity = value
            }
        }
    }

    Item {
        // Spacer
        Layout.fillHeight: true
    }

    FileDialog {
        id: fileDialog
        title: i18nd("plasma_applet_org.kde.snow", "Please choose an image")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            cfg_Image = fileDialog.fileUrls[0]
        }
    }
}
