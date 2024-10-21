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

        private int[] food_pos = new int[2];
        private int[] snake_pos = new int[2];
        private int snake_direction = 0;
        private int[,] snake_part_time;
        private int snake_length = 2;
        private int score = 0;
        private bool game_over = false;

        public SnakeGame () {
            Object (application_id: "io.github.valengine.snakegame", flags: ApplicationFlags.FLAGS_NONE);

            // Initialize the snake_part_time 2D array
            snake_part_time = new int[ROWS, COLS];

            // Initialize game variables
            food_pos[0] = Random.int_range (0, ROWS - 1);
            food_pos[1] = Random.int_range (0, COLS - 1);
            snake_pos[0] = ROWS / 2;
            snake_pos[1] = COLS / 2;

            try {
                window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Snake");
            } catch (WindowError e) {
                error ("Failed to create window: %s", e.message);
            }
            window.target_fps = 10;

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

            // Clean up resources

            window = null;
        }

        private void update () {
            if (!game_over) {
                // Update snake position based on direction
                switch (snake_direction) {
                    case 0: // Right
                        snake_pos[0] += 1;
                        break;
                    case 1: // Left
                        snake_pos[0] -= 1;
                        break;
                    case 2: // Down
                        snake_pos[1] += 1;
                        break;
                    case 3: // Up
                        snake_pos[1] -= 1;
                        break;
                    default:
                        break;
                }

                // Check for wall collision
                if (snake_pos[0] < 0 || snake_pos[1] < 0 || snake_pos[0] >= ROWS || snake_pos[1] >= COLS) {
                    game_over = true;
                    return;
                }

                // Check for self-collision
                if (snake_part_time[snake_pos[0], snake_pos[1]] > 0) {
                    game_over = true;
                    return;
                }

                // Update snake body times
                snake_part_time[snake_pos[0], snake_pos[1]] = snake_length;
                for (int i = 0; i < ROWS; i++) {
                    for (int j = 0; j < COLS; j++) {
                        if (snake_part_time[i, j] > 0)
                            snake_part_time[i, j] -= 1;
                    }
                }

                // Update direction based on input
                if (Keyboard.is_down (Keyboard.Key.LEFT))
                    snake_direction = 1;
                else if (Keyboard.is_down (Keyboard.Key.RIGHT))
                    snake_direction = 0;
                else if (Keyboard.is_down (Keyboard.Key.UP))
                    snake_direction = 3;
                else if (Keyboard.is_down (Keyboard.Key.DOWN))
                    snake_direction = 2;

                // Check for food collision
                if (snake_pos[0] == food_pos[0] && snake_pos[1] == food_pos[1]) {
                    score += 100;
                    snake_length++;
                    food_pos[0] = Random.int_range (0, ROWS - 1);
                    food_pos[1] = Random.int_range (0, COLS - 1);
                }
            } else {
                // Check for restart input
                if (Keyboard.is_down (Keyboard.Key.R)) {
                    restart_game();
                }
            }
        }

        private void restart_game() {
            // Reset game variables
            snake_pos[0] = ROWS / 2;
            snake_pos[1] = COLS / 2;
            snake_direction = 0;
            snake_length = 2;
            score = 0;
            game_over = false;

            // Clear the snake_part_time array
            for (int i = 0; i < ROWS; i++) {
                for (int j = 0; j < COLS; j++) {
                    snake_part_time[i, j] = 0;
                }
            }

            // Reposition food
            food_pos[0] = Random.int_range (0, ROWS - 1);
            food_pos[1] = Random.int_range (0, COLS - 1);
        }

        private void draw () {
            window.draw (() => {
                window.clear_background (Color.BLACK);
                // Draw vertical lines
                for (int i = 0; i <= SCREEN_WIDTH / TILE_SIZE; i++) {
                    Shapes.Line.draw (
                        new Vector2 (i * TILE_SIZE, 0),
                        new Vector2 (i * TILE_SIZE, SCREEN_HEIGHT),
                        Color.DARK_GRAY
                    );
                }

                // Draw horizontal lines
                for (int i = 0; i <= SCREEN_HEIGHT / TILE_SIZE; i++) {
                    Shapes.Line.draw (
                        new Vector2 (0, i * TILE_SIZE),
                        new Vector2 (SCREEN_WIDTH, i * TILE_SIZE),
                        Color.DARK_GRAY
                    );
                }
                if (!game_over) {
                    // Draw food
                    Rectangle food_rect = new Rectangle (food_pos[0] * TILE_SIZE, food_pos[1] * TILE_SIZE, TILE_SIZE, TILE_SIZE);
                    food_rect.draw (Color.RED, null, 0.0f);

                    // Draw snake
                    for (int i = 0; i < ROWS; i++) {
                        for (int j = 0; j < COLS; j++) {
                            if (snake_part_time[i, j] > 0) {
                                Rectangle snake_rect = new Rectangle (i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE);
                                snake_rect.draw (Color.GREEN, null, 0.0f);
                            }
                        }
                    }
                    // Draw score
                    Font.DEFAULT.draw_text ("SCORE: " + score.to_string (), new Vector2 (10f, 20f), 20, 20, Color.WHITE);
                } else {
                    // Draw game over text
                    string game_over_text = "You lost!";
                    Font.DEFAULT.draw_text (game_over_text, new Vector2 ((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2 - 25), 50, null, Color.RED);
                }
            });
        }

        public static int main (string[] args) {
            var app = new SnakeGame ();
            return app.run (args);
        }
    }
}