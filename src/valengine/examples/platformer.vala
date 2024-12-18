using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;
using Valengine.Audio;

public class Game : GLib.Application {
    // Window
    private Window window;
    private MainLoop loop;
    private TimeoutSource timeout;

    // Constants
    private const int SCREEN_WIDTH = 800;
    private const int SCREEN_HEIGHT = 450;
    private const float PLAYER_JUMP_SPD = 150.0f;
    private const float PLAYER_HOR_SPD = 100.0f;
    private const Raylib.ConfigFlags[] window_flags = {
        Raylib.ConfigFlags.WINDOW_RESIZABLE
    };

    // Camera
    private 2DCamera camera;
    private CameraMode current_camera_mode = CameraMode.FOLLOW_PLAYER_SMOOTH;
    public static CameraMode[] camera_modes = {
        CameraMode.FOLLOW_PLAYER,
        CameraMode.FOLLOW_PLAYER_SMOOTH,
        CameraMode.EVEN_OUT_ON_LANDING,
        CameraMode.PLAYER_BOUNDS_PUSH
    };

    // Player & Environment
    private string sprite_path = null;
    private string sound_path = null;
    private PlatformerBody player;
    private EnvItem[] env_items;


    // Constructor
    private Game () {
        Object (application_id: "io.github.halfmexican.Valengine", flags: ApplicationFlags.FLAGS_NONE);
    }

    // First method called when the application is started
    public override void activate () {
        try {
            window = new Window.with_flags (SCREEN_WIDTH, SCREEN_HEIGHT, "Valengine - 2DCamera/Platformer", window_flags);
        } catch (WindowError e) {
            error (e.message);
        }

        player = new PlatformerBody (400, 280);
        load_assets ();

        // Handle missing sprite path
        if (sprite_path == null) {
            warning ("Error: Unable to locate installed images directory.\n");
            message ("trying development images directory...\n");
            sprite_path = Path.build_filename (Environment.get_current_dir (), "src/valengine/images/");
            return;
        }

        // Handle missing sound path
        if (sound_path == null) {
            warning ("Error: Unable to locate installed sounds directory.\n");
            message ("trying development sounds directory...\n");
            sound_path = Path.build_filename (Environment.get_current_dir (), "src/valengine/audio/");
        }

        // Print the resolved paths (optional debugging)
        message ("Images directory found at: %s\n", sprite_path);
        message ("Sounds directory found at: %s\n", sound_path);

        player.load_sprite (sprite_path + "/penguin.png", 32, 32, 4);
        Sound jump_sound = new Sound (sound_path + "/jump.ogg");
        player.set_jump_sound (jump_sound);

        env_items = {
            new EnvItem (0, 0, 1000, 400, false, Color.SKY_BLUE),
            new EnvItem (-5000, 400, 10000, 200, true, Color.GRAY),
            new EnvItem (300, 200, 400, 10, true, Color.GRAY),
            new EnvItem (250, 300, 100, 10, true, Color.GRAY),
            new EnvItem (650, 300, 100, 10, true, Color.GRAY)
        };

        camera = new 2DCamera.from_character_body (player, 0.0f, 1.0f);
        window.target_fps = 60;

        loop = new MainLoop ();
        timeout = new TimeoutSource (1);
        timeout.set_callback (main_loop);
        timeout.attach (loop.get_context ());

        loop.run ();
    }

    // Main loop
    private bool main_loop () {
        if (window.should_close) {
            loop.quit ();
            return false;
        }

        if (player.gamepad == null && Raylib.is_gamepad_available (0)) {
            player.gamepad = new Gamepad (0);
        }

        float delta_time = window.frame_time;
        player.update (delta_time);

        player.update_player (delta_time, env_items);
        camera.update_camera_combined (player, delta_time, SCREEN_WIDTH, SCREEN_HEIGHT, 40.0f, current_camera_mode);
        update_camera_projection ();

        // Add Gamepad here
        if (Keyboard.is_pressed (Keyboard.Key.C) || player.gamepad != null && player.gamepad.is_button_pressed(Gamepad.Button.RIGHT_FACE_RIGHT) ) {
            current_camera_mode = (CameraMode) (((int) current_camera_mode + 1) % camera_modes.length);
        }

        window.draw (() => {
            window.clear_background (Color.LIGHT_GRAY);
            camera.draw (() => {

                // Scrolling zoom
                camera.zoom += Mouse.get_mouse_wheel_move () * 0.05f;
                if (camera.zoom > 3.0f)camera.zoom = 3.0f;
                else if (camera.zoom < 0.25f)camera.zoom = 0.25f;

                if (Keyboard.is_pressed (Keyboard.Key.R)) {
                    camera.zoom = 1.0f;
                    player.position = new Vector2 (400, 280);
                }

                // Draw environment
                foreach (var ei in env_items) {
                    ei.rect.draw (ei.color, null, 0);
                }

                player.draw ();
            });

            draw_instructions ();
        });

        return true;
    }

    private void draw_instructions () {
        Font.DEFAULT.draw_text ("Controls:", new Shapes.Vector2 (20, 20), 10, null, Color.BLACK);
        Font.DEFAULT.draw_text ("- Right/Left to move", new Shapes.Vector2 (40, 40), 10, null, Color.DARK_GRAY);
        Font.DEFAULT.draw_text ("- Space to jump", new Shapes.Vector2 (40, 60), 10, null, Color.DARK_GRAY);
        Font.DEFAULT.draw_text ("- Mouse Wheel to Zoom in-out, R to reset zoom", new Shapes.Vector2 (40, 80), 10, null, Color.DARK_GRAY);
        Font.DEFAULT.draw_text ("- Press C to change camera mode", new Shapes.Vector2 (40, 100), 10, null, Color.DARK_GRAY);
        string camera_mode_text = current_camera_mode.to_string ();

        Font.DEFAULT.draw_text (camera_mode_text, new Shapes.Vector2 (20, 415), 20, null, Color.RED);
    }

    void update_camera_projection () {
        // TODO: Only update on window resize??
        // Update the camera's offset to center it based on the new window size
        camera.offset = new Vector2 (window.width / 2, window.height / 2);
    }

    void load_assets () {
         // Iterate through standard system data directories
        foreach (string data_dir in Environment.get_system_data_dirs ()) {
            string potential_sprite_path = Path.build_filename (data_dir, "valengine", "images");
            string potential_sound_path = Path.build_filename (data_dir, "valengine", "audio");
            if (FileUtils.test (potential_sprite_path, FileTest.IS_DIR)) {
                sprite_path = potential_sprite_path;
            }
            if (FileUtils.test (potential_sound_path, FileTest.IS_DIR)) {
                sound_path = potential_sound_path;
            }
            if (sprite_path != null && sound_path != null)break;
        }
    }

    public static int main (string[] args) {
        var app = new Game ();
        return app.run (args);
    }
}

