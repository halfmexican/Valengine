using Valengine;
using Valengine.Shapes;
using Valengine.Input;
using Valengine.Audio;
namespace Valengine {
    public class PongGame : GLib.Application {
        // Window
        private Window window;
        private MainLoop loop;
        private TimeoutSource timeout;

        // Constants
        private const int SCREEN_WIDTH = 800;
        private const int SCREEN_HEIGHT = 450;
        private const float PADDLE_SPEED = 300;
        private const float BALL_SPEED = 300;
        string current_dir = Environment.get_current_dir ();


        // Game objects
        private Rectangle paddle_left;
        private Rectangle paddle_right;
        private Circle ball;
        private Vector2 ball_velocity;
        private int score_left = 0;
        private int score_right = 0;

        // Audio
        private Sound ? ping;
        private Sound ? pong;

        // Input
        private Gamepad ? gamepad;

        private PongGame () {
            Object (application_id : "io.github.valengine.pong", flags : ApplicationFlags.FLAGS_NONE);
        }

        // First method called when the application is started
        public override void activate () {
            try {
                window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Valengine Pong");
            } catch (WindowError e) {
                error (e.message);
            }

            // Initialize game objects
            paddle_left = new Rectangle (50, SCREEN_HEIGHT / 2 - 40, 15, 80);
            paddle_right = new Rectangle (SCREEN_WIDTH - 65, SCREEN_HEIGHT / 2 - 40, 15, 80);

            // Use draw_rounded to draw paddles with rounded corners
            float roundness = 0.5f; // Value between 0.0f and 1.0f
            int segments = 0;    // Use 0 for automatic segments calculation
            paddle_left.draw_rounded (roundness, segments, 0.0f, Color.WHITE);
            paddle_right.draw_rounded (roundness, segments, 0.0f, Color.WHITE);

            ball = new Circle (SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 10);
            reset_ball ();

            window.target_fps = 60;

            loop = new MainLoop ();
            timeout = new TimeoutSource (1);
            timeout.set_callback (main_loop);
            timeout.attach (loop.get_context ());

            // Load audio
            string sound_path = Path.build_filename (current_dir, "src/valengine/audio/");
            ping = new Sound (sound_path + "ping.ogg");
            pong = new Sound (sound_path + "pickup_coin.ogg");
            loop.run ();
        }

        private void reset_ball () {
            ball.x = SCREEN_WIDTH / 2;
            ball.y = SCREEN_HEIGHT / 2;
            ball_velocity = new Vector2 (BALL_SPEED * (Random.int_range (0, 2) == 0 ? 1 : -1),
                                         BALL_SPEED * (Random.int_range (0, 2) == 0 ? 1 : -1));

            if (pong != null)pong.playing = true;
        }

        private bool check_collision_circle_rect (Circle circle, Rectangle rect) {
            float closest_x = clamp (circle.x, rect.x, rect.x + rect.width);
            float closest_y = clamp (circle.y, rect.y, rect.y + rect.height);

            float distance_x = circle.x - closest_x;
            float distance_y = circle.y - closest_y;

            float distance_squared = (distance_x * distance_x) + (distance_y * distance_y);
            return distance_squared < (circle.radius * circle.radius);
        }

        private float clamp (float value, float min, float max) {
            return (float) Math.fmax (min, Math.fmin (value, max));
        }

