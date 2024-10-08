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
using Valengine.Input;
using Valengine.Shapes;

public class Game : GLib.Application {
    private Window window;
    private MainLoop loop;
    private TimeoutSource timeout;

    private int framesCounter = 0; /* To later figure out if 2 seconds has passed. */
    private enum GameScreen {
        LOGO = 0,
        TITLE = 1,
        GAMEPLAY = 2,
        ENDING = 3,
    }
    private int currentScreen = GameScreen.LOGO;

    private Game () {
        Object (
            application_id: "io.github.lxmcf.Valengine.core_basic_screen_manager",
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

        /* Change Screen */
        switch (currentScreen) {
            case GameScreen.LOGO: {
                this.framesCounter++;
                if (this.framesCounter > 120) {
                    currentScreen = GameScreen.TITLE;
                }
                break;
            }
            case GameScreen.TITLE: {
                if (Keyboard.is_pressed (Keyboard.Key.ENTER) || Touch.is_gesture_detected (Touch.Gestures.TAP)) {
                    currentScreen = GameScreen.GAMEPLAY;
                }
                break;
            }
            case GameScreen.GAMEPLAY: {
                if (Keyboard.is_pressed (Keyboard.Key.ENTER) || Touch.is_gesture_detected (Touch.Gestures.TAP)) {
                    currentScreen = GameScreen.ENDING;
                }
                break;
            }
            case GameScreen.ENDING: {
                if (Keyboard.is_pressed (Keyboard.Key.ENTER) || Touch.is_gesture_detected (Touch.Gestures.TAP)) {
                    currentScreen = GameScreen.TITLE;
                }
                break;
            }
        }

        window.draw (() => {
            window.clear_background (Valengine.Color.RAY_WHITE);
            /* Draw Current Screen */
            var screenRectangle = new Rectangle (0, 0, window.width, window.height);
            switch (currentScreen) {
                    case GameScreen.LOGO: {
                        Font.DEFAULT.draw_text ("LOGO SCREEN", new Vector2 (20, 20), 40, null, Color.LIGHT_GRAY);
                        Font.DEFAULT.draw_text ("WAIT for 2 SECONDS...", new Vector2 (290, 220), 20, null, Color.GRAY);
                        break;
                    }
                    case GameScreen.TITLE: {
                        screenRectangle.draw (Color.GREEN, null, null);
                        Font.DEFAULT.draw_text ("TITLE SCREEN", new Vector2 (20, 20), 40, null, Color.DARK_GREEN);
                        Font.DEFAULT.draw_text ("PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN", new Vector2 (120, 220), 20, null, Color.DARK_GREEN);
                        break;
                    }
                    case GameScreen.GAMEPLAY: {
                        screenRectangle.draw (Color.PURPLE, null, null);
                        Font.DEFAULT.draw_text ("GAMEPLAY SCREEN", new Vector2 (20, 20), 40, null, Color.MAROON);
                        Font.DEFAULT.draw_text ("PRESS ENTER or TAP to JUMP to ENDING SCREEN", new Vector2 (130, 220), 20, null, Color.MAROON);
                        break;
                    }
                    case GameScreen.ENDING: {
                        screenRectangle.draw (Color.BLUE, null, null);
                        Font.DEFAULT.draw_text ("ENDING SCREEN", new Vector2 (20, 20), 40, null, Color.DARK_BLUE);
                        Font.DEFAULT.draw_text ("PRESS ENTER or TAP to RETURN to TITLE SCREEN", new Vector2 (120, 220), 20, null, Color.DARK_BLUE);
                        break;
                    }
            }
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
        const int screenWidth = 800;
        const int screenHeight = 450;
        /* Create Window */
        try {
            /* Set the title to the application_id to begin with, so Wayland-based
             * compositors can figure out their name. Not *technically* needed but
             * com.example.Example is easier to make rules for than "COOL GAME WINDOW TITLE" */
            window = new Window (screenWidth, screenHeight, this.application_id);
        } catch (WindowError e) {
            error (e.message);
        }
        window.title = "Valengine - core_basic_screen_manager";
        /* Create GLib MainLoop */
        loop = new MainLoop ();
        timeout = new TimeoutSource (1);
        timeout.set_callback (this.main_loop);
        timeout.attach (loop.get_context ());
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
