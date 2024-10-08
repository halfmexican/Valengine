using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;

public class Game : GLib.Application {
    private Window window;
    private MainLoop loop;
    private TimeoutSource timeout;

    private const int SCREEN_WIDTH = 800;
    private const int SCREEN_HEIGHT = 450;
    private const int G = 400;
    private const float PLAYER_JUMP_SPD = 350.0f;
    private const float PLAYER_HOR_SPD = 200.0f;

    private Player player;
    private EnvItem[] env_items;
    private 2DCamera camera;

    public class Player {
        public Vector2 position;
        public float speed;
        public bool can_jump;

        public Player (float x, float y) {
            position = new Vector2 (x, y);
            speed = 0;
            can_jump = false;
        }
    }

    public class EnvItem {
        public Rectangle rect;
        public bool blocking;
        public Color color;

        public EnvItem (float x, float y, float width, float height, bool blocking, Color color) {
            rect = new Rectangle (x, y, width, height);
            this.blocking = blocking;
            this.color = color;
        }
    }

    private Game () {
        Object (application_id: "io.github.lxmcf.Valengine.Valengine", flags: ApplicationFlags.FLAGS_NONE);
    }

    public override void activate () {
        try {
            window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "raylib [core] example - 2d camera");
        } catch (WindowError e) {
            error (e.message);
        }

        player = new Player (400, 280);
        env_items = {
            new EnvItem (0, 0, 1000, 400, false, Color.SKY_BLUE),
            new EnvItem (0, 400, 1000, 200, true, Color.GRAY),
            new EnvItem (300, 200, 400, 10, true, Color.GRAY),
            new EnvItem (250, 300, 100, 10, true, Color.GRAY),
            new EnvItem (650, 300, 100, 10, true, Color.GRAY)
        };

        camera = new 2DCamera (
            new Vector2 (SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f),
            player.position,
            0.0f,
            1.0f
        );

        window.target_fps = 60;

        loop = new MainLoop ();
        timeout = new TimeoutSource (1);
        timeout.set_callback (main_loop);
        timeout.attach (loop.get_context ());

        loop.run ();
    }

    private bool main_loop () {
        if (window.should_close) {
            loop.quit ();
            return false;
        }

        float delta_time = window.frame_time;

        update_player (delta_time);
        update_camera_combined (player, delta_time, SCREEN_WIDTH, SCREEN_HEIGHT, 40);

        window.draw (() => {
            window.clear_background (Color.LIGHT_GRAY);
            camera.draw (() => {
                foreach (var ei in env_items) {
                    ei.rect.draw (ei.color, null, 0);
                }
                Rectangle player_rect = new Rectangle (player.position.x - 20, player.position.y - 40, 40, 40);
                player_rect.draw (Color.RED, null, 0);
                var center_rect = new Circle (player.position.x, player.position.y, 5.0f);
                center_rect.draw (Color.GOLD);
            });

            draw_instructions ();
        });

        return true;
    }

    private void update_player (float delta) {
        if (Keyboard.is_down (Keyboard.Key.LEFT))player.position.x -= PLAYER_HOR_SPD * delta;
        if (Keyboard.is_down (Keyboard.Key.RIGHT))player.position.x += PLAYER_HOR_SPD * delta;
        if (Keyboard.is_down (Keyboard.Key.SPACE) && player.can_jump) {
            player.speed = -PLAYER_JUMP_SPD;
            player.can_jump = false;
        }

        bool hit_obstacle = false;
        foreach (var ei in env_items) {
            if (ei.blocking &&
                ei.rect.x <= player.position.x &&
                ei.rect.x + ei.rect.width >= player.position.x &&
                ei.rect.y >= player.position.y &&
                ei.rect.y <= player.position.y + player.speed * delta) {
                hit_obstacle = true;
                player.speed = 0.0f;
                player.position.y = ei.rect.y;
                break;
            }
        }

        if (!hit_obstacle) {
            player.position.y += player.speed * delta;
            player.speed += G * delta;
            player.can_jump = false;
        } else {
            player.can_jump = true;
        }
    }

    private void update_camera_combined (Player player, float delta, int width, int height, float vertical_offset) {
        const float min_speed = 50;
        const float min_effect_length = 10;
        const float fraction_speed = 0.8f;
        const float even_out_speed = 100.0f;

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

        camera.offset = new Vector2 (width / 2.0f, height / 2.0f + vertical_offset);
        Vector2 diff = new Vector2 (player.position.x - camera.target.x, player.position.y - camera.target.y);
        float length = (float) Math.sqrt (diff.x * diff.x + diff.y * diff.y);

        if (length > min_effect_length) {
            float speed = (float) Math.fmax (fraction_speed * length, min_speed);
            camera.target = new Vector2 (
                camera.target.x + diff.x * speed * delta / length,
                camera.target.y + diff.y * speed * delta / length
            );
        }

        if (player.can_jump) {
            if (camera.target.y < player.position.y) {
                camera.target = new Vector2 (
                    camera.target.x,
                    camera.target.y + (float) Math.fmin (player.position.y - camera.target.y, even_out_speed * delta)
                );
            } else if (camera.target.y > player.position.y) {
                camera.target = new Vector2 (
                    camera.target.x,
                    camera.target.y - (float) Math.fmin (camera.target.y - player.position.y, even_out_speed * delta)
                );
            }
        }
    }

    private void draw_instructions () {
        Font.DEFAULT.draw_text ("Controls:", new Shapes.Vector2 (20, 20), 10, null, Color.BLACK);
        Font.DEFAULT.draw_text ("- Right/Left to move", new Shapes.Vector2 (40, 40), 10, null, Color.DARK_GRAY);
        Font.DEFAULT.draw_text ("- Space to jump", new Shapes.Vector2 (40, 60), 10, null, Color.DARK_GRAY);
        Font.DEFAULT.draw_text ("- Mouse Wheel to Zoom in-out, R to reset zoom", new Shapes.Vector2 (40, 80), 10, null, Color.DARK_GRAY);
    }

    public static int main (string[] args) {
        var app = new Game ();
        return app.run (args);
    }
}