        private bool main_loop () {
            if (window.should_close) {
                loop.quit ();
                return false;
            }

            if (gamepad == null && Raylib.is_gamepad_available (0)) {
                gamepad = new Gamepad (0);
            }

            float delta = window.frame_time;

            // Initialize ControlMapping
            ControlMapping controls = new ControlMapping();

            // Update paddles using ControlMapping
            if (controls.is_action_down(PlayerAction.MOVE_UP, gamepad) && paddle_left.y > 0)
                paddle_left.y -= PADDLE_SPEED * delta;
            if (controls.is_action_down(PlayerAction.MOVE_DOWN, gamepad) && paddle_left.y < SCREEN_HEIGHT - paddle_left.height)
                paddle_left.y += PADDLE_SPEED * delta;

            if (controls.is_action_down(PlayerAction.MOVE_UP, gamepad) && paddle_right.y > 0)
                paddle_right.y -= PADDLE_SPEED * delta;
            if (controls.is_action_down(PlayerAction.MOVE_DOWN, gamepad) && paddle_right.y < SCREEN_HEIGHT - paddle_right.height)
                paddle_right.y += PADDLE_SPEED * delta;

            // Use the Gamepad object if available
            if (gamepad != null && gamepad.still_around()) {
                // Use left analog stick for left paddle
                float left_stick_y = controls.get_axis_movement_left(PlayerAction.MOVE_UP, gamepad);
                if (Math.fabsf(left_stick_y) > 0.1) { // Add a deadzone threshold
                    paddle_left.y += left_stick_y * PADDLE_SPEED * delta;
                    paddle_left.y = clamp(paddle_left.y, 0, SCREEN_HEIGHT - paddle_left.height);
                }

                // Use right analog stick for right paddle
                float right_stick_y = controls.get_axis_movement_right(PlayerAction.MOVE_UP, gamepad);
                if (Math.fabsf(right_stick_y) > 0.1) { // Add a deadzone threshold
                    paddle_right.y += right_stick_y * PADDLE_SPEED * delta;
                    paddle_right.y = clamp(paddle_right.y, 0, SCREEN_HEIGHT - paddle_right.height);
                }
            }


            // Update ball and other game logic...
            ball.x += ball_velocity.x * delta;
            ball.y += ball_velocity.y * delta;

            // Ball collisions with top and bottom walls
            if (ball.y - ball.radius <= 0 || ball.y + ball.radius >= SCREEN_HEIGHT) {
                ball_velocity.y *= -1;
            }

            // Paddle collisions
            if (check_collision_circle_rect (ball, paddle_left)) {
                ball.x = paddle_left.x + paddle_left.width + ball.radius;
                ball_velocity.x = Math.fabsf (ball_velocity.x * 1.1f);
                ping.playing = true;
            }

            if (check_collision_circle_rect (ball, paddle_right)) {
                ball.x = paddle_right.x - ball.radius;
                ball_velocity.x = -Math.fabsf (ball_velocity.x * 1.1f);
                ping.playing = true;
            }

            // Score points
            if (ball.x < 0) {
                score_right++;
                reset_ball ();
            }
            if (ball.x > SCREEN_WIDTH) {
                score_left++;
                reset_ball ();
            }

            // Drawing code
            window.draw (() => {
                window.clear_background (Color.BLACK);

                // Draw middle line
                for (int i = 0; i < SCREEN_HEIGHT; i += 20) {
                    Rectangle dash = new Rectangle (SCREEN_WIDTH / 2 - 2, i, 4, 10);
                    dash.draw (Color.WHITE, null, 0);
                }

                // Use draw_rounded to draw paddles with rounded corners
                float roundness = 0.5f; // Value between 0.0f and 1.0f
                int segments = 0; // Use 0 for automatic segments calculation
                paddle_left.draw_rounded (roundness, segments, 0.0f, Color.WHITE);
                paddle_right.draw_rounded (roundness, segments, 0.0f, Color.WHITE);


                // Draw the ball
                ball.draw (Color.WHITE);

                // Draw scores
                Font.DEFAULT.draw_text (score_left.to_string (),
                                        new Vector2 (SCREEN_WIDTH / 4, 20), 40, null, Color.WHITE);
                Font.DEFAULT.draw_text (score_right.to_string (),
                                        new Vector2 (3 * SCREEN_WIDTH / 4, 20), 40, null, Color.WHITE);
            });

            return true;
        }

        public static int main (string[] args) {
            var app = new PongGame ();
            return app.run (args);
        }
    }
}