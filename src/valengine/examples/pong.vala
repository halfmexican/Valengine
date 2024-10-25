using Valengine;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class PongGame : GLib.Application {
        private Window window;
        private MainLoop loop;
        private TimeoutSource timeout;

        private const int SCREEN_WIDTH = 800;
        private const int SCREEN_HEIGHT = 450;
        private const float PADDLE_SPEED = 300;
        private const float BALL_SPEED = 300;

        private Rectangle paddle_left;
        private Rectangle paddle_right;
        private Circle ball;
        private Vector2 ball_velocity;
        private int score_left = 0;
        private int score_right = 0;

        private PongGame () {
            Object (application_id: "io.github.valengine.pong", flags: ApplicationFlags.FLAGS_NONE);
        }

        public override void activate () {
            try {
                window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Valengine Pong");
            } catch (WindowError e) {
                error (e.message);
            }

            // Initialize game objects
            paddle_left = new Rectangle (50, SCREEN_HEIGHT / 2 - 40, 15, 80);
            paddle_right = new Rectangle (SCREEN_WIDTH - 65, SCREEN_HEIGHT / 2 - 40, 15, 80);
            ball = new Circle (SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 10);
            reset_ball ();

            window.target_fps = 60;

            loop = new MainLoop ();
            timeout = new TimeoutSource (1);
            timeout.set_callback (main_loop);
            timeout.attach (loop.get_context ());

            loop.run ();
        }

        private void reset_ball () {
            ball.x = SCREEN_WIDTH / 2;
            ball.y = SCREEN_HEIGHT / 2;
            ball_velocity = new Vector2 (BALL_SPEED * (Random.int_range (0, 2) == 0 ? 1 : -1),
                                         BALL_SPEED * (Random.int_range (0, 2) == 0 ? 1 : -1));
        }

        private bool main_loop () {
            if (window.should_close) {
                loop.quit ();
                return false;
            }

            float delta = window.frame_time;

            // Update paddles
            if (Keyboard.is_down (Keyboard.Key.W) && paddle_left.y > 0)
                paddle_left.y -= PADDLE_SPEED * delta;
            if (Keyboard.is_down (Keyboard.Key.S) && paddle_left.y < SCREEN_HEIGHT - paddle_left.height)
                paddle_left.y += PADDLE_SPEED * delta;

            if (Keyboard.is_down (Keyboard.Key.UP) && paddle_right.y > 0)
                paddle_right.y -= PADDLE_SPEED * delta;
            if (Keyboard.is_down (Keyboard.Key.DOWN) && paddle_right.y < SCREEN_HEIGHT - paddle_right.height)
                paddle_right.y += PADDLE_SPEED * delta;

            // Update ball
            ball.x += ball_velocity.x * delta;
            ball.y += ball_velocity.y * delta;

            // Ball collisions
            if (ball.y <= 0 || ball.y >= SCREEN_HEIGHT)
                ball_velocity.y *= -1;

            // Paddle collisions
            if (ball.x - ball.radius <= paddle_left.x + paddle_left.width &&
                ball.y >= paddle_left.y && ball.y <= paddle_left.y + paddle_left.height)
                ball_velocity.x *= -1.1f; // Increase speed slightly on hits

            if (ball.x + ball.radius >= paddle_right.x &&
                ball.y >= paddle_right.y && ball.y <= paddle_right.y + paddle_right.height)
                ball_velocity.x *= -1.1f;

            // Score points
            if (ball.x < 0) {
                score_right++;
                reset_ball ();
            }
            if (ball.x > SCREEN_WIDTH) {
                score_left++;
                reset_ball ();
            }

            // Draw
            window.draw (() => {
                window.clear_background (Color.BLACK);

                // Draw middle line
                for (int i = 0; i < SCREEN_HEIGHT; i += 20) {
                    Rectangle dash = new Rectangle (SCREEN_WIDTH / 2 - 2, i, 4, 10);
                    dash.draw (Color.WHITE, null, 0);
                }

                // Draw game objects
                paddle_left.draw (Color.WHITE, null, 0);
                paddle_right.draw (Color.WHITE, null, 0);
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