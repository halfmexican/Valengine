using Valengine;
using Valengine.Shapes;
using Valengine.Input;
namespace Valengine {
    public class SnakeGame : GLib.Application {
        private Window window;
        private MainLoop loop;
        private uint timeout_id;

        private const int TILE_SIZE = 32;
        private const int ROWS = 30;
        private const int COLS = 20;
        private const int SCREEN_WIDTH = ROWS * TILE_SIZE;
        private const int SCREEN_HEIGHT = COLS * TILE_SIZE;

        private SnakeBody snake;
        private Food food;
        private bool game_over = false;
        private int score = 0;

        public SnakeGame () {
            Object (application_id: "io.github.valengine.snakegame", flags: ApplicationFlags.FLAGS_NONE);

            try {
                window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Snake");
            } catch (WindowError e) {
                error ("Failed to create window: %s", e.message);
                return;
            }
            window.target_fps = 10;

            reset_game ();

            loop = new MainLoop ();
            timeout_id = Timeout.add (1, () => {
                if (window.should_close) {
                    loop.quit ();
                    return false;
                }

                update ();
                draw ();

                return true;
            });

            loop.run ();

            window = null;
        }

        private void reset_game () {
            snake = new SnakeBody (ROWS / 2 * TILE_SIZE, COLS / 2 * TILE_SIZE);
            food = new Food (ROWS, COLS);
            game_over = false;
            score = 0;
        }

        private void update () {
            if (!game_over) {
                // First, update the snake's position
                snake.update (window.frame_time);

                // Check if the snake eats food
                if (snake.position.x == food.position[0] * TILE_SIZE &&
                    snake.position.y == food.position[1] * TILE_SIZE) {
                    score += 100;
                    snake.grow ();
                    food.respawn (ROWS, COLS);
                }

                // Now, check for collisions with walls or self-collision
                if (snake.position.x < 0 || snake.position.y < 0 ||
                    snake.position.x >= SCREEN_WIDTH || snake.position.y >= SCREEN_HEIGHT ||
                    snake.check_self_collision ()) {
                    game_over = true;
                    return;
                }
            } else {
                // Check for restart input when game is over
                if (Keyboard.is_pressed (Keyboard.Key.R)) {
                    reset_game ();
                }
            }
        }

        private void draw () {
            window.draw (() => {
                window.clear_background (Color.BLACK);
                // Draw vertical lines
                for (int i = 0; i <= SCREEN_WIDTH / TILE_SIZE; i++) {
                    Shapes.Line.draw (
                        new Vector2 (i * TILE_SIZE, 0),
                        new Vector2 (i * TILE_SIZE, SCREEN_HEIGHT),
                        Color.GRAY
                    );
                }

                // Draw horizontal lines
                for (int i = 0; i <= SCREEN_HEIGHT / TILE_SIZE; i++) {
                    Shapes.Line.draw (
                        new Vector2 (0, i * TILE_SIZE),
                        new Vector2 (SCREEN_WIDTH, i * TILE_SIZE),
                        Color.GRAY
                    );
                }
                if (!game_over) {
                    // Draw food
                    Rectangle food_rect = new Rectangle (
                        food.position[0] * TILE_SIZE,
                        food.position[1] * TILE_SIZE,
                        TILE_SIZE,
                        TILE_SIZE
                    );
                    food_rect.draw (Color.RED, null, 0.0f);

                    // Draw snake
                    foreach (var segment in snake.body_segments) {
                        Rectangle snake_rect = new Rectangle (
                            segment.x,
                            segment.y,
                            TILE_SIZE,
                            TILE_SIZE
                        );
                        snake_rect.draw (Color.GREEN, null, 0.0f);
                    }
                    // Draw score                    Font.DEFAULT.draw_text ("SCORE: " + score.to_string (), new Vector2 (10f, 20f), 20, 20, Color.BLACK);
                } else {
                    // Draw game over text
                    string game_over_text = "You lost! Press R to restart";
                    Font.DEFAULT.draw_text (game_over_text, new Vector2 ((SCREEN_WIDTH - 40) / 4, SCREEN_HEIGHT / 2 - 25), 40, null, Color.RED);
                }
            });
        }

        public static int main (string[] args) {
            var app = new SnakeGame ();
            return app.run (args);
        }
    }
}