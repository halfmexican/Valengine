using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;

public class Game : GLib.Application {
    // Window
    private Window window;
    private MainLoop loop;
    private TimeoutSource timeout;

    // Constants
    private const int SCREEN_WIDTH = 800;
    private const int SCREEN_HEIGHT = 450;
    private const int G = 400;
    private const float PLAYER_JUMP_SPD = 350.0f;
    private const float PLAYER_HOR_SPD = 200.0f;

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
    private PlayerBody player;
    private Valengine.Environment world;

    private Game () {
        Object (application_id: "io.github.halfmexican.Valengine", flags: ApplicationFlags.FLAGS_NONE);
    }

    // First method called when the application is started
    public override void activate () {
        try {
            window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Valengine - Example");
        } catch (WindowError e) {
            error (e.message);
        }

        player = new PlayerBody (400, 280);
        world = new Valengine.Environment ();

        world.add_item (new EnvironmentItem (0, 0, 1000, 400, false));
        world.add_item (new EnvironmentItem (0, 400, 1000, 200, true));
        world.add_item (new EnvironmentItem (300, 200, 400, 10, true));
        world.add_item (new EnvironmentItem (250, 300, 100, 10, true));
        world.add_item (new EnvironmentItem (650, 300, 100, 10, true));

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

        float delta_time = window.frame_time;

        player.update_player (delta_time, world.env_items);
        camera.update_camera_combined (player, delta_time, SCREEN_WIDTH, SCREEN_HEIGHT, 40.0f, current_camera_mode);

        if (Keyboard.is_pressed (Keyboard.Key.C)) {
            current_camera_mode = (CameraMode) (((int) current_camera_mode + 1) % camera_modes.length);
        }

        window.draw (() => {
            window.clear_background (Color.LIGHT_GRAY);
            camera.draw (() => {
                world.draw ();
                player.draw ();
                var center_circle = new Circle (player.position.x, player.position.y, 5.0f);
                center_circle.draw (Color.GOLD);
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

    public static int main (string[] args) {
        var app = new Game ();
        return app.run (args);
    }
}