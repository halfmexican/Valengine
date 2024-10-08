/*
 * Copyright 2024 Charadon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* To make sure lines work. */
using GLib;
using Valengine;
using Valengine.Shapes;

int main (string[] args) {
    Window window;
    try {
        window = new Window (640, 480, "Draw Line Test");
    } catch (WindowError e) {
        error (e.message);
    }
    while (window.should_close == false) {
        window.draw (() => {
            Line.draw_strip ({ new Vector2 (0, 0), new Vector2 (550, 55), new Vector2 (220, 640) }, Color.RED);
        });
    }
    return (0);
}
