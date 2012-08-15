/*
 * Copyright (C) 2012 Antti Seppälä <antseppa@gmail.com>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Page {
    id: imageSlideshow
    anchors.fill: parent
    clip: true

    property int slideVisibleTime: 4000
    property int visibleIndex
    property real phase
    property variant galleryModel

    Image {
        id: image1
        width: Math.min(sourceSize.width, parent.width)
        height: Math.min(sourceSize.height, parent.height)
        x: (parent.width - width) * .5
        y: (parent.height - height) * .5
        opacity: 1
        fillMode: Image.PreserveAspectFit
        Behavior on opacity { NumberAnimation { duration: 1000 } }
    }
    Image {
        id: image2
        width: Math.min(sourceSize.width, parent.width)
        height: Math.min(sourceSize.height, parent.height)
        x: (parent.width - width) * .5
        y: (parent.height - height) * .5
        opacity: 0
        fillMode: Image.PreserveAspectFit
        Behavior on opacity { NumberAnimation { duration: 1000 } }
    }
    SequentialAnimation {
        id: mainLoop
        loops: Animation.Infinite
        PauseAnimation { duration: imageSlideshow.slideVisibleTime }
        ScriptAction {
            script: {
                image1.opacity = image2.opacity
                image2.opacity = 1-image2.opacity
            }
        }
        PauseAnimation { duration: 1001 }
        ScriptAction { script: loadNextImage() }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            mainLoop.stop()
            image1.source = ""
            image2.source = ""
            appWindow.pageStack.pop()
        }
    }
    Component.onCompleted: {
        if (visibleIndex < galleryModel.count) {
            phase = 0
            image1.source = galleryModel.get(visibleIndex).url
            loadNextImage()
            mainLoop.start()
        }
    }
    function loadNextImage() {
        visibleIndex++
        if (visibleIndex >= galleryModel.count)
            visibleIndex = 0

        if (phase === 0)
            image2.source = galleryModel.get(visibleIndex).url
        else
            image1.source = galleryModel.get(visibleIndex).url
        phase = 1-phase
    }
}
