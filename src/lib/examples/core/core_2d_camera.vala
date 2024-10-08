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
using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;

public class Game : GLib.Application {
    private Window window;
    private MainLoop loop;
    private TimeoutSource timeout;
    /* Resolution */
    private const int screenWidth = 800;
    private const int screenHeight = 450;

    private const int MAX_BUILDINGS = 100;
    public int spacing = 0;
    private Rectangle player;
    private Rectangle ground;
    private 2DCamera camera;

    private class building {
        public Rectangle shape;
        public Color color;
        public building (int spacing) {
            shape = new Rectangle (1, 1, 1, 1);
            this.shape.width = (float) Random.int_range (50, 200);
            this.shape.height = (float) Random.int_range (100, 800);
            this.shape.y = screenHeight - 130.0f - this.shape.height;
            this.shape.x = -6000.0f + spacing;

            this.color = new Color.from_rgba (
                (uint8) Random.int_range (200, 240),
                (uint8) Random.int_range (200, 240),
                (uint8) Random.int_range (200, 250),
                255
            );
        }
    }
    Array<building> buildings;

    private Game () {
        /* GLib.Application properties. Set the application to a reverse DNS. If
         * your game is named Pong, and your website is cool.site. Then the'
         * application_id would be: site.cool.Pong */
        Object (
            application_id: "io.github.lxmcf.Valengine.core_2d_camera",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    ~Game () {
        window = null;
    }

    private bool main_loop () {
        /* Check if Application Should Close */
        if (window.should_close) {
            /* Tell loop to stop */
            loop.quit ();
            return (false);
        }
        /* Player controls */
        if (Keyboard.is_down (Keyboard.Key.RIGHT)) {
            player.x += 2;
        } else if (Keyboard.is_down (Keyboard.Key.LEFT)) {
            player.x -= 2;
        }
        /* Update camera */

        /* Update camera with player's position. */
        camera.target = new Vector2 (player.x + 20, player.y + 20);

        /* Rotate camera controls */
        if (Keyboard.is_down (Keyboard.Key.A)) {
            camera.rotation--;
        } else if (Keyboard.is_down (Keyboard.Key.S)) {
            camera.rotation++;
        }

        /* Camera zoom controls */
        camera.zoom += ((float) Mouse.wheel_move.y * 0.05f);
        if (camera.zoom > 3.0f) {
            camera.zoom = 3.0f;
        } else if (camera.zoom < 0.1f) {
            camera.zoom = 0.1f;
        }

        /* Reset camera controls */
        if (Keyboard.is_down (Keyboard.Key.R)) {
            camera.zoom = 1.0f;
            camera.rotation = 0.0f;
        }

        window.draw (() => {
            window.clear_background (Valengine.Color.RAY_WHITE);
            /* Draw the things that move with the camera */
            camera.draw (() => {
                ground.draw (Color.DARK_GRAY, null, null);
                foreach (var b in buildings) {
                    b.shape.draw (b.color, null, null);
                }
                player.draw (Color.RED, null, null);
                Line.draw (
                    new Vector2 (camera.target.x, -screenHeight * 10),
                    new Vector2 (camera.target.x, screenHeight * 10),
                    Color.GREEN
                );
                Line.draw (
                    new Vector2 (-screenWidth * 10, camera.target.y),
                    new Vector2 (screenWidth * 10, camera.target.y),
                    Color.GREEN
                );
            });
            /* Draw screen box */
            Font.DEFAULT.draw_text ("SCREEN AREA", new Vector2 (640, 10), 20, null, Color.RED);
            new Rectangle (0, 0, screenWidth, screenHeight).draw_outline (5, Color.RED);
            var controlBox = new Rectangle (10, 10, 250, 113);
            /* Draw box that shows controls */
            controlBox.draw (Color.fade (Color.SKY_BLUE, 0.5f), null, null);
            controlBox.draw_outline (1, Color.BLUE);
            Font.DEFAULT.draw_text ("Free 2d camera controls", new Vector2 (20, 20), 10, null, Color.BLACK);
            Font.DEFAULT.draw_text ("- Right/Left to move Offset", new Vector2 (40, 40), 10, null, Color.DARK_GRAY);
            Font.DEFAULT.draw_text ("- Mouse Wheel to Zoom in-out", new Vector2 (40, 60), 10, null, Color.DARK_GRAY);
            Font.DEFAULT.draw_text ("- A / S to Rotate", new Vector2 (40, 80), 10, null, Color.DARK_GRAY);
            Font.DEFAULT.draw_text ("- R to reset Zoom and Rotation", new Vector2 (40, 100), 10, null, Color.DARK_GRAY);
        });
        /* Tell Loop to keep going */
        return (true);
    }

    /* Handle Command Line Args */
    public override int handle_local_options (VariantDict args) {
        /* Print Version and Exit */
        if (args.contains ("version")) {
            stdout.printf (VERSION);
            Process.exit (0);
        }
        /* Print License and Exit */
        if (args.contains ("license")) {
            stdout.printf (LICENSE);
            Process.exit (0);
        }
        /* Run Application */
        return (-1);
    }

    public override void activate () {

        /* Create Window */
        try {
            /* Set the title to the application_id to begin with, so Wayland-based
             * compositors can figure out their name. Not *technically* needed but
             * com.example.Example is easier to make rules for than "COOL GAME WINDOW TITLE" */
            window = new Window (screenWidth, screenHeight, this.application_id);
        } catch (WindowError e) {
            error (e.message);
        }
        window.title = "Valengine - Core 2D Example";
        /* Create GLib MainLoop */
        loop = new MainLoop ();
        timeout = new TimeoutSource (1);
        timeout.set_callback (this.main_loop);
        timeout.attach (loop.get_context ());

        /* Create buildings */
        buildings = new Array<building> ();
        for (int i = 0; i < MAX_BUILDINGS; ++i) {
            buildings.append_val (new building (spacing));
            spacing += (int) buildings.index (i).shape.width;
        }

        /* Initialize player */
        player = new Rectangle (400, 280, 40, 40);
        /* Initalize camera */
        camera = new 2DCamera (
            new Vector2 (screenWidth / 2.0f, screenHeight / 2.0f),
            new Vector2 (player.x + 20.0f, player.y + 20.0f),
            0.0f,
            1.0f
        );
        /* Create ground */
        ground = new Rectangle (
            -6000, 320, 13000, 8000
        );
        /* Run Main Loop */
        loop.run ();
    }

    public static int main (string[] args) {
        /* Create GLib.Application */
        var app = new Game ();
        /* Add Command Line Options */
        app.add_main_option ("version", 'v', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, "Displays program's version.", null);
        app.add_main_option ("license", 'l', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, "Displays program's license.", null);
        /* Run Application */
        app.run (args);
        return (0);
    }
}
